// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: OpenAPI 3.0.0
// Stellar RPC 27.1.1
//
// toJson contract (config-driven): every `toJson` takes an optional
// `JsonifyConfig` (`config`, default `DefaultJsonifyConfig.defaultConfig`) and
// returns the result through `config.encodeMap`, so `toJson` never
// returns null — it always yields a Map.
// BigInt / null handling is delegated to the config: `encodeBigint`
// encodes BigInt values and `encodeMap` post-processes the map.
// Make sure the configured output is `jsonEncode`-compatible: raw
// BigInt values are rejected by `jsonEncode`, so either keep the
// default string encoding or handle BigInt in your own encoder.

import 'package:blockchain_utils/blockchain_utils.dart';

/// Filter events by type. If omitted, all event types are included.
enum StellarRpcGetEventsParamsFiltersItemType {
  system("system"),
  contract("contract");

  final String value;
  const StellarRpcGetEventsParamsFiltersItemType(this.value);

  static StellarRpcGetEventsParamsFiltersItemType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcGetEventsParamsFiltersItemType found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// The type of event emission.
enum StellarRpcGetEventsResultEventsItemType {
  contract("contract"),
  system("system");

  final String value;
  const StellarRpcGetEventsResultEventsItemType(this.value);

  static StellarRpcGetEventsResultEventsItemType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcGetEventsResultEventsItemType found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// The current status of the transaction by hash
enum StellarRpcGetTransactionResultStatus {
  success("SUCCESS"),
  notFound("NOT_FOUND"),
  failed("FAILED");

  final String value;
  const StellarRpcGetTransactionResultStatus(this.value);

  static StellarRpcGetTransactionResultStatus fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcGetTransactionResultStatus found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// The current status of the transaction by hash.
enum StellarRpcSendTransactionResultStatus {
  pending("PENDING"),
  duplicate("DUPLICATE"),
  tryAgainLater("TRY_AGAIN_LATER"),
  error("ERROR");

  final String value;
  const StellarRpcSendTransactionResultStatus(this.value);

  static StellarRpcSendTransactionResultStatus fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcSendTransactionResultStatus found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// Specifies the authorization mode to use when simulating the transaction. 'enforce' (default) enforces authorization checks, 'record' records authorization without enforcing, and 'record_allow_nonroot' records authorization while allowing non-root invocations.
enum StellarRpcSimulateTransactionParamsAuthMode {
  enforce("enforce"),
  record("record"),
  recordAllowNonroot("record_allow_nonroot");

  final String value;
  const StellarRpcSimulateTransactionParamsAuthMode(this.value);

  static StellarRpcSimulateTransactionParamsAuthMode fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcSimulateTransactionParamsAuthMode found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// Indicates if the entry was created, updated, or deleted
enum StellarRpcSimulateTransactionResultStateChangesItemType {
  created("created"),
  updated("updated"),
  deleted("deleted");

  final String value;
  const StellarRpcSimulateTransactionResultStateChangesItemType(this.value);

  static StellarRpcSimulateTransactionResultStateChangesItemType fromJson(
    dynamic json,
  ) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(DefaultErrorType.notFound, "No matching StellarRpcSimulateTransactionResultStateChangesItemType found for the given value. null"),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// Clients can request a filtered list of events emitted by a given ledger range.
///
/// Stellar-RPC retains a bounded, ledger-denominated history of recent transactions and events, configured by a single history-retention-window setting with a stock default of 120960 ledgers (about 7 days, depending on ledger cadence); requests are served from within that retained range. The effective window and the ledgers currently available can be inspected via the getHealth method (ledgerRetentionWindow, oldestLedger, latestLedger).
///
/// Note, this could be used by the client to only prompt a refresh when there is a new ledger with relevant events. It should also be used by backend Dapp components to "ingest" events into their own database for querying and serving.
///
/// If making multiple requests, clients should deduplicate any events received, based on the event's unique id field. This prevents double-processing in the case of duplicate events being received.
///
/// POST /getEvents (request)
class StellarRpcGetEventsParams {
  /// Sequence number of the ledger.
  final num? startLedger;

  /// Sequence number of the ledger.
  final num? endLedger;
  final List<StellarRpcGetEventsParamsFiltersItem>? filters;
  final StellarRpcGetEventsParamsPagination? pagination;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  const StellarRpcGetEventsParams({
    this.startLedger,
    this.endLedger,
    this.filters,
    this.pagination,
    this.xdrFormat,
  });

  factory StellarRpcGetEventsParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetEventsParams(
      startLedger: json.valueAsNum<num?>('startLedger'),
      endLedger: json.valueAsNum<num?>('endLedger'),
      filters:
          json.hasValue('filters')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('filters')
                  .map((e) => StellarRpcGetEventsParamsFiltersItem.fromJson(e))
                  .toList()
              : null,
      pagination: json
          .valueTo<StellarRpcGetEventsParamsPagination?, Map<String, dynamic>>(
            key: 'pagination',
            parse: (v) => StellarRpcGetEventsParamsPagination.fromJson(v),
          ),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'startLedger': startLedger,
    'endLedger': endLedger,
    'filters': filters?.map((e) => e.toJson(config: config)).toList(),
    'pagination': pagination?.toJson(config: config),
    'xdrFormat': xdrFormat,
  });
}

/// POST /getEvents (response)
class StellarRpcGetEventsResult {
  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedger;

  /// The sequence number of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num? oldestLedger;

  /// The unix timestamp (as a string) of the close time of the latest ledger known to Stellar RPC when it handled the request.
  final String? latestLedgerCloseTime;

  /// The unix timestamp (as a string) of the close time of the oldest ledger kept in history by Stellar RPC when it handled the request.
  final String? oldestLedgerCloseTime;
  final List<StellarRpcGetEventsResultEventsItem>? events;

  /// A token which can be included in a subsequent request to obtain the next page of results.
  final String? cursor;

  const StellarRpcGetEventsResult({
    this.latestLedger,
    this.oldestLedger,
    this.latestLedgerCloseTime,
    this.oldestLedgerCloseTime,
    this.events,
    this.cursor,
  });

  factory StellarRpcGetEventsResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetEventsResult(
      latestLedger: json.valueAsNum<num?>('latestLedger'),
      oldestLedger: json.valueAsNum<num?>('oldestLedger'),
      latestLedgerCloseTime:
          (json['latestLedgerCloseTime'] is num
              ? json['latestLedgerCloseTime'].toString()
              : json.valueAsString<String?>('latestLedgerCloseTime')),
      oldestLedgerCloseTime:
          (json['oldestLedgerCloseTime'] is num
              ? json['oldestLedgerCloseTime'].toString()
              : json.valueAsString<String?>('oldestLedgerCloseTime')),
      events:
          json.hasValue('events')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('events')
                  .map((e) => StellarRpcGetEventsResultEventsItem.fromJson(e))
                  .toList()
              : null,
      cursor:
          (json['cursor'] is num
              ? json['cursor'].toString()
              : json.valueAsString<String?>('cursor')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'latestLedger': latestLedger,
    'oldestLedger': oldestLedger,
    'latestLedgerCloseTime': latestLedgerCloseTime,
    'oldestLedgerCloseTime': oldestLedgerCloseTime,
    'events': events?.map((e) => e.toJson(config: config)).toList(),
    'cursor': cursor,
  });
}

/// Statistics for charged inclusion fees. The inclusion fee statistics are calculated from the inclusion fees that were paid for the transactions to be included onto the ledger. For Soroban transactions and Stellar transactions, they each have their own inclusion fees and own surge pricing. Inclusion fees are used to prevent spam and prioritize transactions during network traffic surge.
///
/// POST /getFeeStats (request)
class StellarRpcGetFeeStatsParams {
  const StellarRpcGetFeeStatsParams();

