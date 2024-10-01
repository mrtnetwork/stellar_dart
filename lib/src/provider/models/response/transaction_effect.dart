class StellarTransactionEffectsResponse {
  final String id;
  final String pagingToken;
  final String account;
  final String type;
  final int typeI;
  final String createdAt;

  const StellarTransactionEffectsResponse({
    required this.id,
    required this.pagingToken,
    required this.account,
    required this.type,
    required this.typeI,
    required this.createdAt,
  });

  factory StellarTransactionEffectsResponse.fromJson(
      Map<String, dynamic> json) {
    return StellarTransactionEffectsResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      account: json['account'],
      type: json['type'],
      typeI: json['type_i'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'account': account,
      'type': type,
      'type_i': typeI,
      'created_at': createdAt,
    };
  }
}
