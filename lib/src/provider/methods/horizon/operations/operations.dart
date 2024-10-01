import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/transaction_operation.dart';

/// This endpoint lists all Successful operations and can be used in streaming mode.
/// Streaming mode allows you to listen for new operations as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known operation unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream operations created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-operations
class HorizonRequestOperations extends HorizonRequestParam<
    List<StellarTransactionOperationResponse>, Map<String, dynamic>> {
  const HorizonRequestOperations(
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.operations.url;

  @override
  List<String> get pathParameters => [];

  @override
  List<StellarTransactionOperationResponse> onResonse(
      Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records
        .map((e) => StellarTransactionOperationResponse.fromJson(e))
        .toList();
  }
}
