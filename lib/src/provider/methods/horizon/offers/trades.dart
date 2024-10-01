import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// This endpoint represents all trades for a given offer and can be used in streaming mode.
/// Streaming mode allows you to listen for trades for this offer as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known trade unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now, you can stream trades created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-trades-by-offer-id
class HorizonRequestOfferTrades
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  final String offerId;
  const HorizonRequestOfferTrades(this.offerId,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.offerTrades.url;

  @override
  List<String> get pathParameters => [offerId];
}
