import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// The getTransactions method return a detailed list of transactions starting from the user
/// specified starting point that you can paginate as long as the pages fall within the history
/// retention of their corresponding RPC provider.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getTransactions
class SorobanRequestGetTransactions extends SorobanRequestParam<
    SorobanTransactionsResponse, Map<String, dynamic>> {
  /// Ledger sequence number to start fetching responses from (inclusive).
  /// This method will return an error if startLedger is less than the oldest ledger
  /// stored in this node, or greater than the latest ledger seen by this node.
  /// If a cursor is included in the request, startLedger must be omitted.
  final int startLedger;
  SorobanRequestGetTransactions(this.startLedger,
      {SorobanPaginationParams? pagination})
      : super(pagination: pagination);

  @override
  Map<String, dynamic> get params =>
      {"startLedger": startLedger, "pagination": pagination?.toJson()};

  @override
  String get method => SorobanAPIMethods.getTransactions.name;
  @override
  SorobanTransactionsResponse onResonse(Map<String, dynamic> result) {
    return SorobanTransactionsResponse.fromJson(result);
  }
}
