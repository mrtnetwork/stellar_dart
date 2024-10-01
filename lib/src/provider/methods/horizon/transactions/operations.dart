import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint returns Successful operations for a specific transaction.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-transactions-operations
class HorizonRequestTransactionOperations
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// Transactions are commands that modify the ledger state and consist of one or more operations.
  final String txId;
  const HorizonRequestTransactionOperations(this.txId,
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.transactionOperations.url;

  @override
  List<String> get pathParameters => [txId];
}
