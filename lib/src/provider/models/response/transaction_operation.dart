class StellarTransactionOperationResponse {
  final String id;
  final String pagingToken;
  final int typeI;
  final String type;

  const StellarTransactionOperationResponse(
      {required this.id,
      required this.pagingToken,
      required this.typeI,
      required this.type});

  factory StellarTransactionOperationResponse.fromJson(
      Map<String, dynamic> json) {
    return StellarTransactionOperationResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      typeI: json['type_i'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'type_i': typeI,
      'type': type,
    };
  }
}
