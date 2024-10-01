import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/models/response/transaction_effect.dart';

/// This endpoint returns the effects of a specific operation.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-an-operations-effects
class HorizonRequestOperationEffects extends HorizonRequestParam<
    List<StellarTransactionEffectsResponse>, Map<String, dynamic>> {
  /// The ID number for this operation.
  final String id;

  const HorizonRequestOperationEffects(this.id,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.operation.url;

  @override
  List<String> get pathParameters => [id];
  @override
  List<StellarTransactionEffectsResponse> onResonse(
      Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records
        .map((e) => StellarTransactionEffectsResponse.fromJson(e))
        .toList();
  }
}
