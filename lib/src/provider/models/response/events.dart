class SorobanEventResponse {
  final int latestLedger;
  final List<SorobanEvent> events;
  const SorobanEventResponse(
      {required this.latestLedger, required this.events});
  factory SorobanEventResponse.fromJson(Map<String, dynamic> json) {
    return SorobanEventResponse(
        latestLedger: json["latestLedger"],
        events: (json["events"] as List)
            .map((e) => SorobanEvent.fromJson(e))
            .toList());
  }
}

class SorobanEvent {
  final String type;
  final int ledger;
  final DateTime ledgerClosedAt;
  final String contractId;
  final String id;
  final String pagingToken;
  final List<String> topic;
  final String value;
  final bool inSuccessfulContractCall;
  final String txHash;

  const SorobanEvent({
    required this.type,
    required this.ledger,
    required this.ledgerClosedAt,
    required this.contractId,
    required this.id,
    required this.pagingToken,
    required this.topic,
    required this.value,
    required this.inSuccessfulContractCall,
    required this.txHash,
  });

  factory SorobanEvent.fromJson(Map<String, dynamic> json) {
    return SorobanEvent(
      type: json['type'] as String,
      ledger: json['ledger'] as int,
      ledgerClosedAt: DateTime.parse(json['ledgerClosedAt']),
      contractId: json['contractId'] as String,
      id: json['id'] as String,
      pagingToken: json['pagingToken'] as String,
      topic: List<String>.from(json['topic']),
      value: json['value'] as String,
      inSuccessfulContractCall: json['inSuccessfulContractCall'] as bool,
      txHash: json['txHash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'ledger': ledger,
      'ledgerClosedAt': ledgerClosedAt.toIso8601String(),
      'contractId': contractId,
      'id': id,
      'pagingToken': pagingToken,
      'topic': topic,
      'value': value,
      'inSuccessfulContractCall': inSuccessfulContractCall,
      'txHash': txHash,
    };
  }
}
