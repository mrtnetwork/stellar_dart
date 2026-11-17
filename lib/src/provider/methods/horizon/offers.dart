// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /offers
class HorizonRequestGetAllOffers
    extends
        HorizonRequest<
          HorizonResponseGetOffersByAccountId,
          Map<String, dynamic>
        > {
  final String? sponsor;
  final String? seller;
  final HorizonBalanceLineAssetAssetType? sellingAssetType;
  final String? sellingAssetIssuer;
  final String? sellingAssetCode;
  final HorizonBalanceLineAssetAssetType? buyingAssetType;
  final String? buyingAssetIssuer;
  final String? buyingAssetCode;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestGetAllOffers({
    this.sponsor,
    this.seller,
    this.sellingAssetType,
    this.sellingAssetIssuer,
    this.sellingAssetCode,
    this.buyingAssetType,
    this.buyingAssetIssuer,
    this.buyingAssetCode,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/offers';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'sponsor': sponsor,
    'seller': seller,
    'selling_asset_type': sellingAssetType?.toJson(),
    'selling_asset_issuer': sellingAssetIssuer,
    'selling_asset_code': sellingAssetCode,
    'buying_asset_type': buyingAssetType?.toJson(),
    'buying_asset_issuer': buyingAssetIssuer,
    'buying_asset_code': buyingAssetCode,
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseGetOffersByAccountId onResponse(Map<String, dynamic> result) {
    return HorizonResponseGetOffersByAccountId.fromJson(result);
  }
}

/// GET /offers/{offer_id}
class HorizonRequestGetOfferByOfferId
    extends
        HorizonRequest<HorizonOfferEmbeddedRecordsItem, Map<String, dynamic>> {
  final String offerId;

  const HorizonRequestGetOfferByOfferId({required this.offerId});

  @override
  String? get path => '/offers/{offer_id}';

  @override
  List<String> get pathParameters => [offerId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonOfferEmbeddedRecordsItem onResponse(Map<String, dynamic> result) {
    return HorizonOfferEmbeddedRecordsItem.fromJson(result);
  }
}
