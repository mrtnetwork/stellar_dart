import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/async_transaction_submit_result.dart';

/// This endpoint submits transactions to the Stellar network asynchronously.
/// It is designed to allow users to submit transactions without blocking
/// them while waiting for a response from Horizon. At the same time, it also provides
/// clear response status codes from stellar-core to help understand the status of the
/// submitted transaction. You can then use Horizon's GET transaction endpoint to wait
/// for the transaction to be included in a ledger and ingested by Horizon.
/// https://developers.stellar.org/docs/data/horizon/api-reference/submit-async-transaction
class HorizonRequestSubmitTransactionAsynchronously
    extends HorizonPostRequestParam<AsyncTransactionSubmissionResponse,
        Map<String, dynamic>> {
  final String tx;
  const HorizonRequestSubmitTransactionAsynchronously(this.tx);

  @override
  String get method =>
      StellarHorizonMethods.submitTransactionAsynchronously.url;
  @override
  Map<String, String>? get header =>
      {'Content-Type': 'application/x-www-form-urlencoded'};

  @override
  Map<String, dynamic> get queryParameters => {"tx": tx};

  @override
  AsyncTransactionSubmissionResponse onResonse(Map<String, dynamic> result) {
    return AsyncTransactionSubmissionResponse.fromJson(result);
  }
}