  factory StellarRpcGetFeeStatsParams.fromJson(Map<String, dynamic> json) {
    return const StellarRpcGetFeeStatsParams();
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{});
}

/// POST /getFeeStats (response)
class StellarRpcGetFeeStatsResult {
  /// Inclusion fee distribution statistics for Soroban transactions
  final StellarRpcGetFeeStatsResultSorobanInclusionFee? sorobanInclusionFee;

  /// Fee distribution statistics for Stellar (i.e. non-Soroban) transactions. Statistics are normalized per operation.
  final StellarRpcGetFeeStatsResultSorobanInclusionFee? inclusionFee;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedger;

  const StellarRpcGetFeeStatsResult({
    this.sorobanInclusionFee,
    this.inclusionFee,
    this.latestLedger,
  });

  factory StellarRpcGetFeeStatsResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetFeeStatsResult(
      sorobanInclusionFee: json.valueTo<
        StellarRpcGetFeeStatsResultSorobanInclusionFee?,
        Map<String, dynamic>
      >(
        key: 'sorobanInclusionFee',
        parse:
            (v) => StellarRpcGetFeeStatsResultSorobanInclusionFee.fromJson(v),
      ),
      inclusionFee: json.valueTo<
        StellarRpcGetFeeStatsResultSorobanInclusionFee?,
        Map<String, dynamic>
      >(
        key: 'inclusionFee',
        parse:
            (v) => StellarRpcGetFeeStatsResultSorobanInclusionFee.fromJson(v),
      ),
      latestLedger: json.valueAsNum<num?>('latestLedger'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'sorobanInclusionFee': sorobanInclusionFee?.toJson(config: config),
    'inclusionFee': inclusionFee?.toJson(config: config),
    'latestLedger': latestLedger,
  });
}

/// General node health check.
///
/// POST /getHealth (request)
class StellarRpcGetHealthParams {
  const StellarRpcGetHealthParams();

  factory StellarRpcGetHealthParams.fromJson(Map<String, dynamic> json) {
    return const StellarRpcGetHealthParams();
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{});
}

/// POST /getHealth (response)
class StellarRpcGetHealthResult {
  /// "healthy"
  final String? status;

  /// Most recent known ledger sequence
  final num? latestLedger;

  /// The unix timestamp (as a string) of the close time of the most recent known ledger
  final String? latestLedgerCloseTime;

  /// Oldest ledger sequence kept in history
  final num? oldestLedger;

  /// The unix timestamp (as a string) of the close time of the oldest ledger kept in history
  final String? oldestLedgerCloseTime;

  /// Maximum retention window configured. A full window state can be determined via: ledgerRetentionWindow = latestLedger - oldestLedger + 1
  final num? ledgerRetentionWindow;

  const StellarRpcGetHealthResult({
    this.status,
    this.latestLedger,
    this.latestLedgerCloseTime,
    this.oldestLedger,
    this.oldestLedgerCloseTime,
    this.ledgerRetentionWindow,
  });

  factory StellarRpcGetHealthResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetHealthResult(
      status:
          (json['status'] is num
              ? json['status'].toString()
              : json.valueAsString<String?>('status')),
      latestLedger: json.valueAsNum<num?>('latestLedger'),
      latestLedgerCloseTime:
          (json['latestLedgerCloseTime'] is num
              ? json['latestLedgerCloseTime'].toString()
              : json.valueAsString<String?>('latestLedgerCloseTime')),
      oldestLedger: json.valueAsNum<num?>('oldestLedger'),
      oldestLedgerCloseTime:
          (json['oldestLedgerCloseTime'] is num
              ? json['oldestLedgerCloseTime'].toString()
              : json.valueAsString<String?>('oldestLedgerCloseTime')),
      ledgerRetentionWindow: json.valueAsNum<num?>('ledgerRetentionWindow'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'status': status,
    'latestLedger': latestLedger,
    'latestLedgerCloseTime': latestLedgerCloseTime,
    'oldestLedger': oldestLedger,
    'oldestLedgerCloseTime': oldestLedgerCloseTime,
    'ledgerRetentionWindow': ledgerRetentionWindow,
  });
}

/// For finding out the current latest known ledger of this node. This is a subset of the ledger info from Horizon.
///
/// POST /getLatestLedger (request)
class StellarRpcGetLatestLedgerParams {
  const StellarRpcGetLatestLedgerParams();

  factory StellarRpcGetLatestLedgerParams.fromJson(Map<String, dynamic> json) {
    return const StellarRpcGetLatestLedgerParams();
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{});
}

/// POST /getLatestLedger (response)
class StellarRpcGetLatestLedgerResult {
  /// Hash identifier of the latest ledger (as a hex-encoded string) known to Stellar RPC at the time it handled the request.
  final String? id;

  /// Stellar Core protocol version associated with the latest ledger.
  final num? protocolVersion;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? sequence;

  /// The timestamp at which the latest ledger was closed.
  final String? closeTime;

  /// The [LedgerHeader](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger.x#L74) structure for this ledger (base64-encoded string).
  final String? headerXdr;

  /// The [LedgerCloseMeta](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger.x#L539) union for this ledger (base64-encoded string).
  final String? metadataXdr;

  const StellarRpcGetLatestLedgerResult({
    this.id,
    this.protocolVersion,
    this.sequence,
    this.closeTime,
    this.headerXdr,
    this.metadataXdr,
  });

  factory StellarRpcGetLatestLedgerResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetLatestLedgerResult(
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      protocolVersion: json.valueAsNum<num?>('protocolVersion'),
      sequence: json.valueAsNum<num?>('sequence'),
      closeTime:
          (json['closeTime'] is num
              ? json['closeTime'].toString()
              : json.valueAsString<String?>('closeTime')),
      headerXdr:
          (json['headerXdr'] is num
              ? json['headerXdr'].toString()
              : json.valueAsString<String?>('headerXdr')),
      metadataXdr:
          (json['metadataXdr'] is num
              ? json['metadataXdr'].toString()
              : json.valueAsString<String?>('metadataXdr')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'id': id,
    'protocolVersion': protocolVersion,
    'sequence': sequence,
    'closeTime': closeTime,
    'headerXdr': headerXdr,
    'metadataXdr': metadataXdr,
  });
}

/// For reading the current value of ledger entries directly.
///
/// This method enables querying live ledger state: accounts, trustlines, offers, data, claimable balances, and liquidity pools. It also provides direct access to inspect a contract's current state, its code, or any other ledger entry. This serves as a primary method to access your contract data which may not be available via events or `simulateTransaction`.
///
/// To fetch contract wasm byte-code, use the ContractCode ledger entry key.
///
/// POST /getLedgerEntries (request)
class StellarRpcGetLedgerEntriesParams {
  /// An array of LedgerKeys. The maximum number of ledger keys accepted is 200.
  final List<String> keys;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  const StellarRpcGetLedgerEntriesParams({required this.keys, this.xdrFormat});

  factory StellarRpcGetLedgerEntriesParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetLedgerEntriesParams(
      keys: json.valueAsList<List<String>>('keys'),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) =>
      config.encodeMap(<String, dynamic>{'keys': keys, 'xdrFormat': xdrFormat});
}

/// POST /getLedgerEntries (response)
class StellarRpcGetLedgerEntriesResult {
  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num latestLedger;

  /// Array of objects containing all found ledger entries
  final List<StellarRpcGetLedgerEntriesResultEntriesItem>? entries;

  const StellarRpcGetLedgerEntriesResult({
    required this.latestLedger,
    this.entries,
  });

  factory StellarRpcGetLedgerEntriesResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetLedgerEntriesResult(
      latestLedger: json.valueAsNum<num>('latestLedger'),
      entries:
          json.hasValue('entries')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('entries')
                  .map(
                    (e) =>
                        StellarRpcGetLedgerEntriesResultEntriesItem.fromJson(e),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'latestLedger': latestLedger,
    'entries': entries?.map((e) => e.toJson(config: config)).toList(),
  });
}

/// The `getLedgers` method returns a detailed list of ledgers starting from the user specified starting point that you can paginate as long as the pages fall within the history retention of their corresponding RPC provider.
///
/// POST /getLedgers (request)
class StellarRpcGetLedgersParams {
  /// Sequence number of the ledger.
  final num? startLedger;
  final StellarRpcGetEventsParamsPagination? pagination;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  const StellarRpcGetLedgersParams({
    this.startLedger,
    this.pagination,
    this.xdrFormat,
  });

  factory StellarRpcGetLedgersParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetLedgersParams(
      startLedger: json.valueAsNum<num?>('startLedger'),
      pagination: json
          .valueTo<StellarRpcGetEventsParamsPagination?, Map<String, dynamic>>(
            key: 'pagination',
            parse: (v) => StellarRpcGetEventsParamsPagination.fromJson(v),
          ),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'startLedger': startLedger,
    'pagination': pagination?.toJson(config: config),
    'xdrFormat': xdrFormat,
  });
}

/// POST /getLedgers (response)
class StellarRpcGetLedgersResult {
  final List<StellarRpcGetLedgersResultLedgersItem>? ledgers;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedger;

  /// The unix timestamp of the close time of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedgerCloseTime;

  /// The sequence number of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num? oldestLedger;

  /// The unix timestamp of the close time of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num? oldestLedgerCloseTime;

  /// A token which can be included in a subsequent request to obtain the next page of results.
  final String? cursor;

  const StellarRpcGetLedgersResult({
    this.ledgers,
    this.latestLedger,
    this.latestLedgerCloseTime,
    this.oldestLedger,
    this.oldestLedgerCloseTime,
    this.cursor,
  });

  factory StellarRpcGetLedgersResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetLedgersResult(
      ledgers:
          json.hasValue('ledgers')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('ledgers')
                  .map((e) => StellarRpcGetLedgersResultLedgersItem.fromJson(e))
                  .toList()
              : null,
      latestLedger: json.valueAsNum<num?>('latestLedger'),
      latestLedgerCloseTime: json.valueAsNum<num?>('latestLedgerCloseTime'),
      oldestLedger: json.valueAsNum<num?>('oldestLedger'),
      oldestLedgerCloseTime: json.valueAsNum<num?>('oldestLedgerCloseTime'),
      cursor:
          (json['cursor'] is num
              ? json['cursor'].toString()
              : json.valueAsString<String?>('cursor')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'ledgers': ledgers?.map((e) => e.toJson(config: config)).toList(),
    'latestLedger': latestLedger,
    'latestLedgerCloseTime': latestLedgerCloseTime,
    'oldestLedger': oldestLedger,
    'oldestLedgerCloseTime': oldestLedgerCloseTime,
    'cursor': cursor,
  });
}

/// General information about the currently configured network. This response will contain all the information needed to successfully submit transactions to the network this node serves.
///
/// POST /getNetwork (request)
class StellarRpcGetNetworkParams {
  const StellarRpcGetNetworkParams();

  factory StellarRpcGetNetworkParams.fromJson(Map<String, dynamic> json) {
    return const StellarRpcGetNetworkParams();
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{});
}

/// POST /getNetwork (response)
class StellarRpcGetNetworkResult {
  /// Network passphrase configured for this Stellar RPC node.
  final String passphrase;

  /// Stellar Core protocol version associated with the latest ledger.
  final num protocolVersion;

  /// (optional) The URL of this network's "friendbot" faucet
  final String? friendbotUrl;

  const StellarRpcGetNetworkResult({
    required this.passphrase,
    required this.protocolVersion,
    this.friendbotUrl,
  });

  factory StellarRpcGetNetworkResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetNetworkResult(
      passphrase:
          (json['passphrase'] is num
              ? json['passphrase'].toString()
              : json.valueAsString<String>('passphrase')),
      protocolVersion: json.valueAsNum<num>('protocolVersion'),
      friendbotUrl:
          (json['friendbotUrl'] is num
              ? json['friendbotUrl'].toString()
              : json.valueAsString<String?>('friendbotUrl')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'passphrase': passphrase,
    'protocolVersion': protocolVersion,
    'friendbotUrl': friendbotUrl,
  });
}

/// The getTransaction method provides details about the specified transaction. Clients are expected to periodically query this method to ascertain when a transaction has been successfully recorded on the blockchain. The stellar-rpc system maintains a bounded history of recently processed transactions and events, configured by a single history-retention-window setting expressed in ledgers, with a stock default of 120960 ledgers (about 7 days, depending on ledger cadence). Operators of private stellar-rpc instances can adjust this value. The effective time span and the range of ledgers currently available can be inspected via the getHealth method (ledgerRetentionWindow, oldestLedger, latestLedger). For debugging needs that extend beyond the retained window, it is advisable to index this data yourself, employ a third-party [indexer](https://developers.stellar.org/docs/tools/developer-tools/data-indexers), or query [Hubble](https://developers.stellar.org/docs/data/hubble) (our public BigQuery data set).
///
/// POST /getTransaction (request)
class StellarRpcGetTransactionParams {
  /// Transaction hash (as a hex-encoded string)
  final String hash;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  const StellarRpcGetTransactionParams({required this.hash, this.xdrFormat});

  factory StellarRpcGetTransactionParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetTransactionParams(
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String>('hash')),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) =>
      config.encodeMap(<String, dynamic>{'hash': hash, 'xdrFormat': xdrFormat});
}

/// POST /getTransaction (response)
class StellarRpcGetTransactionResult {
  /// The current status of the transaction by hash
  final StellarRpcGetTransactionResultStatus status;

  /// The hex-encoded hash of the transaction.
  final String txHash;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num latestLedger;

  /// The unix timestamp (as a string) of the close time of the latest ledger known to Stellar RPC when it handled the request.
  final String latestLedgerCloseTime;

  /// The sequence number of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num oldestLedger;

  /// The unix timestamp (as a string) of the close time of the oldest ledger kept in history by Stellar RPC when it handled the request.
  final String oldestLedgerCloseTime;

  /// (optional) The sequence number of the ledger which included the transaction. This field is only present if `status` is `SUCCESS` or `FAILED`.
  final num? ledger;

  /// (optional) The unix timestamp (as a string) of when the transaction was included in the ledger. This field is only present if `status` is `SUCCESS` or `FAILED`.
  final String? createdAt;

  /// (optional) The index of the transaction among all transactions included in the ledger. This field is only present if `status` is `SUCCESS` or `FAILED`.
  final num? applicationOrder;

  /// (optional) Indicates whether the transaction was fee bumped. This field is only present if `status` is `SUCCESS` or `FAILED`.
  final bool? feeBump;

  /// (optional) A base64 encoded string of the raw TransactionEnvelope XDR struct for this transaction.
  final String? envelopeXdr;

  /// (optional) A base64 encoded string of the raw TransactionResult XDR struct for this transaction. This field is only present if `status` is `SUCCESS` or `FAILED`.
  final String? resultXdr;

  /// (optional) A base64 encoded string of the raw TransactionMeta XDR struct for this transaction.
  final String? resultMetaXdr;

  /// (optional) A base64 encoded slice of xdr.DiagnosticEvent. This is only present if the `ENABLE_SOROBAN_DIAGNOSTIC_EVENTS` has been enabled on the RPC server.
  final List<String>? diagnosticEventsXdr;

  /// Contains all events emitted during transaction execution.
  final StellarRpcGetTransactionResultEvents? events;

  const StellarRpcGetTransactionResult({
    required this.status,
    required this.txHash,
    required this.latestLedger,
    required this.latestLedgerCloseTime,
    required this.oldestLedger,
    required this.oldestLedgerCloseTime,
    this.ledger,
    this.createdAt,
    this.applicationOrder,
    this.feeBump,
    this.envelopeXdr,
    this.resultXdr,
    this.resultMetaXdr,
    this.diagnosticEventsXdr,
    this.events,
  });

  factory StellarRpcGetTransactionResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetTransactionResult(
      status: json.valueTo<StellarRpcGetTransactionResultStatus, Object>(
        key: 'status',
        parse:
            (e) => StellarRpcGetTransactionResultStatus.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      txHash:
          (json['txHash'] is num
              ? json['txHash'].toString()
              : json.valueAsString<String>('txHash')),
      latestLedger: json.valueAsNum<num>('latestLedger'),
      latestLedgerCloseTime:
          (json['latestLedgerCloseTime'] is num
              ? json['latestLedgerCloseTime'].toString()
              : json.valueAsString<String>('latestLedgerCloseTime')),
      oldestLedger: json.valueAsNum<num>('oldestLedger'),
      oldestLedgerCloseTime:
          (json['oldestLedgerCloseTime'] is num
              ? json['oldestLedgerCloseTime'].toString()
              : json.valueAsString<String>('oldestLedgerCloseTime')),
      ledger: json.valueAsNum<num?>('ledger'),
      createdAt:
          (json['createdAt'] is num
              ? json['createdAt'].toString()
              : json.valueAsString<String?>('createdAt')),
      applicationOrder: json.valueAsNum<num?>('applicationOrder'),
      feeBump: json.valueAsBool<bool?>('feeBump'),
      envelopeXdr:
          (json['envelopeXdr'] is num
              ? json['envelopeXdr'].toString()
              : json.valueAsString<String?>('envelopeXdr')),
      resultXdr:
          (json['resultXdr'] is num
              ? json['resultXdr'].toString()
              : json.valueAsString<String?>('resultXdr')),
      resultMetaXdr:
          (json['resultMetaXdr'] is num
              ? json['resultMetaXdr'].toString()
              : json.valueAsString<String?>('resultMetaXdr')),
      diagnosticEventsXdr: json.valueAsList<List<String>?>(
        'diagnosticEventsXdr',
      ),
      events: json
          .valueTo<StellarRpcGetTransactionResultEvents?, Map<String, dynamic>>(
            key: 'events',
            parse: (v) => StellarRpcGetTransactionResultEvents.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'status': status.toJson(config: config),
    'txHash': txHash,
    'latestLedger': latestLedger,
    'latestLedgerCloseTime': latestLedgerCloseTime,
    'oldestLedger': oldestLedger,
    'oldestLedgerCloseTime': oldestLedgerCloseTime,
    'ledger': ledger,
    'createdAt': createdAt,
    'applicationOrder': applicationOrder,
    'feeBump': feeBump,
    'envelopeXdr': envelopeXdr,
    'resultXdr': resultXdr,
    'resultMetaXdr': resultMetaXdr,
    'diagnosticEventsXdr': diagnosticEventsXdr,
    'events': events?.toJson(config: config),
  });
}

/// The `getTransactions` method return a detailed list of transactions starting from the user specified starting point that you can paginate as long as the pages fall within the history retention of their corresponding RPC provider.
///
/// POST /getTransactions (request)
class StellarRpcGetTransactionsParams {
  /// Sequence number of the ledger.
  final num? startLedger;
  final StellarRpcGetEventsParamsPagination? pagination;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  const StellarRpcGetTransactionsParams({
    this.startLedger,
    this.pagination,
    this.xdrFormat,
  });

  factory StellarRpcGetTransactionsParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetTransactionsParams(
      startLedger: json.valueAsNum<num?>('startLedger'),
      pagination: json
          .valueTo<StellarRpcGetEventsParamsPagination?, Map<String, dynamic>>(
            key: 'pagination',
            parse: (v) => StellarRpcGetEventsParamsPagination.fromJson(v),
          ),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'startLedger': startLedger,
    'pagination': pagination?.toJson(config: config),
    'xdrFormat': xdrFormat,
  });
}

/// POST /getTransactions (response)
class StellarRpcGetTransactionsResult {
  final List<StellarRpcGetTransactionsResultTransactionsItem>? transactions;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedger;

  /// The unix timestamp of the close time of the latest ledger known to Stellar RPC at the time it handled the request.
  final num? latestLedgerCloseTimestamp;

  /// The sequence number of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num? oldestLedger;

  /// The unix timestamp of the close time of the oldest ledger ingested by Stellar RPC at the time it handled the request.
  final num? oldestLedgerCloseTimestamp;

  /// A token which can be included in a subsequent request to obtain the next page of results.
  final String? cursor;

  const StellarRpcGetTransactionsResult({
    this.transactions,
    this.latestLedger,
    this.latestLedgerCloseTimestamp,
    this.oldestLedger,
    this.oldestLedgerCloseTimestamp,
    this.cursor,
  });

  factory StellarRpcGetTransactionsResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetTransactionsResult(
      transactions:
          json.hasValue('transactions')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('transactions')
                  .map(
                    (e) =>
                        StellarRpcGetTransactionsResultTransactionsItem.fromJson(
                          e,
                        ),
                  )
                  .toList()
              : null,
      latestLedger: json.valueAsNum<num?>('latestLedger'),
      latestLedgerCloseTimestamp: json.valueAsNum<num?>(
        'latestLedgerCloseTimestamp',
      ),
      oldestLedger: json.valueAsNum<num?>('oldestLedger'),
      oldestLedgerCloseTimestamp: json.valueAsNum<num?>(
        'oldestLedgerCloseTimestamp',
      ),
      cursor:
          (json['cursor'] is num
              ? json['cursor'].toString()
              : json.valueAsString<String?>('cursor')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'transactions': transactions?.map((e) => e.toJson(config: config)).toList(),
    'latestLedger': latestLedger,
    'latestLedgerCloseTimestamp': latestLedgerCloseTimestamp,
    'oldestLedger': oldestLedger,
    'oldestLedgerCloseTimestamp': oldestLedgerCloseTimestamp,
    'cursor': cursor,
  });
}

/// Version information about the RPC and Captive core. RPC manages its own, pared-down version of Stellar Core optimized for its own subset of needs. we'll refer to this as a "Captive Core" instance.
///
/// POST /getVersionInfo (request)
class StellarRpcGetVersionInfoParams {
  const StellarRpcGetVersionInfoParams();

  factory StellarRpcGetVersionInfoParams.fromJson(Map<String, dynamic> json) {
    return const StellarRpcGetVersionInfoParams();
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{});
}

/// POST /getVersionInfo (response)
class StellarRpcGetVersionInfoResult {
  /// The version of the RPC server.
  final String? version;

  /// The commit hash of the RPC server.
  final String? commitHash;

  /// The build timestamp of the RPC server.
  final String? buildTimestamp;

  /// The version of the Captive Core.
  final String? captiveCoreVersion;

  /// The protocol version.
  final int? protocolVersion;

  const StellarRpcGetVersionInfoResult({
    this.version,
    this.commitHash,
    this.buildTimestamp,
    this.captiveCoreVersion,
    this.protocolVersion,
  });

  factory StellarRpcGetVersionInfoResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcGetVersionInfoResult(
      version:
          (json['version'] is num
              ? json['version'].toString()
              : json.valueAsString<String?>('version')),
      commitHash:
          (json['commitHash'] is num
              ? json['commitHash'].toString()
              : json.valueAsString<String?>('commitHash')),
      buildTimestamp:
          (json['buildTimestamp'] is num
              ? json['buildTimestamp'].toString()
              : json.valueAsString<String?>('buildTimestamp')),
      captiveCoreVersion:
          (json['captiveCoreVersion'] is num
              ? json['captiveCoreVersion'].toString()
              : json.valueAsString<String?>('captiveCoreVersion')),
      protocolVersion: json.valueAsInt<int?>('protocolVersion'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'version': version,
    'commitHash': commitHash,
    'buildTimestamp': buildTimestamp,
    'captiveCoreVersion': captiveCoreVersion,
    'protocolVersion': protocolVersion,
  });
}

/// Submit a real transaction to the Stellar network. This is the only way to make changes on-chain.
///
///  Unlike Horizon, this does not wait for transaction completion. It simply validates and enqueues the transaction. Clients should call `getTransaction` to learn about transaction success/failure.
///
/// This supports all transactions, not only smart contract-related transactions.
///
/// POST /sendTransaction (request)
class StellarRpcSendTransactionParams {
  /// A Stellar [TransactionEnvelope](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-transaction.x#L1009) (as a base64-encoded string)
  final String transaction;

  const StellarRpcSendTransactionParams({required this.transaction});

  factory StellarRpcSendTransactionParams.fromJson(Map<String, dynamic> json) {
    return StellarRpcSendTransactionParams(
      transaction:
          (json['transaction'] is num
              ? json['transaction'].toString()
              : json.valueAsString<String>('transaction')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'transaction': transaction});
}

/// POST /sendTransaction (response)
class StellarRpcSendTransactionResult {
  /// Transaction hash (as a hex-encoded string)
  final String hash;

  /// The current status of the transaction by hash.
  final StellarRpcSendTransactionResultStatus status;

  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num latestLedger;

  /// The unix timestamp of the close time of the latest ledger known to Stellar RPC at the time it handled the request.
  final num latestLedgerCloseTime;

  /// (optional) If the transaction status is `ERROR`, this will be a base64 encoded string of the raw TransactionResult XDR struct containing details on why stellar-core rejected the transaction.
  final String? errorResultXdr;

  /// (optional) If the transaction status is `ERROR`, this field may be present with an array of base64 encoded strings. Each string will decode to a raw DiagnosticEvent XDR struct containing details on why stellar-core rejected the transaction.
  final List<String>? diagnosticEventsXdr;

  const StellarRpcSendTransactionResult({
    required this.hash,
    required this.status,
    required this.latestLedger,
    required this.latestLedgerCloseTime,
    this.errorResultXdr,
    this.diagnosticEventsXdr,
  });

  factory StellarRpcSendTransactionResult.fromJson(Map<String, dynamic> json) {
    return StellarRpcSendTransactionResult(
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String>('hash')),
      status: json.valueTo<StellarRpcSendTransactionResultStatus, Object>(
        key: 'status',
        parse:
            (e) => StellarRpcSendTransactionResultStatus.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      latestLedger: json.valueAsNum<num>('latestLedger'),
      latestLedgerCloseTime: json.valueAsNum<num>('latestLedgerCloseTime'),
      errorResultXdr:
          (json['errorResultXdr'] is num
              ? json['errorResultXdr'].toString()
              : json.valueAsString<String?>('errorResultXdr')),
      diagnosticEventsXdr: json.valueAsList<List<String>?>(
        'diagnosticEventsXdr',
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'hash': hash,
    'status': status.toJson(config: config),
    'latestLedger': latestLedger,
    'latestLedgerCloseTime': latestLedgerCloseTime,
    'errorResultXdr': errorResultXdr,
    'diagnosticEventsXdr': diagnosticEventsXdr,
  });
}

/// Submit a trial contract invocation to simulate how it would be executed by the network. This endpoint calculates the effective transaction data, required authorizations, and minimal resource fee. It provides a way to test and analyze the potential outcomes of a transaction without actually submitting it to the network.
///
/// This method can also be used to invoke read-only smart contract functions for free.
///
/// POST /simulateTransaction (request)
class StellarRpcSimulateTransactionParams {
  /// A Stellar [TransactionEnvelope](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-transaction.x#L1009) (as a base64-encoded string)
  final String transaction;

  /// Configuration for how resources will be calculated.
  final StellarRpcSimulateTransactionParamsResourceConfig? resourceConfig;

  /// Specifies whether XDR should be encoded as Base64 (default or 'base64') or JSON ('json').
  final String? xdrFormat;

  /// Specifies the authorization mode to use when simulating the transaction. 'enforce' (default) enforces authorization checks, 'record' records authorization without enforcing, and 'record_allow_nonroot' records authorization while allowing non-root invocations.
  final StellarRpcSimulateTransactionParamsAuthMode? authMode;

  const StellarRpcSimulateTransactionParams({
    required this.transaction,
    this.resourceConfig,
    this.xdrFormat,
    this.authMode,
  });

  factory StellarRpcSimulateTransactionParams.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionParams(
      transaction:
          (json['transaction'] is num
              ? json['transaction'].toString()
              : json.valueAsString<String>('transaction')),
      resourceConfig: json.valueTo<
        StellarRpcSimulateTransactionParamsResourceConfig?,
        Map<String, dynamic>
      >(
        key: 'resourceConfig',
        parse:
            (v) =>
                StellarRpcSimulateTransactionParamsResourceConfig.fromJson(v),
      ),
      xdrFormat:
          (json['xdrFormat'] is num
              ? json['xdrFormat'].toString()
              : json.valueAsString<String?>('xdrFormat')),
      authMode: json
          .valueTo<StellarRpcSimulateTransactionParamsAuthMode?, Object>(
            key: 'authMode',
            parse:
                (e) => StellarRpcSimulateTransactionParamsAuthMode.fromJson(
                  JsonParser.valueAs(e),
                ),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'transaction': transaction,
    'resourceConfig': resourceConfig?.toJson(config: config),
    'xdrFormat': xdrFormat,
    'authMode': authMode?.toJson(config: config),
  });
}

/// POST /simulateTransaction (response)
class StellarRpcSimulateTransactionResult {
  /// The sequence number of the latest ledger known to Stellar RPC at the time it handled the request.
  final num latestLedger;

  /// (optional) Stringified number - Recommended minimum resource fee to add when submitting the transaction. This fee is to be added on top of the [Stellar network fee](https://developers.stellar.org/docs/learn/fundamentals/fees-resource-limits-metering#inclusion-fee). Not present in case of error.
  final String? minResourceFee;

  /// (optional) - This array will only have one element: the result for the Host Function invocation. Only present on successful simulation (i.e. no error) of `InvokeHostFunction` operations.
  final List<StellarRpcSimulateTransactionResultResultsItem>? results;

  /// (optional) Serialized base64 string - The recommended Soroban Transaction Data to use when submitting the simulated transaction. This data contains the refundable fee and resource usage information such as the ledger footprint and IO access data (serialized in a base64 string). Not present in case of error.
  final String? transactionData;

  /// (optional) Array of serialized base64 strings - Array of the events emitted during the contract invocation. The events are ordered by their emission time. (an array of serialized base64 strings). Only present when simulating of `InvokeHostFunction` operations, note that it can be present on error, providing extra context about what failed.
  final List<String>? events;

  /// (optional) - It can only be present on successful simulation (i.e. no error) of `InvokeHostFunction` operations. If present, it indicates that the simulation detected archived ledger entries which need to be restored before the submission of the `InvokeHostFunction` operation. The `minResourceFee` and `transactionData` fields should be used to submit a transaction containing a `RestoreFootprint` operation.
  final StellarRpcSimulateTransactionResultRestorePreamble? restorePreamble;

  /// (optional) - On successful simulation of `InvokeHostFunction` operations, this field will be an array of `LedgerEntry`s before and after simulation occurred. Note that _at least_ one of `before` or `after` will be present: `before` and no `after` indicates a deletion event, the inverse is a creation event, and both present indicates an update event. Or just check the `type`.
  final List<StellarRpcSimulateTransactionResultStateChangesItem>? stateChanges;

  /// (optional) - This field will include details about why the invoke host function call failed. Only present if the transaction simulation failed.
  final String? error;

