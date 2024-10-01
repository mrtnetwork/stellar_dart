import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/transaction_effect.dart';

/// This endpoint returns the effects of a specific transaction.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-transactions-effects
class HorizonRequestTransactionEffects extends HorizonRequestParam<
    List<StellarTransactionEffectsResponse>, Map<String, dynamic>> {
  /// Transactions are commands that modify the ledger state and consist of one or more operations.
  final String txId;
  const HorizonRequestTransactionEffects(this.txId,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.transactionEffects.url;

  @override
  List<String> get pathParameters => [txId];

  @override
  List<StellarTransactionEffectsResponse> onResonse(
      Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records
        .map((e) => StellarTransactionEffectsResponse.fromJson(e))
        .toList();
  }
}
