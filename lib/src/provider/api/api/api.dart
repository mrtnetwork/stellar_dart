import 'dart:async';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/keypair/keypair.dart';
import 'package:stellar_dart/src/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/methods/horizon/methods.dart';
import 'package:stellar_dart/src/provider/methods/rpc/methods.dart';

import '../models/api_models.dart';

/// Quick client API: one method per top request, each mapped to the correct
/// backend and returning a single unified result type.
///
/// Design follows `StellarQuickClientApi`: consumers depend on this mixin
/// instead of raw request classes. Stellar backends are complementary, so
/// there are two providers — Horizon for chain reads/writes with curated
/// history, Stellar RPC (ex-Soroban) for real-time state, simulation and
/// submission — and each method is pinned to its backend.
///
/// Wallet parity notes (base-native adaptations):
/// - Balances/assets return the generated Horizon types directly
///   ([HorizonAccountEmbeddedRecordsItemBalancesItem],
///   [HorizonResponseListAllAssets]) instead of wallet `Token`/`APPImage`
///   store wrappers.
/// - `transactionStatus` takes the tx hash directly (the wallet only used
///   `transaction.txId`) and returns [StellarTxStatus].
/// - `getAccountTokensStream` / token-store metadata refill stay in the
///   wallet (streaming + store infra, not provider calls).
/// - Horizon has no generated root (`/`) or `/health` in the spec bundle;
///   [validateHorizon] is a liveness read. Passphrase checks go through
///   RPC [getNetwork] (see [validateRpcNetwork]).
mixin StellarQuickClientApi {
  /// Horizon provider: accounts, assets, ledgers, transactions, fee stats,
  /// submission (sync).
  IProvider<IServiceProvider, StellarRequestDetails> get horizonProvider;

  /// Stellar RPC provider: network, simulation, submission (async), ledger
  /// entries, events, transaction polling.
  IProvider<IServiceProvider, StellarRequestDetails> get rpcProvider;

  /// Account record of [address], or null when Horizon answers 404
  /// (wallet parity).
  Future<HorizonAccountEmbeddedRecordsItem?> getAccount(
    StellarAddress address,
  ) async {
    try {
      return await horizonProvider.request(
        HorizonRequestRetrieveAnAccount(accountId: address.baseAddress),
      );
    } on RPCError catch (e) {
      if (e.statusCode == 404 || e.errorCode == 404) return null;
      rethrow;
    }
  }

  /// Base-native balances of [address] (empty when the account is missing).
  Future<List<HorizonAccountEmbeddedRecordsItemBalancesItem>>
  getAccountBalances(StellarAddress address) async {
    final account = await getAccount(address);
    return account?.balances ?? const [];
  }

  /// Asset directory lookup (metadata discovery for the wallet token flow).
  Future<HorizonResponseListAllAssets> getAssets({
    String? assetCode,
    String? assetIssuer,
    int? cursor,
    HorizonOrder? order,
    int? limit,
  }) {
    return horizonProvider.request(
      HorizonRequestListAllAssets(
        assetCode: assetCode,
        assetIssuer: assetIssuer,
        cursor: cursor,
        order: order,
        limit: limit,
      ),
    );
  }

  /// Base reserve in stroops from the latest ledger (wallet parity).
  Future<int> getBaseReserve() async {
    final r = await horizonProvider.request(
      const HorizonRequestListAllLedgers(),
    );
    final records = r.embedded?.records;
    final first = (records == null || records.isEmpty) ? null : records.first;
    final reserve = first?.baseReserveInStroops;
    if (reserve == null) {
      throw const BuError(
        DefaultErrorType.invalidState,
        'Missing base reserve.',
      );
    }
    return reserve;
  }

  /// Horizon fee stats (wallet `feeState` parity).
  Future<HorizonFeeStats> feeStats() {
    return horizonProvider.request(const HorizonRequestRetrieveFeeStats());
  }

  /// Horizon liveness read (the generated spec has no root `/` or
  /// `/health`; wallet `validateHorizon` compared the root passphrase —
  /// compare passphrases via [validateRpcNetwork] instead).
  Future<bool> validateHorizon() async {
    await horizonProvider.request(const HorizonRequestListAllLedgers(limit: 1));
    return true;
  }

  /// Submits [envelopeXdr] via Horizon (sync; wallet `submitTx` parity).
  Future<StellarSubmitResult> submitTransaction(String envelopeXdr) async {
    final transaction = await horizonProvider.request(
      HorizonRequestSubmitATransaction(tx: envelopeXdr),
    );
    final hash = transaction.hash ?? transaction.id;
    return StellarSubmitResult(
      hash: hash ?? envelopeXdr,
      submitted: hash != null,
      transaction: transaction,
    );
  }

  /// Status of a transaction by hash: failed when Horizon reports
  /// `successful: false`, block otherwise (wallet parity).
  Future<StellarTxStatus> transactionStatus(String txHash) async {
    final tx = await horizonProvider.request(
      HorizonRequestRetrieveATransaction(transactionHash: txHash),
    );
    if (tx.successful == false) return StellarTxStatus.failed;
    return StellarTxStatus.block;
  }

  // ---- Classic balances and transactions (swap parity). ----
  //
  // Horizon balance strings ("1.5") are decimal XLM; stroops are the
  // base-native unit (1 XLM = 10^7 stroops).

  /// Base fee per classic operation in stroops (swap parity).
  static const int baseFeePerOperation = 100;

  /// Parses a Horizon balance string to stroops.
  static BigInt parseBalanceToStroops(String amount) {
    final units =
        BigRational.parseDecimal(amount) * BigRational(BigInt.from(10000000));
    return units.toBigInt();
  }

  /// Native (XLM) balance of [address] in stroops (zero when missing).
  Future<BigInt> getNativeBalance(StellarAddress address) async {
    final balances = await getAccountBalances(address);
    BigInt sum = BigInt.zero;
    for (final b in balances) {
      if (b is HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative) {
        sum += parseBalanceToStroops(b.value.balance);
      }
    }
    return sum;
  }

  /// Balance of the `assetCode`/`issuer` trustline in stroops (zero when
  /// the account or line is missing).
  Future<BigInt> getAssetBalance({
    required StellarAddress account,
    required String assetCode,
    required StellarAddress issuer,
  }) async {
    final balances = await getAccountBalances(account);
    for (final b in balances) {
      if (b is HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset &&
          b.value.assetCode == assetCode &&
          b.value.assetIssuer == issuer.baseAddress) {
        return parseBalanceToStroops(b.value.balance);
      }
    }
    return BigInt.zero;
  }

  /// Builds an unsigned classic transaction for [source] (sequence + 1,
  /// `feePerOperation * operations.length`). Resolves the network id from
  /// [networkPassphrase] or RPC [getNetwork].
  Future<StellarClassicTransaction> buildClassicTransaction({
    required StellarAddress source,
    required List<Operation> operations,
    StellarMemo? memo,
    String? networkPassphrase,
    int feePerOperation = baseFeePerOperation,
  }) async {
    final account = await getAccount(source);
    if (account == null) {
      throw BuError(
        DefaultErrorType.notFound,
        'Account not found.',
        details: {'address': source.baseAddress},
      );
    }
    final tx = StellarTransactionV1(
      sourceAccount: MuxedAccount(source),
      fee: feePerOperation * operations.length,
      seqNum: BigintUtils.parse(account.sequence) + BigInt.one,
      memo: memo ?? const StellarMemoNone(),
      operations: operations,
    );
    final resolved = networkPassphrase ?? await passphrase();
    final payload = TransactionSignaturePayload(
      networkId: StellarNetwork.fromPassphrase(resolved).passphraseHash,
      taggedTransaction: tx,
    );
    return StellarClassicTransaction(
      transaction: tx,
      payloadHash: payload.txHash(),
    );
  }

  /// Submits [envelopeXdr] via Horizon, returning the hash. Throws when
  /// Horizon reports failure or answers without a hash.
  Future<String> submitChecked(String envelopeXdr) async {
    final response = await horizonProvider.request(
      HorizonRequestSubmitATransaction(tx: envelopeXdr),
    );
    final hash = response.hash;
    if (response.successful != true || hash == null) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Stellar transaction failed.',
        details: {'hash': hash},
      );
    }
    return hash;
  }

  /// Polls Horizon until [transactionId] confirms. Completes on
  /// `successful: true`, throws on `successful: false` or [timeout].
  /// Transport failures are ignored between polls.
  Future<void> trackHorizonTransaction({
    required String transactionId,
    Duration timeout = const Duration(minutes: 2),
    Duration periodicTimeOut = const Duration(seconds: 3),
  }) async {
    Timer? timer;
    try {
      final Completer<void> completer = Completer<void>();
      timer = Timer.periodic(periodicTimeOut, (_) async {
        if (completer.isCompleted) return;
        try {
          final receipt = await horizonProvider.request(
            HorizonRequestRetrieveATransaction(transactionHash: transactionId),
          );
          if (receipt.successful == true) {
            completer.complete();
          } else if (receipt.successful == false) {
            completer.completeError(
              const BuError(
                DefaultErrorType.invalidArgument,
                'Stellar transaction failed.',
              ),
            );
          }
        } catch (_) {}
      });
      await completer.future.timeout(timeout);
    } on TimeoutException {
      throw const BuError(
        DefaultErrorType.invalidState,
        'Transaction confirmation failed within the allotted timeout.',
      );
    } finally {
      timer?.cancel();
      timer = null;
    }
  }

  /// Sequence of the latest ledger known to RPC.
  Future<int> latestLedgerSequence() async {
    final r = await getLatestLedger();
    final sequence = r.sequence?.toInt();
    if (sequence == null) {
      throw const BuError(
        DefaultErrorType.invalidState,
        'Missing latest ledger.',
      );
    }
    return sequence;
  }

  /// RPC network descriptor (passphrase, protocol version, faucet URL).
  Future<StellarRpcGetNetworkResult> getNetwork() {
    return rpcProvider.request(const StellarRpcRequestGetNetwork());
  }

  /// Network passphrase from RPC (wallet `passphrase` parity).
  Future<String> passphrase() async {
    final r = await getNetwork();
    return r.passphrase;
  }

  /// True when the RPC node serves [expectedPassphrase].
  Future<bool> validateRpcNetwork({required String expectedPassphrase}) async {
    return await passphrase() == expectedPassphrase;
  }

  /// Simulates [envelopeXdr] without submitting (Soroban footprint, auth,
  /// resource fee).
  Future<StellarRpcSimulateTransactionResult> simulateTransaction({
    required String envelopeXdr,
    StellarRpcSimulateTransactionParamsResourceConfig? resourceConfig,
    StellarRpcSimulateTransactionParamsAuthMode? authMode,
  }) {
    return rpcProvider.request(
      StellarRpcRequestSimulateTransaction(
        transaction: envelopeXdr,
        resourceConfig: resourceConfig,
        authMode: authMode,
      ),
    );
  }

  /// Submits [envelopeXdr] via RPC (async: validate + enqueue, then poll
  /// [rpcTransaction]).
  Future<StellarRpcSendTransactionResult> sendTransaction(String envelopeXdr) {
    return rpcProvider.request(
      StellarRpcRequestSendTransaction(transaction: envelopeXdr),
    );
  }

  /// Polls an RPC-submitted transaction by hash.
  Future<StellarRpcGetTransactionResult> rpcTransaction(String hash) {
    return rpcProvider.request(StellarRpcRequestGetTransaction(hash: hash));
  }

  /// Latest ledger known to RPC.
  Future<StellarRpcGetLatestLedgerResult> getLatestLedger() {
    return rpcProvider.request(const StellarRpcRequestGetLatestLedger());
  }

  /// Live ledger entries by key (accounts, trustlines, offers, contract
  /// state/code).
  Future<StellarRpcGetLedgerEntriesResult> getLedgerEntries(List<String> keys) {
    return rpcProvider.request(StellarRpcRequestGetLedgerEntries(keys: keys));
  }

  // ---- Transaction assembly (simulate -> assemble -> sign -> send -> poll).
  //
  // The typical Soroban flow: build an unsigned V1 envelope, simulate it,
  // assemble (footprint + auth + resource fee), sign, send, poll.

  /// Decodes a base64 envelope, requiring a V1 transaction envelope.
  TransactionV1Envelope _decodeV1Envelope(String envelopeBase64) {
    final bytes = StringUtils.encode(
      envelopeBase64,
      encoding: StringEncoding.base64,
    );
    return Envelope.fromXdr(bytes).cast<TransactionV1Envelope>();
  }

  /// Applies simulation output to an unsigned V1 [unsignedEnvelopeBase64]:
  /// recorded auths, Soroban footprint and the resource fee.
  ///
  /// Runs simulation first unless [simulation] is provided. Throws when
  /// simulation reports an error. When the result [needsRestore], submit a
  /// restore transaction built with [buildRestoreTransaction] first.
  Future<StellarAssembledTransaction> assembleTransaction({
    required String unsignedEnvelopeBase64,
    StellarRpcSimulateTransactionResult? simulation,
    int extraFeeStroops = 0,
  }) async {
    final envelope = _decodeV1Envelope(unsignedEnvelopeBase64);
    final sim =
        simulation ??
        await simulateTransaction(envelopeXdr: unsignedEnvelopeBase64);
    if (sim.error != null) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Transaction simulation failed.',
        details: {'error': sim.error},
      );
    }
    final tx = envelope.tx;
    final minResourceFee = sim.minResourceFee ?? '0';

    // Pair each result with the i-th invoke operation in order.
    final invokeIndexes = <int>[];
    for (var i = 0; i < tx.operations.length; i++) {
      if (tx.operations[i].body is InvokeHostFunctionOperation) {
        invokeIndexes.add(i);
      }
    }
    final results = sim.results ?? const [];
    final operations = tx.operations.toList();
    for (var i = 0; i < invokeIndexes.length && i < results.length; i++) {
      final op = operations[invokeIndexes[i]];
      final body = op.body as InvokeHostFunctionOperation;
      final auths =
          results[i].auth
              .map(
                (a) => SorobanAuthorizationEntry.fromXdr(
                  StringUtils.encode(a, encoding: StringEncoding.base64),
                ),
              )
              .toList();
      operations[invokeIndexes[i]] = Operation(
        sourceAccount: op.sourceAccount,
        body: body.copyWith(auth: auths),
      );
    }

    SorobanTransactionDataExt sorobanData = const SorobanTransactionDataExt();
    final transactionData = sim.transactionData;
    if (transactionData != null) {
      sorobanData = SorobanTransactionDataExt(
        sorobanTransactionData: SorobanTransactionData.fromXdr(
          StringUtils.encode(transactionData, encoding: StringEncoding.base64),
        ),
      );
    }

    final assembled = envelope.copyWith(
      tx: tx.copyWith(
        operations: operations,
        sorobanData: sorobanData,
        fee: tx.fee + IntUtils.parse(minResourceFee) + extraFeeStroops,
      ),
    );
    final network = await getNetwork();
    final txId = assembled.txId(
      StellarNetwork.fromPassphrase(network.passphrase).passphraseHash,
    );
    return StellarAssembledTransaction(
      envelopeBase64: assembled.toVariantXDRBase64(),
      txId: txId,
      needsRestore: sim.restorePreamble != null,
      restorePreamble: sim.restorePreamble,
      minResourceFee: minResourceFee,
    );
  }

  /// Builds an unsigned restore-footprint transaction from a simulation
  /// [preamble]. Sign, submit and confirm it before the assembled call.
  Future<String> buildRestoreTransaction({
    required StellarAddress source,
    required StellarRpcSimulateTransactionResultRestorePreamble preamble,
    BigInt? seqNum,
    int? fee,
  }) async {
    final seq = seqNum ?? await nextSequence(source);
    final inclusionFee = fee ?? await suggestedInclusionFee();
    final tx = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: inclusionFee + IntUtils.parse(preamble.minResourceFee),
      seqNum: seq,
      operations: [Operation(body: RestoreFootprintOperation())],
      sorobanData: SorobanTransactionDataExt(
        sorobanTransactionData: SorobanTransactionData.fromXdr(
          StringUtils.encode(
            preamble.transactionData,
            encoding: StringEncoding.base64,
          ),
        ),
      ),
    );
    return TransactionV1Envelope(tx: tx, signatures: []).toVariantXDRBase64();
  }

  /// Polls `getTransaction` until [hash] reaches SUCCESS or FAILED.
  Future<StellarRpcGetTransactionResult> pollTransaction(
    String hash, {
    Duration timeout = const Duration(seconds: 60),
    Duration interval = const Duration(seconds: 2),
  }) async {
    final deadline = DateTime.now().add(timeout);
    for (;;) {
      final r = await rpcTransaction(hash);
      if (r.status == StellarRpcGetTransactionResultStatus.success ||
          r.status == StellarRpcGetTransactionResultStatus.failed) {
        return r;
      }
      if (DateTime.now().isAfter(deadline)) {
        throw BuError(
          DefaultErrorType.invalidState,
          'Transaction $hash not confirmed within $timeout.',
        );
      }
      await Future<void>.delayed(interval);
    }
  }

  /// Signs an unsigned [envelopeBase64] with [signer], returning the
  /// signed envelope (base64). Resolves the network id from [getNetwork]
  /// unless [networkPassphrase] is given.
  Future<String> signEnvelope({
    required String envelopeBase64,
    required StellarPrivateKey signer,
    String? networkPassphrase,
  }) async {
    final envelope = _decodeV1Envelope(envelopeBase64);
    final resolved = networkPassphrase ?? await passphrase();
    final payload = TransactionSignaturePayload(
      networkId: StellarNetwork.fromPassphrase(resolved).passphraseHash,
      taggedTransaction: envelope.tx,
    );
    final signed = envelope.copyWith(
      signatures: [...envelope.signatures, signer.sign(payload.txHash())],
    );
    return signed.toVariantXDRBase64();
  }

  /// Next sequence number for [address] (`sequence + 1`).
  Future<BigInt> nextSequence(StellarAddress address) async {
    final account = await getAccount(address);
    if (account == null) {
      throw BuError(
        DefaultErrorType.notFound,
        'Account not found.',
        details: {'address': address.baseAddress},
      );
    }
    return BigintUtils.parse(account.sequence) + BigInt.one;
  }

  /// Suggested inclusion fee in stroops (RPC fee stats, p95, with fallbacks).
  Future<int> suggestedInclusionFee({bool soroban = false}) async {
    final stats = await rpcProvider.request(
      const StellarRpcRequestGetFeeStats(),
    );
    final table = soroban ? stats.sorobanInclusionFee : stats.inclusionFee;
    final raw = table?.p95 ?? table?.mode ?? table?.max ?? '100';
    return IntUtils.tryParse(raw) ?? 100;
  }

  // ---- Ledger-key builders (base64 keys for [getLedgerEntries]). ----

  /// Base64 `LedgerKey` for an account entry.
  String ledgerKeyForAccount(StellarAddress address) {
    return LedgerKeyAccount(address.toPublicKey()).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for a trustline entry.
  String ledgerKeyForTrustline({
    required StellarAddress account,
    required StellarAsset asset,
  }) {
    return LedgerKeyTrustLine(
      accountId: account.toPublicKey(),
      asset: asset,
    ).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for an offer entry.
  String ledgerKeyForOffer({
    required StellarAddress seller,
    required BigInt offerId,
  }) {
    return LedgerKeyOffer(
      accountId: seller.toPublicKey(),
      offerId: offerId,
    ).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for an account data entry.
  String ledgerKeyForData({
    required StellarAddress account,
    required String dataName,
  }) {
    return LedgerKeyData(
      accountId: account.toPublicKey(),
      dataName: dataName,
    ).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for a claimable balance entry.
  String ledgerKeyForClaimableBalance(ClaimableBalanceId balanceId) {
    return LedgerKeyClaimableBalance(balanceId).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for a liquidity pool entry.
  String ledgerKeyForLiquidityPool(List<int> liquidityPoolId) {
    return LedgerKeyLiquidityPool(liquidityPoolId).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for a contract data entry.
  String ledgerKeyForContractData({
    required ScAddress contract,
    required ScVal key,
    ContractDataDurability durability = ContractDataDurability.persistent,
  }) {
    return LedgerKeyContractData(
      contract: contract,
      key: key,
      durability: durability,
    ).toVariantXDRBase64();
  }

  /// Base64 `LedgerKey` for a contract code entry.
  String ledgerKeyForContractCode(List<int> wasmHash) {
    return LedgerKeyContractCode(wasmHash).toVariantXDRBase64();
  }
}
