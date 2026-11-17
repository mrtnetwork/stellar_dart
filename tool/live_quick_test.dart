import 'dart:io';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';

final String _horizonUrl =
    Platform.environment['STELLAR_HORIZON_URL'] ??
    'https://horizon-testnet.stellar.org';
final String _rpcUrl =
    Platform.environment['STELLAR_RPC_URL'] ??
    'https://soroban-testnet.stellar.org';
final String _expectedPassphrase =
    Platform.environment['STELLAR_PASSPHRASE'] ??
    'Test SDF Network ; September 2015';

class _IoService with StellarServiceProvider {
  _IoService({HttpClient? client}) : client = client ?? HttpClient();
  final HttpClient client;

  @override
  Future<BaseServiceResponse> doRequest(
    StellarRequestDetails params, {
    Duration? timeout,
  }) async {
    final base = params.api == StellarAPIType.horizon ? _horizonUrl : _rpcUrl;
    final uri = params.encodeUrl(base);
    final t = timeout ?? const Duration(seconds: 30);
    final HttpClientRequest req;
    if (params.requestMethod.isPost) {
      req = await client.postUrl(uri).timeout(t);
    } else {
      req = await client.getUrl(uri).timeout(t);
    }
    params.headers.forEach(req.headers.set);
    final body = params.encodeBody();
    if (body != null && body.isNotEmpty) req.add(body);
    final resp = await req.close().timeout(t);
    final bytes = await resp
        .fold<List<int>>(<int>[], (p, e) => p..addAll(e))
        .timeout(t);
    return params.toResponse(bytes, statusCode: resp.statusCode);
  }
}

int _failures = 0;

/// Explicit check: `assert()` is stripped when asserts are disabled
/// (plain `dart tool/...` runs), so live verification must throw.
void _check(bool cond, String message) {
  if (!cond) throw StateError(message);
}

Future<T> _step<T>(String name, Future<T> Function() fn) async {
  try {
    final r = await fn();
    stdout.writeln('PASS $name');
    return r;
  } catch (e) {
    _failures++;
    stdout.writeln('FAIL $name: $e');
    rethrow;
  }
}

Future<T?> _stepOptional<T>(String name, Future<T> Function() fn) async {
  try {
    final r = await fn();
    stdout.writeln('PASS $name');
    return r;
  } catch (e) {
    stdout.writeln('SKIP $name: $e');
    return null;
  }
}