  const StellarRpcSimulateTransactionResult({
    required this.latestLedger,
    this.minResourceFee,
    this.results,
    this.transactionData,
    this.events,
    this.restorePreamble,
    this.stateChanges,
    this.error,
  });

  factory StellarRpcSimulateTransactionResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionResult(
      latestLedger: json.valueAsNum<num>('latestLedger'),
      minResourceFee:
          (json['minResourceFee'] is num
              ? json['minResourceFee'].toString()
              : json.valueAsString<String?>('minResourceFee')),
      results:
          json.hasValue('results')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('results')
                  .map(
                    (e) =>
                        StellarRpcSimulateTransactionResultResultsItem.fromJson(
                          e,
                        ),
                  )
                  .toList()
              : null,
      transactionData:
          (json['transactionData'] is num
              ? json['transactionData'].toString()
              : json.valueAsString<String?>('transactionData')),
      events: json.valueAsList<List<String>?>('events'),
      restorePreamble: json.valueTo<
        StellarRpcSimulateTransactionResultRestorePreamble?,
        Map<String, dynamic>
      >(
        key: 'restorePreamble',
        parse:
            (v) =>
                StellarRpcSimulateTransactionResultRestorePreamble.fromJson(v),
      ),
      stateChanges:
          json.hasValue('stateChanges')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('stateChanges')
                  .map(
                    (e) =>
                        StellarRpcSimulateTransactionResultStateChangesItem.fromJson(
                          e,
                        ),
                  )
                  .toList()
              : null,
      error:
          (json['error'] is num
              ? json['error'].toString()
              : json.valueAsString<String?>('error')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'latestLedger': latestLedger,
    'minResourceFee': minResourceFee,
    'results': results?.map((e) => e.toJson(config: config)).toList(),
    'transactionData': transactionData,
    'events': events,
    'restorePreamble': restorePreamble?.toJson(config: config),
    'stateChanges': stateChanges?.map((e) => e.toJson(config: config)).toList(),
    'error': error,
  });
}

class StellarRpcGetEventsParamsFiltersItem {
  /// Filter events by type. If omitted, all event types are included.
  final StellarRpcGetEventsParamsFiltersItemType? type;

  /// List of contract IDs to query for events. If omitted, return events for all contracts. Maximum 5 contract IDs are allowed per request.
  final List<String>? contractIds;

  /// A list of topic filters. Each filter is itself an array of one to four `SegmentMatcher` elements (see below). If omitted, query for all events. If multiple filters are specified, events will be included if they match any of the filters.
  final List<List<String>>? topics;

  const StellarRpcGetEventsParamsFiltersItem({
    this.type,
    this.contractIds,
    this.topics,
  });

  factory StellarRpcGetEventsParamsFiltersItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetEventsParamsFiltersItem(
      type: json.valueTo<StellarRpcGetEventsParamsFiltersItemType?, Object>(
        key: 'type',
        parse:
            (e) => StellarRpcGetEventsParamsFiltersItemType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      contractIds: json.valueAsList<List<String>?>('contractIds'),
      topics:
          json.hasValue('topics')
              ? json
                  .valueEnsureAsList<dynamic>('topics')
                  .map(
                    (e) =>
                        (e as List)
                            .map(
                              (e) =>
                                  (e is num
                                      ? e.toString()
                                      : JsonParser.valueAsString<String>(e)),
                            )
                            .toList(),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'type': type?.toJson(config: config),
    'contractIds': contractIds,
    'topics': topics,
  });
}

class StellarRpcGetEventsParamsPagination {
  /// An opaque string which acts as a paging token. To obtain the next page of results occurring after a given response set this value to the `cursor` field of the response.
  final String? cursor;

  /// The maximum number of records returned. The limit for getEvents can range from 1 to 10000 - an upper limit that is hardcoded in Stellar-RPC for performance reasons. If this argument isn't designated, it defaults to 100.
  final num? limit;

  const StellarRpcGetEventsParamsPagination({this.cursor, this.limit});

  factory StellarRpcGetEventsParamsPagination.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetEventsParamsPagination(
      cursor:
          (json['cursor'] is num
              ? json['cursor'].toString()
              : json.valueAsString<String?>('cursor')),
      limit: json.valueAsNum<num?>('limit'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'cursor': cursor, 'limit': limit});
}

class StellarRpcGetEventsResultEventsItem {
  /// The type of event emission.
  final StellarRpcGetEventsResultEventsItemType? type;

  /// Sequence number of the ledger in which this event was emitted.
  final num? ledger;

  /// [ISO-8601](https://www.iso.org/iso-8601-date-and-time-format.html) timestamp of the ledger closing time
  final String? ledgerClosedAt;

  /// StrKey representation of the contract address that emitted this event.
  final String? contractId;

  /// Unique identifier for this event, based on the [TOID](https://github.com/stellar/stellar-protocol/blob/master/ecosystem/sep-0035.md#specification) format. It combines a 19-character TOID and a 10-character, zero-padded event index, separated by a hyphen.
  final String? id;

  /// The index of the transaction within the ledger this event occurred in.
  final num? transactionIndex;

  /// The index of the operation within the transaction this event occurred in.
  final num? operationIndex;

  /// The [ScVal](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-contract.x#L214)s containing the topics this event was emitted with (as a base64 string).
  final List<String>? topic;

  /// The data emitted by the event (an [ScVal](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-contract.x#L214), serialized as a base64 string).
  final String? value;

  /// The transaction which triggered this event.
  final String? txHash;

  const StellarRpcGetEventsResultEventsItem({
    this.type,
    this.ledger,
    this.ledgerClosedAt,
    this.contractId,
    this.id,
    this.transactionIndex,
    this.operationIndex,
    this.topic,
    this.value,
    this.txHash,
  });

  factory StellarRpcGetEventsResultEventsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetEventsResultEventsItem(
      type: json.valueTo<StellarRpcGetEventsResultEventsItemType?, Object>(
        key: 'type',
        parse:
            (e) => StellarRpcGetEventsResultEventsItemType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      ledger: json.valueAsNum<num?>('ledger'),
      ledgerClosedAt:
          (json['ledgerClosedAt'] is num
              ? json['ledgerClosedAt'].toString()
              : json.valueAsString<String?>('ledgerClosedAt')),
      contractId:
          (json['contractId'] is num
              ? json['contractId'].toString()
              : json.valueAsString<String?>('contractId')),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      transactionIndex: json.valueAsNum<num?>('transactionIndex'),
      operationIndex: json.valueAsNum<num?>('operationIndex'),
      topic: json.valueAsList<List<String>?>('topic'),
      value:
          (json['value'] is num
              ? json['value'].toString()
              : json.valueAsString<String?>('value')),
      txHash:
          (json['txHash'] is num
              ? json['txHash'].toString()
              : json.valueAsString<String?>('txHash')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'type': type?.toJson(config: config),
    'ledger': ledger,
    'ledgerClosedAt': ledgerClosedAt,
    'contractId': contractId,
    'id': id,
    'transactionIndex': transactionIndex,
    'operationIndex': operationIndex,
    'topic': topic,
    'value': value,
    'txHash': txHash,
  });
}

/// Inclusion fee distribution statistics for Soroban transactions
class StellarRpcGetFeeStatsResultSorobanInclusionFee {
  /// Maximum fee
  final String? max;

  /// Minimum fee
  final String? min;

  /// Fee value which occurs the most often
  final String? mode;

  /// 10th nearest-rank fee percentile
  final String? p10;

  /// 20th nearest-rank fee percentile
  final String? p20;

  /// 30th nearest-rank fee percentile
  final String? p30;

  /// 40th nearest-rank fee percentile
  final String? p40;

  /// 50th nearest-rank fee percentile
  final String? p50;

  /// 60th nearest-rank fee percentile
  final String? p60;

  /// 70th nearest-rank fee percentile
  final String? p70;

