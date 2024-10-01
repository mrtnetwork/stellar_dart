import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/all_transaction.dart';

/// This endpoint lists all Successful transactions and can be used in streaming mode.
/// Streaming mode allows you to listen for new transactions as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known transaction unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream transactions created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-transactions
class HorizonRequestTransactions extends HorizonRequestParam<
    List<StellarAllTransactionResponse>, Map<String, dynamic>> {
  const HorizonRequestTransactions(
      {HorizonTransactionPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.transactions.url;

  @override
  List<String> get pathParameters => [];

  @override
  List<StellarAllTransactionResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records
        .map((e) => StellarAllTransactionResponse.fromJson(e))
        .toList();
  }
}