Future<void> main() async {
  blockchainUtils.setDartApi();
  final service = _IoService();
  final provider = StellarProvider(service);
  final quick = DefaultStellarQuickClient(
    horizonProvider: provider,
    rpcProvider: provider,
  );

  // 1. RPC network + passphrase.
  final network = await _step('rpc.getNetwork', () => quick.getNetwork());
  _check(
    network.passphrase == _expectedPassphrase,
    'bad passphrase: ${network.passphrase}',
  );
  final passphrase = await _step('rpc.passphrase', () => quick.passphrase());
  _check(passphrase == _expectedPassphrase, 'bad passphrase: $passphrase');
  await _step(
    'rpc.validateRpcNetwork',
    () => quick.validateRpcNetwork(expectedPassphrase: _expectedPassphrase),
  );

  // 2. Latest ledger via RPC.
  final latest = await _step(
    'rpc.getLatestLedger',
    () => quick.getLatestLedger(),
  );
  final latestSeq = (latest.sequence ?? -1).toInt();
  stdout.writeln(
    '  latest ledger: $latestSeq (protocol ${latest.protocolVersion})',
  );
  _check(latestSeq > 0, 'bad latest sequence: $latestSeq');

  // 3. Horizon liveness + base reserve.
  await _step('horizon.validateHorizon', () => quick.validateHorizon());
  final reserve = await _step(
    'horizon.getBaseReserve',
    () => quick.getBaseReserve(),
  );
  stdout.writeln('  base reserve: $reserve stroops');
  _check(reserve > 0, 'bad reserve: $reserve');

  // 4. Horizon fee stats + assets directory.
  await _step('horizon.feeStats', () => quick.feeStats());
  final assets = await _step(
    'horizon.getAssets(limit 1)',
    () => quick.getAssets(limit: 1),
  );
  stdout.writeln('  assets records: ${assets.embedded?.records?.length ?? 0}');

  // 5. Find a recent ledger with transactions, then exercise tx paths.
  String? txHash;
  var seq = latestSeq;
  for (var i = 0; i < 10 && txHash == null; i++, seq--) {
    final txs = await _step(
      'horizon.ledgerTransactions($seq)',
      () => provider.request(
        HorizonRequestRetrieveALedgersTransactions(sequence: seq, limit: 5),
      ),
    );
    final first =
        (txs.embedded?.records?.isEmpty ?? true)
            ? null
            : txs.embedded!.records!.first;
    if (first != null) {
      txHash = first.hash;
      stdout.writeln('  sample tx: $txHash (ledger $seq)');
    }
  }
  _check(txHash != null, 'no transactions in last 10 ledgers');

  // 6. Transaction status via the quick client (Horizon).
  final status = await _step(
    'quick.transactionStatus',
    () => quick.transactionStatus(txHash!),
  );
  stdout.writeln('  tx status: ${status.name}');
  await _step('rpc.rpcTransaction', () => quick.rpcTransaction(txHash!));

  // 7. Account + balances from a sampled transaction whose source still
  // exists (merged sources 404 -> null, wallet parity).
  StellarAddress? source;
  HorizonAccountEmbeddedRecordsItem? account;
  var accSeq = seq;
  for (var i = 0; i < 10 && account == null; i++, accSeq--) {
    final accTxs = await _step(
      'horizon.ledgerTransactions($accSeq)',
      () => provider.request(
        HorizonRequestRetrieveALedgersTransactions(sequence: accSeq, limit: 10),
      ),
    );
    for (final t
        in accTxs.embedded?.records ??
            const <HorizonTransactionEmbeddedRecordsItem>[]) {
      final candidate = await _step(
        'quick.getAccount',
        () => quick.getAccount(StellarAddress.fromBase32Addr(t.sourceAccount)),
      );
      if (candidate != null) {
        source = StellarAddress.fromBase32Addr(t.sourceAccount);
        account = candidate;
        break;
      }
    }
  }
  _check(account != null, 'no existing source account in last 10 ledgers');
  final balances = await _step(
    'quick.getAccountBalances',
    () => quick.getAccountBalances(source!),
  );
  _check(balances.isNotEmpty, 'expected at least the native balance');
  stdout.writeln('  balances: ${balances.length}');
  final missing = await _step(
    'quick.getAccount(404 -> null)',
    () => quick.getAccount(
      // Valid strkey derived from a fixed string nobody funds.
      StellarPrivateKey.fromBytes(
        QuickCrypto.sha256Hash(
          'stellar_dart2 live test missing account'.codeUnits,
        ).toList(),
      ).toPublicKey().toAddress(),
    ),
  );
  _check(missing == null, 'expected null for missing account');

  // 8. Raw RPC top methods.
  await _step(
    'rpc.getFeeStats',
    () => provider.request(const StellarRpcRequestGetFeeStats()),
  );
  await _step(
    'rpc.getHealth',
    () => provider.request(const StellarRpcRequestGetHealth()),
  );
  await _step(
    'rpc.getVersionInfo',
    () => provider.request(const StellarRpcRequestGetVersionInfo()),
  );
  await _step(
    'rpc.getLedgers',
    () => provider.request(
      StellarRpcRequestGetLedgers(startLedger: latestSeq - 1),
    ),
  );
  await _stepOptional(
    'rpc.getEvents (server may require filters)',
    () => provider.request(
      StellarRpcRequestGetEvents(
        startLedger: latestSeq - 10,
        endLedger: latestSeq,
      ),
    ),
  );

  // 9. Writes are intentionally not exercised live.
  stdout.writeln('SKIP submit/simulate (needs funded account + envelope)');

  if (_failures > 0) {
    stdout.writeln('LIVE TEST FAILED ($_failures failures)');
    exit(1);
  }
  stdout.writeln('LIVE TEST OK');
  exit(0);
}
