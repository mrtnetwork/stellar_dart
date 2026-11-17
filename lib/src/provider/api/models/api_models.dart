// Unified result types for [StellarQuickClientApi] (wallet parity, base-native).
//
// One unified type per top call so consumers never touch raw request classes
// for submission/status.
// Balances and assets use the generated Horizon types directly
// ([HorizonAccountEmbeddedRecordsItemBalancesItem],
// [HorizonResponseListAllAssets]), so no wrappers are needed here.
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/provider/methods/horizon/methods.dart';
import 'package:stellar_dart/src/provider/methods/rpc/methods.dart';

/// Unified transaction status across the Horizon API (wallet
/// `WalletTransactionStatus` parity for the block/failed cases).
enum StellarTxStatus {
  /// The transaction is confirmed in a block.
  block,

  /// The transaction was executed with `successful: false`.
  failed,
}

/// Result of [StellarQuickClientApi.submitTransaction] (wallet `(hash, ok)`
/// record parity).
class StellarSubmitResult {
  /// Transaction hash (server hash, or locally computed on odd responses).
  final String hash;

  /// True when the server answered with a hash.
  final bool submitted;
  final HorizonTransaction2 transaction;
  const StellarSubmitResult({
    required this.hash,
    required this.submitted,
    required this.transaction,
  });
}

/// Result of [StellarQuickClientApi.assembleTransaction]: an envelope with
/// simulation output applied, ready to sign and submit.
class StellarAssembledTransaction {
  /// Base64 transaction envelope with footprint, auth and resource fee set.
  final String envelopeBase64;

  /// Hash of the signature payload (the transaction id once submitted).
  final String txId;

  /// True when simulation found archived entries: submit a restore
  /// transaction (see `buildRestoreTransaction`) before this one.
  final bool needsRestore;

  /// Present when [needsRestore] is true.
  final StellarRpcSimulateTransactionResultRestorePreamble? restorePreamble;

  /// Resource fee (stroops, stringified) added on top of the base fee.
  final String minResourceFee;

  const StellarAssembledTransaction({
    required this.envelopeBase64,
    required this.txId,
    required this.needsRestore,
    required this.minResourceFee,
    this.restorePreamble,
  });
}

/// Result of [StellarQuickClientApi.buildClassicTransaction]: an unsigned
/// classic transaction with its signature payload hash.
class StellarClassicTransaction {
  /// Unsigned transaction (sequence already set to account sequence + 1,
  /// fee set to `feePerOperation * operations.length`).
  final StellarTransactionV1 transaction;

  /// Hash of the signature payload (the transaction id once submitted).
  final List<int> payloadHash;

  const StellarClassicTransaction({
    required this.transaction,
    required this.payloadHash,
  });
}

/// Ergonomic builders for common `ScVal` contract arguments.
class StellarScVal {
  const StellarScVal._();

  static ScValBoolean boolean(bool v) => ScValBoolean(v);
  static ScValU32 u32(int v) => ScValU32(v);
  static ScValI32 i32(int v) => ScValI32(v);
  static ScValU64 u64(BigInt v) => ScValU64(v);
  static ScValI64 i64(BigInt v) => ScValI64(v);
  static ScValString string(String v) => ScValString(v);
  static ScValSymbol symbol(String v) => ScValSymbol(v);
  static ScValBytes bytes(List<int> v) => ScValBytes(v);
  static ScValAddress address(ScAddress v) => ScValAddress(v);

  /// `ScVal` vec from already-built values.
  static ScValVec vec(List<ScVal> v) => ScValVec(value: v);

  /// String amount in stroops (int64) for token-contract calls.
  static ScValI64 amount(BigInt stroops) => ScValI64(stroops);
}
