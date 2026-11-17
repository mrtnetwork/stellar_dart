// Shared plumbing for the Stellar testnet examples (Horizon + Soroban RPC + friendbot).
// Everything goes through [DefaultStellarQuickClient].

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:http/http.dart' as http;
import 'package:stellar_dart/stellar_dart.dart';

/// Horizon testnet endpoint.
const String stellarHorizonUrl = 'https://horizon-testnet.stellar.org';

/// Stellar RPC (Soroban) testnet endpoint.
const String stellarRpcUrl = 'https://soroban-testnet.stellar.org';

/// Testnet funding endpoint.
const String stellarFriendbotUrl = 'https://friendbot.stellar.org';

/// HTTP service provider for [StellarProvider].
class StellarHttpService with StellarServiceProvider {
  StellarHttpService({
    http.Client? client,
    this.horizon = stellarHorizonUrl,
    this.rpc = stellarRpcUrl,
    this.defaultRequestTimeout = const Duration(seconds: 30),
  }) : client = client ?? http.Client();

  final http.Client client;
  final String horizon;
  final String rpc;
  final Duration defaultRequestTimeout;

  @override
  Future<BaseServiceResponse> doRequest(
    StellarRequestDetails params, {
    Duration? timeout,
  }) async {
    final url = params.api == StellarAPIType.horizon ? horizon : rpc;
    final limit = timeout ?? defaultRequestTimeout;
    for (var attempt = 0;; attempt++) {
      try {
        final response = params.requestMethod.isPost
            ? await client
                .post(
                  params.encodeUrl(url),
                  headers: params.headers,
                  body: params.encodeBody(),
                )
                .timeout(limit)
            : await client
                .get(params.encodeUrl(url), headers: params.headers)
                .timeout(limit);
        return params.toResponse(
          response.bodyBytes,
          statusCode: response.statusCode,
        );
      } catch (e) {
        /// The public testnet occasionally resets a connection; retrying the
        /// same request is safe for every method the examples use.
        if (attempt >= 2) rethrow;
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
  }
}

/// A live connection to the Stellar testnet plus the helpers the examples use.
class StellarTestnet {
  StellarTestnet._(this.horizonProvider, this.rpcProvider, this._client);

  final StellarProvider horizonProvider;
  final StellarProvider rpcProvider;
  final http.Client _client;

  late final DefaultStellarQuickClient quick = DefaultStellarQuickClient(
    horizonProvider: horizonProvider,
    rpcProvider: rpcProvider,
  );

  static Future<StellarTestnet> connect() async {
    final service = StellarHttpService();
    final horizon = StellarProvider<StellarHttpService>(service);
    final rpc = StellarProvider<StellarHttpService>(service);
    final testnet = StellarTestnet._(horizon, rpc, service.client);
    await testnet.checkNetwork();
    return testnet;
  }

  void close() => _client.close();

  /// Fails early when the endpoints do not serve the testnet passphrase.
  Future<void> checkNetwork() async {
    final passphrase = await quick.passphrase();
    if (passphrase != StellarNetwork.testnet.passphrase) {
      throw StateError(
        'expected the testnet passphrase, got "$passphrase"',
      );
    }
    await quick.validateHorizon();
  }

  Future<int> ledger() => quick.latestLedgerSequence();

  /// Native (XLM) balance of [address] in stroops.
  Future<BigInt> balanceOf(StellarAddress address) =>
      quick.getNativeBalance(address);

  /// Funds [address] from the testnet friendbot, unless it already has XLM.
  ///
  /// The friendbot tops up existing accounts as well as creating new ones, so
  /// the same call works on every rerun.
  Future<void> fund(StellarAddress address) async {
    final balance = await balanceOf(address);
    if (balance > BigInt.zero) return;
    final response = await _client.get(
      Uri.parse('$stellarFriendbotUrl?addr=${address.baseAddress}'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw StateError(
        'friendbot refused ${address.baseAddress}: '
        '${response.statusCode} ${response.body}',
      );
    }
    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while (DateTime.now().isBefore(deadline)) {
      if (await balanceOf(address) > BigInt.zero) return;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    throw StateError('account ${address.baseAddress} was not funded');
  }

  /// Funds the account of [index] and returns its address.
  Future<StellarAccountAddress> fundAccount(int index) async {
    final address = stellarKey(index).toPublicKey().toAddress();
    await fund(address);
    return address;
  }

  /// Builds, signs and submits [operations] from [source], then waits for the
  /// transaction to be included in a ledger.
  Future<String> submit({
    required StellarAddress source,
    required List<Operation> operations,
    List<StellarPrivateKey> signers = const [],
    StellarMemo memo = const StellarMemoNone(),
  }) async {
    final built = await quick.buildClassicTransaction(
      source: source,
      operations: operations,
      memo: memo,
    );
    final envelope = TransactionV1Envelope(
      tx: built.transaction,
      signatures: [
        for (final signer in signers) signer.sign(built.payloadHash)
      ],
    );
    final hash = await quick.submitChecked(envelope.toVariantXDRBase64());
    await quick.trackHorizonTransaction(transactionId: hash);
    return hash;
  }

  /// True when [address] exists on the ledger.
  Future<bool> exists(StellarAddress address) async =>
      await quick.getAccount(address) != null;
}

/// Deterministic account key for [index].
///
/// The seed is `sha256("stellar_dart/example", index)`, so the same index
/// always gives the same key pair on every run.
StellarPrivateKey stellarKey(int index) {
  final seed = QuickCrypto.sha256Hash([
    ...'stellar_dart/example'.codeUnits,
    ...utf8.encode(':$index'),
  ]);
  return StellarPrivateKey.fromBytes(seed);
}

/// Deterministic account keys for [index].
StellarAccountAddress stellarAccount(int index) =>
    stellarKey(index).toPublicKey().toAddress();

/// The asset `code` issued by [issuer].
StellarAsset stellarAsset({
  required StellarAddress issuer,
  required String code,
}) {
  final publicKey = issuer.toPublicKey();
  if (code.length <= 4) {
    return StellarAssetCreditAlphanum4(issuer: publicKey, code: code);
  }
  return StellarAssetCreditAlphanum12(issuer: publicKey, code: code);
}

/// Formats a stroop amount as a decimal XLM string.
String formatStroops(BigInt stroops) =>
    StellarHelper.fromStroop(stroops).toString();

/// Formats a signed stroop change.
String formatSigned(BigInt delta) {
  final sign = delta.isNegative ? '-' : '+';
  return '$sign${formatStroops(delta.abs())}';
}

/// Prints a two-column `name : value` line.
String field(String name, String value) {
  return '  ${name.padRight(20)} $value';
}
