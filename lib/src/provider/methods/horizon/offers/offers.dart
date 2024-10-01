import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/offer.dart';

/// This endpoint lists all currently open offers and can be used in streaming mode.
/// Streaming mode allows you to listen for new offers as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known offer unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream offers created since your request time. When filtering by buying or selling arguments,
///  you must use a combination of selling_asset_type, selling_asset_issuer, and selling_asset_code
/// for the selling asset, or a combination of buying_asset_type, buying_asset_issuer, and buying_asset_code for the buying asset.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-all-offers
class HorizonRequestOffers extends HorizonRequestParam<
    List<StellarOfferResponse>, Map<String, dynamic>> {
  // Account ID of the sponsor. Every account in the response will either be sponsored by
  //the given account ID or have a subentry (trustline, offer, or data entry) which is sponsored by the given account ID.
  final String? sponser;

  /// The account ID of the offer creator.
  final String? seller;

  /// The type for the selling asset.
  final RequestAssetType? sellingAssetType;

  /// The Stellar address of the issuer of the asset being sold (base asset).
  /// Required if the [sellingAssetType] is not native.
  final String? sellingAssetIssuer;

  /// The code for the asset being sold (base asset).
  /// Required if the [sellingAssetType] is not native.
  final String? sellingAssetCode;

  /// The type for the asset being bought (counter asset).
  final RequestAssetType? buyingAssetType;

  /// The Stellar address of the issuer of the asset being bought (counter asset).
  /// Required if the [buyingAssetType] is not native.
  final String? buyingAssetIssuer;

  /// The code for the asset being bought (counter asset).
  ///  Required if the [buyingAssetType] is not native.
  final String? buyingAssetCode;

  const HorizonRequestOffers(
      {this.sponser,
      this.seller,
      this.sellingAssetType,
      this.sellingAssetIssuer,
      this.sellingAssetCode,
      this.buyingAssetType,
      this.buyingAssetIssuer,
      this.buyingAssetCode,
      HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.offers.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters => {
        "sponser": sponser,
        "seller": seller,
        "selling_asset_type": sellingAssetType?.name,
        "selling_asset_issuer": sellingAssetIssuer,
        "selling_asset_code": sellingAssetCode,
        "buying_asset_type": buyingAssetType?.name,
        "buying_asset_issuer": buyingAssetIssuer,
        "buying_asset_code": buyingAssetCode
      };

  @override
  List<StellarOfferResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarOfferResponse.fromJson(e)).toList();
  }
}
