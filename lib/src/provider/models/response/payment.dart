class StellarPaymentTransactionResponse {
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final int typeI;
  final String createdAt;
  final String transactionHash;
  final String? assetType;
  final String? assetCode;
  final String? assetIssuer;
  final String? from;
  final String? to;
  final String? amount;

  StellarPaymentTransactionResponse({
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.assetType,
    required this.assetCode,
    required this.assetIssuer,
    required this.from,
    required this.to,
    required this.amount,
  });

  factory StellarPaymentTransactionResponse.fromJson(
      Map<String, dynamic> json) {
    return StellarPaymentTransactionResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      transactionSuccessful: json['transaction_successful'],
      sourceAccount: json['source_account'],
      type: json['type'],
      typeI: json['type_i'],
      createdAt: json['created_at'],
      transactionHash: json['transaction_hash'],
      assetType: json['asset_type'],
      assetCode: json['asset_code'],
      assetIssuer: json['asset_issuer'],
      from: json['from'],
      to: json['to'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'transaction_successful': transactionSuccessful,
      'source_account': sourceAccount,
      'type': type,
      'type_i': typeI,
      'created_at': createdAt,
      'transaction_hash': transactionHash,
      'asset_type': assetType,
      'asset_code': assetCode,
      'asset_issuer': assetIssuer,
      'from': from,
      'to': to,
      'amount': amount,
    };
  }
}
