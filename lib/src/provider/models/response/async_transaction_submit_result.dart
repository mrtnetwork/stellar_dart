import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/transaction_result.dart';

class StellarTxStatus {
  static const StellarTxStatus error = StellarTxStatus._('ERROR', 0);
  static const StellarTxStatus pending = StellarTxStatus._('PENDING', 1);
  static const StellarTxStatus duplicate = StellarTxStatus._('DUPLICATE', 2);
  static const StellarTxStatus tryAgainLater =
      StellarTxStatus._('TRY_AGAIN_LATER', 3);

  final String name;
  final int value;

  const StellarTxStatus._(this.name, this.value);

  static List<StellarTxStatus> get values => [
        error,
        pending,
        duplicate,
        tryAgainLater,
      ];

  static StellarTxStatus fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ScAddress type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "StellarTxStatus.$name";
  }
}

class AsyncTransactionSubmissionResponse {
  final String? errorResultXdr;
  final StellarTxStatus txStatus;
  final String hash;
  const AsyncTransactionSubmissionResponse(
      {required this.errorResultXdr,
      required this.txStatus,
      required this.hash});
  factory AsyncTransactionSubmissionResponse.fromJson(
      Map<String, dynamic> json) {
    return AsyncTransactionSubmissionResponse(
        errorResultXdr: json["errorResultXdr"],
        txStatus: StellarTxStatus.fromName(json["tx_status"]),
        hash: json["hash"]);
  }

  TransactionResult? get errorResult {
    if (errorResultXdr == null) return null;
    return TransactionResult.fromXdr(
        StringUtils.encode(errorResultXdr!, type: StringEncoding.base64));
  }
}
