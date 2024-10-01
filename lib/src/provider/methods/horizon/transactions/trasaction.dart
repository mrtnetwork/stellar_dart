import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/transaction.dart';

/// The single transaction endpoint provides information on a specific transaction.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-transaction
class HorizonRequestTransaction extends HorizonRequestParam<
    StellarTransactionResponse, Map<String, dynamic>> {
  /// Transactions are commands that modify the ledger state and consist of one or more operations.
  final String txId;
  const HorizonRequestTransaction(this.txId);

  @override
  String get method => StellarHorizonMethods.transaction.url;

  @override
  List<String> get pathParameters => [txId];

  @override
  StellarTransactionResponse onResonse(Map<String, dynamic> result) {
    return StellarTransactionResponse.fromJson(result);
  }
}