  /// 80th nearest-rank fee percentile
  final String? p80;

  /// 90th nearest-rank fee percentile.
  final String? p90;

  /// 95th nearest-rank fee percentile.
  final String? p95;

  /// 99th nearest-rank fee percentile
  final String? p99;

  /// How many transactions are part of the distribution
  final String? transactionCount;

  /// How many consecutive ledgers form the distribution
  final num? ledgerCount;

  const StellarRpcGetFeeStatsResultSorobanInclusionFee({
    this.max,
    this.min,
    this.mode,
    this.p10,
    this.p20,
    this.p30,
    this.p40,
    this.p50,
    this.p60,
    this.p70,
    this.p80,
    this.p90,
    this.p95,
    this.p99,
    this.transactionCount,
    this.ledgerCount,
  });

  factory StellarRpcGetFeeStatsResultSorobanInclusionFee.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetFeeStatsResultSorobanInclusionFee(
      max:
          (json['max'] is num
              ? json['max'].toString()
              : json.valueAsString<String?>('max')),
      min:
          (json['min'] is num
              ? json['min'].toString()
              : json.valueAsString<String?>('min')),
      mode:
          (json['mode'] is num
              ? json['mode'].toString()
              : json.valueAsString<String?>('mode')),
      p10:
          (json['p10'] is num
              ? json['p10'].toString()
              : json.valueAsString<String?>('p10')),
      p20:
          (json['p20'] is num
              ? json['p20'].toString()
              : json.valueAsString<String?>('p20')),
      p30:
          (json['p30'] is num
              ? json['p30'].toString()
              : json.valueAsString<String?>('p30')),
      p40:
          (json['p40'] is num
              ? json['p40'].toString()
              : json.valueAsString<String?>('p40')),
      p50:
          (json['p50'] is num
              ? json['p50'].toString()
              : json.valueAsString<String?>('p50')),
      p60:
          (json['p60'] is num
              ? json['p60'].toString()
              : json.valueAsString<String?>('p60')),
      p70:
          (json['p70'] is num
              ? json['p70'].toString()
              : json.valueAsString<String?>('p70')),
      p80:
          (json['p80'] is num
              ? json['p80'].toString()
              : json.valueAsString<String?>('p80')),
      p90:
          (json['p90'] is num
              ? json['p90'].toString()
              : json.valueAsString<String?>('p90')),
      p95:
          (json['p95'] is num
              ? json['p95'].toString()
              : json.valueAsString<String?>('p95')),
      p99:
          (json['p99'] is num
              ? json['p99'].toString()
              : json.valueAsString<String?>('p99')),
      transactionCount:
          (json['transactionCount'] is num
              ? json['transactionCount'].toString()
              : json.valueAsString<String?>('transactionCount')),
      ledgerCount: json.valueAsNum<num?>('ledgerCount'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'max': max,
    'min': min,
    'mode': mode,
    'p10': p10,
    'p20': p20,
    'p30': p30,
    'p40': p40,
    'p50': p50,
    'p60': p60,
    'p70': p70,
    'p80': p80,
    'p90': p90,
    'p95': p95,
    'p99': p99,
    'transactionCount': transactionCount,
    'ledgerCount': ledgerCount,
  });
}

/// Object containing information about an existing ledger entry.
class StellarRpcGetLedgerEntriesResultEntriesItem {
  /// The [LedgerKey](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger-entries.x#L600) corresponding to the ledger entry (base64 string).
  final String? key;

  /// The key's current [LedgerEntryData](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger-entries.x#L564) value (base64 string).
  final String? xdr;

  /// The ledger sequence number of the last time this entry was updated.
  final num? lastModifiedLedgerSeq;

  /// The ledger sequence number of the ledger that the entry will be live until. May be zero if the entry is no longer live.
  final num? liveUntilLedgerSeq;

  const StellarRpcGetLedgerEntriesResultEntriesItem({
    this.key,
    this.xdr,
    this.lastModifiedLedgerSeq,
    this.liveUntilLedgerSeq,
  });

  factory StellarRpcGetLedgerEntriesResultEntriesItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetLedgerEntriesResultEntriesItem(
      key:
          (json['key'] is num
              ? json['key'].toString()
              : json.valueAsString<String?>('key')),
      xdr:
          (json['xdr'] is num
              ? json['xdr'].toString()
              : json.valueAsString<String?>('xdr')),
      lastModifiedLedgerSeq: json.valueAsNum<num?>('lastModifiedLedgerSeq'),
      liveUntilLedgerSeq: json.valueAsNum<num?>('liveUntilLedgerSeq'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'key': key,
    'xdr': xdr,
    'lastModifiedLedgerSeq': lastModifiedLedgerSeq,
    'liveUntilLedgerSeq': liveUntilLedgerSeq,
  });
}

class StellarRpcGetLedgersResultLedgersItem {
  /// The hash of the ledger header which was included in the chain
  final String? hash;

  /// The sequence number of the ledger (sometimes called the 'block height').
  final num? sequence;

  /// The unix timestamp (as a string) at which the ledger was closed.
  final String? ledgerCloseTime;

  /// The [LedgerHeaderHistoryEntry](https://github.com/stellar/stellar-xdr/blob/v26.0/Stellar-ledger.x#L277) structure for this ledger (base64-encoded string).
  final String? headerXdr;

  /// The [LedgerCloseMeta](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger.x#L539) union for this ledger (base64-encoded string).
  final String? metadataXdr;

  const StellarRpcGetLedgersResultLedgersItem({
    this.hash,
    this.sequence,
    this.ledgerCloseTime,
    this.headerXdr,
    this.metadataXdr,
  });

  factory StellarRpcGetLedgersResultLedgersItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetLedgersResultLedgersItem(
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
      sequence: json.valueAsNum<num?>('sequence'),
      ledgerCloseTime:
          (json['ledgerCloseTime'] is num
              ? json['ledgerCloseTime'].toString()
              : json.valueAsString<String?>('ledgerCloseTime')),
      headerXdr:
          (json['headerXdr'] is num
              ? json['headerXdr'].toString()
              : json.valueAsString<String?>('headerXdr')),
      metadataXdr:
          (json['metadataXdr'] is num
              ? json['metadataXdr'].toString()
              : json.valueAsString<String?>('metadataXdr')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'hash': hash,
    'sequence': sequence,
    'ledgerCloseTime': ledgerCloseTime,
    'headerXdr': headerXdr,
    'metadataXdr': metadataXdr,
  });
}

/// Contains all events emitted during transaction execution.
///
/// _Note: Available only on RPC v23.x (currently testnet only)._
class StellarRpcGetTransactionResultEvents {
  /// An array of base64-encoded [xdr.TransactionEvent](https://github.com/stellar/stellar-xdr/blob/v23.0/Stellar-ledger.x#L503-L506). These include events such as fees being charged or refunded.
  final List<String>? transactionEventsXdr;

  /// A nested array of base64-encoded [xdr.ContractEvent](https://github.com/stellar/stellar-xdr/blob/v23.0/Stellar-ledger.x#L371-L390). Each inner array represents the contract events emitted by a single operation within the transaction.
  final List<List<String>>? contractEventsXdr;

  const StellarRpcGetTransactionResultEvents({
    this.transactionEventsXdr,
    this.contractEventsXdr,
  });

  factory StellarRpcGetTransactionResultEvents.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetTransactionResultEvents(
      transactionEventsXdr: json.valueAsList<List<String>?>(
        'transactionEventsXdr',
      ),
      contractEventsXdr:
          json.hasValue('contractEventsXdr')
              ? json
                  .valueEnsureAsList<dynamic>('contractEventsXdr')
                  .map(
                    (e) =>
                        (e as List)
                            .map(
                              (e) =>
                                  (e is num
                                      ? e.toString()
                                      : JsonParser.valueAsString<String>(e)),
                            )
                            .toList(),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'transactionEventsXdr': transactionEventsXdr,
    'contractEventsXdr': contractEventsXdr,
  });
}

class StellarRpcGetTransactionsResultTransactionsItem {
  /// Indicates whether the transaction was successful or not.
  final String? status;

