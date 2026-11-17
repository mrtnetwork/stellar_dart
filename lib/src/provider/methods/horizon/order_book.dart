// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /order_book
class HorizonRequestRetrieveAnOrderBook
    extends HorizonRequest<HorizonOrderBook, Map<String, dynamic>> {
  final HorizonBalanceLineAssetAssetType sellingAssetType;
  final String? sellingAssetIssuer;
  final String? sellingAssetCode;
  final HorizonBalanceLineAssetAssetType? buyingAssetType;
  final String? buyingAssetIssuer;
  final String? buyingAssetCode;
  final int? limit;

  const HorizonRequestRetrieveAnOrderBook({
    required this.sellingAssetType,
    this.sellingAssetIssuer,
    this.sellingAssetCode,
    this.buyingAssetType,
    this.buyingAssetIssuer,
    this.buyingAssetCode,
    this.limit,
  });

  @override
  String? get path => '/order_book';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'selling_asset_type': sellingAssetType.toJson(),
    'selling_asset_issuer': sellingAssetIssuer,
    'selling_asset_code': sellingAssetCode,
    'buying_asset_type': buyingAssetType?.toJson(),
    'buying_asset_issuer': buyingAssetIssuer,
    'buying_asset_code': buyingAssetCode,
    'limit': limit,
  };

  @override
  HorizonOrderBook onResponse(Map<String, dynamic> result) {
    return HorizonOrderBook.fromJson(result);
  }
}
