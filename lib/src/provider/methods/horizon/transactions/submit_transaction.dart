import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/all_transaction.dart';

/// This endpoint actually submits a transaction to the Stellar network. It only takes a single, required parameter:
/// the signed transaction. Refer to the Transactions page for details on how to craft a proper one.
/// If you submit a transaction that has already been included in a ledger, this endpoint will return
/// the same response as would’ve been returned for the original transaction submission.
/// This allows for safe resubmission of transactions in error scenarios, as highlighted in the error-handling guide.
/// https://developers.stellar.org/docs/data/horizon/api-reference/submit-a-transaction
class HorizonRequestSubmitTransaction extends HorizonPostRequestParam<
    StellarAllTransactionResponse, Map<String, dynamic>> {
  final String tx;
  const HorizonRequestSubmitTransaction(this.tx);

  @override
  Map<String, String>? get header =>
      {'Content-Type': 'application/x-www-form-urlencoded'};

  @override
  String get method => StellarHorizonMethods.submitTransaction.url;

  @override
  Map<String, dynamic> get queryParameters => {"tx": tx};

  @override
  StellarAllTransactionResponse onResonse(Map<String, dynamic> result) {
    return StellarAllTransactionResponse.fromJson(result);
  }
}