  /// The hex-encoded hash of the transaction.
  final String? txHash;

  /// The 1-based index of the transaction among all transactions included in the ledger.
  final num? applicationOrder;

  /// Indicates whether the transaction was fee bumped.
  final bool? feeBump;

  /// The [TransactionEnvelope](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-transaction.x#L1009) structure for this transaction (base64-encoded string).
  final String? envelopeXdr;

  /// The [TransactionResult](https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-transaction.x#L2088) structure for this transaction (base64-encoded string).
  final String? resultXdr;

  /// The [TransactionResultMeta](L446https://github.com/stellar/stellar-xdr/blob/v22.0/Stellar-ledger.x#L461) structure for this transaction (base64-encoded string).
  final String? resultMetaXdr;

  /// (optional) A base64 encoded slice of xdr.DiagnosticEvent. This is only present if the `ENABLE_SOROBAN_DIAGNOSTIC_EVENTS` has been enabled on the RPC server.
  final List<String>? diagnosticEventsXdr;

  /// Contains all events emitted during transaction execution.
  final StellarRpcGetTransactionResultEvents? events;

  /// The sequence number of the ledger which included the transaction.
  final num? ledger;

  /// The unix timestamp of when the transaction was included in the ledger.
  final num? createdAt;

  const StellarRpcGetTransactionsResultTransactionsItem({
    this.status,
    this.txHash,
    this.applicationOrder,
    this.feeBump,
    this.envelopeXdr,
    this.resultXdr,
    this.resultMetaXdr,
    this.diagnosticEventsXdr,
    this.events,
    this.ledger,
    this.createdAt,
  });

  factory StellarRpcGetTransactionsResultTransactionsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcGetTransactionsResultTransactionsItem(
      status:
          (json['status'] is num
              ? json['status'].toString()
              : json.valueAsString<String?>('status')),
      txHash:
          (json['txHash'] is num
              ? json['txHash'].toString()
              : json.valueAsString<String?>('txHash')),
      applicationOrder: json.valueAsNum<num?>('applicationOrder'),
      feeBump: json.valueAsBool<bool?>('feeBump'),
      envelopeXdr:
          (json['envelopeXdr'] is num
              ? json['envelopeXdr'].toString()
              : json.valueAsString<String?>('envelopeXdr')),
      resultXdr:
          (json['resultXdr'] is num
              ? json['resultXdr'].toString()
              : json.valueAsString<String?>('resultXdr')),
      resultMetaXdr:
          (json['resultMetaXdr'] is num
              ? json['resultMetaXdr'].toString()
              : json.valueAsString<String?>('resultMetaXdr')),
      diagnosticEventsXdr: json.valueAsList<List<String>?>(
        'diagnosticEventsXdr',
      ),
      events: json
          .valueTo<StellarRpcGetTransactionResultEvents?, Map<String, dynamic>>(
            key: 'events',
            parse: (v) => StellarRpcGetTransactionResultEvents.fromJson(v),
          ),
      ledger: json.valueAsNum<num?>('ledger'),
      createdAt: json.valueAsNum<num?>('createdAt'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'status': status,
    'txHash': txHash,
    'applicationOrder': applicationOrder,
    'feeBump': feeBump,
    'envelopeXdr': envelopeXdr,
    'resultXdr': resultXdr,
    'resultMetaXdr': resultMetaXdr,
    'diagnosticEventsXdr': diagnosticEventsXdr,
    'events': events?.toJson(config: config),
    'ledger': ledger,
    'createdAt': createdAt,
  });
}

/// Configuration for how resources will be calculated.
class StellarRpcSimulateTransactionParamsResourceConfig {
  /// Allow this many extra instructions when budgeting resources.
  final num? instructionLeeway;

  const StellarRpcSimulateTransactionParamsResourceConfig({
    this.instructionLeeway,
  });

  factory StellarRpcSimulateTransactionParamsResourceConfig.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionParamsResourceConfig(
      instructionLeeway: json.valueAsNum<num?>('instructionLeeway'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'instructionLeeway': instructionLeeway,
  });
}

/// (optional) - It can only be present on successful simulation (i.e. no error) of `InvokeHostFunction` operations. If present, it indicates that the simulation detected archived ledger entries which need to be restored before the submission of the `InvokeHostFunction` operation. The `minResourceFee` and `transactionData` fields should be used to submit a transaction containing a `RestoreFootprint` operation.
class StellarRpcSimulateTransactionResultRestorePreamble {
  /// Stringified number - Recommended minimum resource fee to add when submitting the `RestoreFootprint` operation. This fee is to be added on top of the [Stellar network fee](https://developers.stellar.org/docs/learn/fundamentals/fees-resource-limits-metering#inclusion-fee).
  final String minResourceFee;

  /// Serialized base64 string - The recommended Soroban Transaction Data to use when submitting the `RestoreFootprint` operation.
  final String transactionData;

  const StellarRpcSimulateTransactionResultRestorePreamble({
    required this.minResourceFee,
    required this.transactionData,
  });

  factory StellarRpcSimulateTransactionResultRestorePreamble.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionResultRestorePreamble(
      minResourceFee:
          (json['minResourceFee'] is num
              ? json['minResourceFee'].toString()
              : json.valueAsString<String>('minResourceFee')),
      transactionData:
          (json['transactionData'] is num
              ? json['transactionData'].toString()
              : json.valueAsString<String>('transactionData')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'minResourceFee': minResourceFee,
    'transactionData': transactionData,
  });
}

class StellarRpcSimulateTransactionResultResultsItem {
  /// Serialized base64 string - return value of the Host Function call.
  final String xdr;

  /// Array of serialized base64 strings - Per-address authorizations recorded when simulating this Host Function call.
  final List<String> auth;

  const StellarRpcSimulateTransactionResultResultsItem({
    required this.xdr,
    required this.auth,
  });

  factory StellarRpcSimulateTransactionResultResultsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionResultResultsItem(
      xdr:
          (json['xdr'] is num
              ? json['xdr'].toString()
              : json.valueAsString<String>('xdr')),
      auth: json.valueAsList<List<String>>('auth'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'xdr': xdr, 'auth': auth});
}

class StellarRpcSimulateTransactionResultStateChangesItem {
  /// Indicates if the entry was created, updated, or deleted
  final StellarRpcSimulateTransactionResultStateChangesItemType type;

  /// Base64 - the `LedgerKey` for this delta
  final String key;

  /// Base64, if present - `LedgerEntry` state prior to simulation
  final String? before;

  /// Base64, if present - `LedgerEntry` state after simulation
  final String? after;

  const StellarRpcSimulateTransactionResultStateChangesItem({
    required this.type,
    required this.key,
    this.before,
    this.after,
  });

  factory StellarRpcSimulateTransactionResultStateChangesItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return StellarRpcSimulateTransactionResultStateChangesItem(
      type: json.valueTo<
        StellarRpcSimulateTransactionResultStateChangesItemType,
        Object
      >(
        key: 'type',
        parse:
            (e) =>
                StellarRpcSimulateTransactionResultStateChangesItemType.fromJson(
                  JsonParser.valueAs(e),
                ),
      ),
      key:
          (json['key'] is num
              ? json['key'].toString()
              : json.valueAsString<String>('key')),
      before:
          (json['before'] is num
              ? json['before'].toString()
              : json.valueAsString<String?>('before')),
      after:
          (json['after'] is num
              ? json['after'].toString()
              : json.valueAsString<String?>('after')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'type': type.toJson(config: config),
    'key': key,
    'before': before,
    'after': after,
  });
}
