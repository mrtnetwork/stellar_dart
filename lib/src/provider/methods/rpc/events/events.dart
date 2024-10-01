import 'package:blockchain_utils/helper/helper.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/utils/validator.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// Clients can request a filtered list of events emitted by a given ledger range.
/// Soroban-RPC will support querying within a maximum 24 hours of recent ledgers.
/// Note, this could be used by the client to only prompt a refresh when there is a new ledger with relevant events.
/// It should also be used by backend Dapp components to "ingest" events into their own database for querying and serving.
/// If making multiple requests, clients should deduplicate any events received, based on the event's unique id field.
/// This prevents double-processing in the case of duplicate events being received.
/// By default soroban-rpc retains the most recent 24 hours of events.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getEvents
class SorobanRequestGetEvents
    extends SorobanRequestParam<SorobanEventResponse, Map<String, dynamic>> {
  /// Ledger sequence number to start fetching responses from (inclusive).
  /// This method will return an error if startLedger is less than the oldest ledger stored in this node,
  /// or greater than the latest ledger seen by this node. If a cursor is included in the request, startLedger must be omitted.
  final int startLedger;

  /// List of filters for the returned events.
  /// Events matching any of the filters are included. To match a filter,
  ///  an event must match both a contractId and a topic. Maximum 5 filters are allowed per request.
  final List<SorobanEventFilter> filters;
  SorobanRequestGetEvents({
    required this.startLedger,
    required List<SorobanEventFilter> filters,
    SorobanPaginationParams? pagination,
  })  : filters = filters.immutable.max(5, name: "filters"),
        super(pagination: pagination);

  @override
  Map<String, dynamic> get params => {
        "startLedger": startLedger,
        "filters": filters.map((e) => e.toJson()).toList(),
        "pagination": pagination?.toJson()
      };

  @override
  String get method => SorobanAPIMethods.getEvents.name;
  @override
  SorobanEventResponse onResonse(Map<String, dynamic> result) {
    return SorobanEventResponse.fromJson(result);
  }
}
