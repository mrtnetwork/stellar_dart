class StellarLedgerResponse {
  final String id;
  final String pagingToken;
  final String hash;
  final String? preHash;
  final int sequence;
  final int successfulTransactionCount;
  final int failedTransactionCount;
  final int operationCount;
  final int txSetOperationCount;
  final String closedAt;
  final String totalCoins;
  final String feePool;
  final int baseFeeInStroops;
  final int baseReserveInStroops;
  final int maxTxSetSize;
  final int protocolVersion;
  final String headerXdr;

  const StellarLedgerResponse({
    required this.id,
    required this.pagingToken,
    required this.hash,
    required this.preHash,
    required this.sequence,
    required this.successfulTransactionCount,
    required this.failedTransactionCount,
    required this.operationCount,
    required this.txSetOperationCount,
    required this.closedAt,
    required this.totalCoins,
    required this.feePool,
    required this.baseFeeInStroops,
    required this.baseReserveInStroops,
    required this.maxTxSetSize,
    required this.protocolVersion,
    required this.headerXdr,
  });

  factory StellarLedgerResponse.fromJson(Map<String, dynamic> json) {
    return StellarLedgerResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      hash: json['hash'],
      preHash: json['pre_hash'],
      sequence: json['sequence'],
      successfulTransactionCount: json['successful_transaction_count'],
      failedTransactionCount: json['failed_transaction_count'],
      operationCount: json['operation_count'],
      txSetOperationCount: json['tx_set_operation_count'],
      closedAt: json['closed_at'],
      totalCoins: json['total_coins'],
      feePool: json['fee_pool'],
      baseFeeInStroops: json['base_fee_in_stroops'],
      baseReserveInStroops: json['base_reserve_in_stroops'],
      maxTxSetSize: json['max_tx_set_size'],
      protocolVersion: json['protocol_version'],
      headerXdr: json['header_xdr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'hash': hash,
      'pre_hash': preHash,
      'sequence': sequence,
      'successful_transaction_count': successfulTransactionCount,
      'failed_transaction_count': failedTransactionCount,
      'operation_count': operationCount,
      'tx_set_operation_count': txSetOperationCount,
      'closed_at': closedAt,
      'total_coins': totalCoins,
      'fee_pool': feePool,
      'base_fee_in_stroops': baseFeeInStroops,
      'base_reserve_in_stroops': baseReserveInStroops,
      'max_tx_set_size': maxTxSetSize,
      'protocol_version': protocolVersion,
      'header_xdr': headerXdr,
    };
  }
}

class SorobanLastLedgerResponse {
  final String id;
  final int protocolVersion;
  final int sequence;

  SorobanLastLedgerResponse({
    required this.id,
    required this.protocolVersion,
    required this.sequence,
  });

  factory SorobanLastLedgerResponse.fromJson(Map<String, dynamic> json) {
    return SorobanLastLedgerResponse(
      id: json['id'],
      protocolVersion: json['protocolVersion'],
      sequence: json['sequence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'protocolVersion': protocolVersion,
      'sequence': sequence,
    };
  }
}

class SorobanLedgerEntriesResponse {
  final List<SorobanLedgerEntry> entries;
  final int latestLedger;

  const SorobanLedgerEntriesResponse(
      {required this.entries, required this.latestLedger});

  factory SorobanLedgerEntriesResponse.fromJson(Map<String, dynamic> json) {
    var entriesList = (json['entries'] as List)
        .map((entry) => SorobanLedgerEntry.fromJson(entry))
        .toList();

    return SorobanLedgerEntriesResponse(
      entries: entriesList,
      latestLedger: json['latestLedger'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'latestLedger': latestLedger,
    };
  }
}

class SorobanLedgerEntry {
  final String key;
  final String xdr;
  final int lastModifiedLedgerSeq;

  SorobanLedgerEntry({
    required this.key,
    required this.xdr,
    required this.lastModifiedLedgerSeq,
  });

  factory SorobanLedgerEntry.fromJson(Map<String, dynamic> json) {
    return SorobanLedgerEntry(
      key: json['key'] as String,
      xdr: json['xdr'] as String,
      lastModifiedLedgerSeq: json['lastModifiedLedgerSeq'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'xdr': xdr,
      'lastModifiedLedgerSeq': lastModifiedLedgerSeq,
    };
  }
}
