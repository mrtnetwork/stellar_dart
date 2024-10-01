import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint represents successful transactions in a given ledger.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-ledgers-transactions
class HorizonRequestLedgerTransactions
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// The sequence number of a specific ledger.
  final int sequence;
  const HorizonRequestLedgerTransactions(this.sequence,
      {HorizonTransactionPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.ledgerTransactions.url;

  @override
  List<String> get pathParameters => [sequence.toString()];
}
