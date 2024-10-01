import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/payment.dart';

/// This endpoint returns the payments of a specific transaction.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-transactions-payments
class HorizonRequestTransactionPayments extends HorizonRequestParam<
    List<StellarPaymentTransactionResponse>, Map<String, dynamic>> {
  /// Transactions are commands that modify the ledger state and consist of one or more operations.
  final String txId;
  const HorizonRequestTransactionPayments(this.txId,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.transactionPayments.url;

  @override
  List<String> get pathParameters => [txId];
  @override
  List<StellarPaymentTransactionResponse> onResonse(
      Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records
        .map((e) => StellarPaymentTransactionResponse.fromJson(e))
        .toList();
  }
}
