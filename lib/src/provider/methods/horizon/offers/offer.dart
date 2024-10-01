import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/offer.dart';

/// The single offer endpoint provides information on a specific offer.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-offer-by-offer-id
class HorizonRequestOffer extends HorizonRequestParam<
    List<StellarOfferResponse>, Map<String, dynamic>> {
  final String offerId;
  const HorizonRequestOffer(this.offerId);

  @override
  String get method => StellarHorizonMethods.offer.url;

  @override
  List<String> get pathParameters => [offerId];
  @override
  List<StellarOfferResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarOfferResponse.fromJson(e)).toList();
  }
}
