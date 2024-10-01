import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';

class StellarTransactionResponse {
  final String id;
  final String pagingToken;
  final bool successful;
  final String hash;
  final int ledger;
  final String createdAt;
  final String sourceAccount;
  final String? accountMuxed;
  final String? accountMuxedId;
  final String sourceAccountSequence;
  final String feeAccount;
  final String? feeAccountMuxed;
  final String? feeAccountMuxedId;
  final String feeCharged;
  final String maxFee;
  final int operationCount;
  final String envelopeXdr;
  final String resultXdr;
  final String resultMetaXdr;
  final String feeMetaXdr;
  final String memoType;
  final List<String> signatures;

  StellarTransactionResponse({
    required this.id,
    required this.pagingToken,
    required this.successful,
    required this.hash,
    required this.ledger,
    required this.createdAt,
    required this.sourceAccount,
    required this.accountMuxed,
    required this.accountMuxedId,
    required this.sourceAccountSequence,
    required this.feeAccount,
    required this.feeAccountMuxed,
    required this.feeAccountMuxedId,
    required this.feeCharged,
    required this.maxFee,
    required this.operationCount,
    required this.envelopeXdr,
    required this.resultXdr,
    required this.resultMetaXdr,
    required this.feeMetaXdr,
    required this.memoType,
    required this.signatures,
  });

  factory StellarTransactionResponse.fromJson(Map<String, dynamic> json) {
    return StellarTransactionResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      successful: json['successful'],
      hash: json['hash'],
      ledger: json['ledger'],
      createdAt: json['created_at'],
      sourceAccount: json['source_account'],
      accountMuxed: json['account_muxed'],
      accountMuxedId: json['account_muxed_id'],
      sourceAccountSequence: json['source_account_sequence'],
      feeAccount: json['fee_account'],
      feeAccountMuxed: json['fee_account_muxed'],
      feeAccountMuxedId: json['fee_account_muxed_id'],
      feeCharged: json['fee_charged'],
      maxFee: json['max_fee'],
      operationCount: json['operation_count'],
      envelopeXdr: json['envelope_xdr'],
      resultXdr: json['result_xdr'],
      resultMetaXdr: json['result_meta_xdr'],
      feeMetaXdr: json['fee_meta_xdr'],
      memoType: json['memo_type'],
      signatures: List<String>.from(json['signatures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'successful': successful,
      'hash': hash,
      'ledger': ledger,
      'created_at': createdAt,
      'source_account': sourceAccount,
      'account_muxed': accountMuxed,
      'account_muxed_id': accountMuxedId,
      'source_account_sequence': sourceAccountSequence,
      'fee_account': feeAccount,
      'fee_account_muxed': feeAccountMuxed,
      'fee_account_muxed_id': feeAccountMuxedId,
      'fee_charged': feeCharged,
      'max_fee': maxFee,
      'operation_count': operationCount,
      'envelope_xdr': envelopeXdr,
      'result_xdr': resultXdr,
      'result_meta_xdr': resultMetaXdr,
      'fee_meta_xdr': feeMetaXdr,
      'memo_type': memoType,
      'signatures': signatures,
    };
  }

  TransactionResult getResult() {
    return TransactionResult.fromXdr(
        StringUtils.encode(resultXdr, type: StringEncoding.base64));
  }
}

class SorobanTransactionResponse {
  final String status;
  final int? latestLedger;
  final String? latestLedgerCloseTime;
  final int? oldestLedger;
  final String? oldestLedgerCloseTime;
  final int? ledger;
  final int? createdAt;
  final List<String>? diagnosticEventsXdr;
  final int? applicationOrder;
  final bool? feeBump;
  final String? envelopeXdr;
  final String? resultXdr;
  final String? resultMetaXdr;

  SorobanTransactionResponse(
      {required this.status,
      required this.latestLedger,
      required this.latestLedgerCloseTime,
      required this.oldestLedger,
      required this.oldestLedgerCloseTime,
      required this.applicationOrder,
      required this.envelopeXdr,
      required this.resultXdr,
      required this.resultMetaXdr,
      required this.createdAt,
      required this.feeBump,
      required this.ledger,
      required this.diagnosticEventsXdr});

