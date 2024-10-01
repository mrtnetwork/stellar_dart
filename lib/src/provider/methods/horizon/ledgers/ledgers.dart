import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/ledger.dart';

/// This endpoint lists all ledgers and can be used in streaming mode. Streaming mode allows you to listen for new ledgers as they close.
/// If called in streaming mode, Horizon will start at the earliest known ledger unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream ledgers since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-ledgers
class HorizonRequestLedgers extends HorizonRequestParam<
    List<StellarLedgerResponse>, Map<String, dynamic>> {
  const HorizonRequestLedgers({HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.ledgers.url;

  @override
  List<String> get pathParameters => [];

  @override
  List<StellarLedgerResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarLedgerResponse.fromJson(e)).toList();
  }
}
