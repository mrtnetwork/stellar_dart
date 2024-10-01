class AccountOperationResponse {
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final int typeI;
  final String createdAt;
  final String transactionHash;
  final String startingBalance;
  final String funder;
  final String account;

  AccountOperationResponse({
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.startingBalance,
    required this.funder,
    required this.account,
  });

  factory AccountOperationResponse.fromJson(Map<String, dynamic> json) {
    return AccountOperationResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      transactionSuccessful: json['transaction_successful'],
      sourceAccount: json['source_account'],
      type: json['type'],
      typeI: json['type_i'],
      createdAt: json['created_at'],
      transactionHash: json['transaction_hash'],
      startingBalance: json['starting_balance'],
      funder: json['funder'],
      account: json['account'],
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
      'starting_balance': startingBalance,
      'funder': funder,
      'account': account,
    };
  }
}
