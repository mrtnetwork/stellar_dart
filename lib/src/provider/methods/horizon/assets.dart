// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /assets
class HorizonRequestListAllAssets
    extends HorizonRequest<HorizonResponseListAllAssets, Map<String, dynamic>> {
  final String? assetCode;
  final String? assetIssuer;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListAllAssets({
    this.assetCode,
    this.assetIssuer,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/assets';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseListAllAssets onResponse(Map<String, dynamic> result) {
    return HorizonResponseListAllAssets.fromJson(result);
  }
}
