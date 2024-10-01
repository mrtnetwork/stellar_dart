import 'package:blockchain_utils/utils/string/string.dart';
import 'package:stellar_dart/stellar_dart.dart';

class StellarInnerTransactionResponse {
  final String hash;
  final List<String> signatures;
  final String maxFee;
  const StellarInnerTransactionResponse(
      {required this.hash, required this.signatures, required this.maxFee});
  factory StellarInnerTransactionResponse.fromJson(Map<String, dynamic> json) {
    return StellarInnerTransactionResponse(
        hash: json["hash"],
        signatures: (json["signatures"] as List).cast(),
        maxFee: json["max_fee"]);
  }

  Map<String, dynamic> toJson() {
    return {"hash": hash, "signatures": signatures, "max_fee": maxFee};
  }
}

class StellarFeeBumpTransactionResponse {
  final String hash;
  final List<String> signatures;
  const StellarFeeBumpTransactionResponse(
      {required this.hash, required this.signatures});
  factory StellarFeeBumpTransactionResponse.fromJson(
      Map<String, dynamic> json) {
    return StellarFeeBumpTransactionResponse(
        hash: json["hash"], signatures: (json["signatures"] as List).cast());
  }

  Map<String, dynamic> toJson() {
    return {"hash": hash, "signatures": signatures};
  }
}

class TimeboundsResponse {
  final String minTime;
  final String? maxTime;
  const TimeboundsResponse({required this.maxTime, required this.minTime});
  factory TimeboundsResponse.fromJson(Map<String, dynamic> json) {
    return TimeboundsResponse(
        minTime: json["min_time"], maxTime: json["max_time"]);
  }

  Map<String, dynamic> toJson() {
    return {"min_time": minTime, "max_time": maxTime};
  }
}

class LedgerboundsResponse {
  final String minLedger;
  final String maxLedger;
  const LedgerboundsResponse(
      {required this.maxLedger, required this.minLedger});
  factory LedgerboundsResponse.fromJson(Map<String, dynamic> json) {
    return LedgerboundsResponse(
        minLedger: json["min_ledger"], maxLedger: json["max_ledger"]);
  }

  Map<String, dynamic> toJson() {
    return {"min_ledger": minLedger, "max_ledger": maxLedger};
  }
}

class PreconditionsResponse {
  final TimeboundsResponse timeBounds;
  final LedgerboundsResponse? ledgerBounds;
  final String? minAccountSequence;
  final String? minAccountSequenceAge;
  final int? minAccountSequenceLedgerGap;
  final List<String>? extraSigners;
  const PreconditionsResponse(
      {required this.timeBounds,
      required this.ledgerBounds,
      required this.minAccountSequence,
      required this.minAccountSequenceAge,
      required this.minAccountSequenceLedgerGap,
      required this.extraSigners});
  factory PreconditionsResponse.fromJson(Map<String, dynamic> json) {
    return PreconditionsResponse(
        timeBounds: TimeboundsResponse.fromJson(json["timebounds"]),
        ledgerBounds: json["ledgerbounds"] == null
            ? null
            : LedgerboundsResponse.fromJson(json["ledgerbounds"]),
        minAccountSequence: json["min_account_sequence"],
        minAccountSequenceAge: json["min_account_sequence_age"],
        minAccountSequenceLedgerGap: json["min_account_sequence_ledger_gap"],
        extraSigners: (json["extra_signers"] as List?)?.cast());
  }

  Map<String, dynamic> toJson() {
    return {
      "timebounds": timeBounds.toJson(),
      "ledgerbounds": ledgerBounds?.toJson(),
      "min_account_sequence": minAccountSequence,
      "min_account_sequence_age": minAccountSequenceAge,
      "min_account_sequence_ledger_gap": minAccountSequenceLedgerGap,
      "extra_signers": extraSigners
    };
  }
}

class StellarAllTransactionResponse {
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
  final String? validAfter;
  final String? validBefore;
  final PreconditionsResponse? preconditions;
  final StellarFeeBumpTransactionResponse? feeBumpTransactionResponse;
  final StellarInnerTransactionResponse? innerTransactionResponse;

  StellarAllTransactionResponse(
      {required this.id,
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
      this.validAfter,
      this.validBefore,
      this.preconditions,
      this.feeBumpTransactionResponse,
      this.innerTransactionResponse});

  factory StellarAllTransactionResponse.fromJson(Map<String, dynamic> json) {
    return StellarAllTransactionResponse(
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
      validAfter: json['valid_after'],
      validBefore: json['valid_before'],
      preconditions: json['preconditions'] == null
          ? null
          : PreconditionsResponse.fromJson(json['preconditions']),
      feeBumpTransactionResponse: json['fee_bump_transaction'] == null
          ? null
          : StellarFeeBumpTransactionResponse.fromJson(
              json['fee_bump_transaction']),
      innerTransactionResponse: json['inner_transaction'] == null
          ? null
          : StellarInnerTransactionResponse.fromJson(json['inner_transaction']),
    );
  }
  TransactionResult getResult() {
    return TransactionResult.fromXdr(
        StringUtils.encode(resultXdr, type: StringEncoding.base64));
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
      'valid_after': validAfter,
      'valid_before': validBefore,
      'preconditions': preconditions?.toJson(),
      'fee_bump_transaction': feeBumpTransactionResponse?.toJson(),
      'inner_transaction': innerTransactionResponse?.toJson(),
    };
  }
}