  // Factory constructor to create an instance from JSON
  factory SorobanTransactionResponse.fromJson(Map<String, dynamic> json) {
    return SorobanTransactionResponse(
        status: json['status'],
        latestLedger: json['latestLedger'],
        latestLedgerCloseTime: json['latestLedgerCloseTime'],
        oldestLedger: json['oldestLedger'],
        oldestLedgerCloseTime: json["oldestLedgerCloseTime"],
        applicationOrder: json['applicationOrder'],
        envelopeXdr: json['envelopeXdr'],
        resultXdr: json['resultXdr'],
        resultMetaXdr: json['resultMetaXdr'],
        createdAt: int.tryParse(json["createdAt"]?.toString() ?? ""),
        feeBump: json["feeBump"],
        ledger: json["ledger"],
        diagnosticEventsXdr: (json["diagnosticEventsXdr"] as List?)?.cast());
  }

  // Convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'latestLedger': latestLedger,
      'latestLedgerCloseTime': latestLedgerCloseTime,
      'oldestLedger': oldestLedger,
      'oldestLedgerCloseTime': oldestLedgerCloseTime,
      'applicationOrder': applicationOrder,
      'envelopeXdr': envelopeXdr,
      'resultXdr': resultXdr,
      'resultMetaXdr': resultMetaXdr,
      "feeBump": feeBump,
      "createdAt": createdAt,
      "ledger": ledger,
      "diagnosticEventsXdr": diagnosticEventsXdr
    };
  }
}

class SorobanTransactionsResponse {
  final int latestLedger;
  final int latestLedgerCloseTimestamp;
  final int oldestLedger;
  final int oldestLedgerCloseTimestamp;
  final List<SorobanTransactionResponse> transactions;
  const SorobanTransactionsResponse(
      {required this.latestLedger,
      required this.latestLedgerCloseTimestamp,
      required this.oldestLedger,
      required this.oldestLedgerCloseTimestamp,
      required this.transactions});
  factory SorobanTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return SorobanTransactionsResponse(
        latestLedger: json["latestLedger"],
        latestLedgerCloseTimestamp: json["latestLedgerCloseTimestamp"],
        oldestLedger: json["oldestLedger"],
        oldestLedgerCloseTimestamp: json["oldestLedgerCloseTimestamp"],
        transactions: (json["transactions"] as List)
            .map((e) => SorobanTransactionResponse.fromJson(e))
            .toList());
  }
  Map<String, dynamic> toJson() {
    return {
      "transactions": transactions.map((e) => e.toJson()).toList(),
      "latestLedger": latestLedger,
      "latestLedgerCloseTimestamp": latestLedgerCloseTimestamp,
      "oldestLedger": oldestLedger,
      "oldestLedgerCloseTimestamp": oldestLedgerCloseTimestamp,
    };
  }
}

class SorobanSendTransactionResponse {
  final String hash;
  final String status;
  final int latestLedger;
  final String latestLedgerCloseTime;
  final String? errorResultXdr;
  final List<String>? diagnosticEventsXdr;

  SorobanSendTransactionResponse({
    required this.hash,
    required this.status,
    required this.latestLedger,
    required this.latestLedgerCloseTime,
    this.errorResultXdr,
    this.diagnosticEventsXdr,
  });

  factory SorobanSendTransactionResponse.fromJson(Map<String, dynamic> json) {
    return SorobanSendTransactionResponse(
      hash: json['hash'] as String,
      status: json['status'] as String,
      latestLedger: json['latestLedger'] as int,
      latestLedgerCloseTime: json['latestLedgerCloseTime'] as String,
      errorResultXdr: json['errorResultXdr'] as String?,
      diagnosticEventsXdr: (json['diagnosticEventsXdr'] as List?)?.cast(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'status': status,
      'latestLedger': latestLedger,
      'latestLedgerCloseTime': latestLedgerCloseTime,
      'errorResultXdr': errorResultXdr,
      'diagnosticEventsXdr': diagnosticEventsXdr,
    };
  }
}
