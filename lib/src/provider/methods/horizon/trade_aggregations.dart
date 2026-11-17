// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /trade_aggregations
class HorizonRequestListTradeAggregations
    extends HorizonRequest<HorizonTradeAggregation, Map<String, dynamic>> {
  final int? startTime;
  final int? endTime;
  final HorizonResolution? resolution;
  final num? offset;
  final HorizonBalanceLineAssetAssetType baseAssetType;
  final String? baseAssetIssuer;
  final String? baseAssetCode;
  final HorizonBalanceLineAssetAssetType counterAssetType;
  final String? counterAssetIssuer;
  final String? counterAssetCode;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListTradeAggregations({
    this.startTime,
    this.endTime,
    this.resolution,
    this.offset,
    required this.baseAssetType,
    this.baseAssetIssuer,
    this.baseAssetCode,
    required this.counterAssetType,
    this.counterAssetIssuer,
    this.counterAssetCode,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/trade_aggregations';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'start_time': startTime,
    'end_time': endTime,
    'resolution': resolution?.toJson(),
    'offset': offset,
    'base_asset_type': baseAssetType.toJson(),
    'base_asset_issuer': baseAssetIssuer,
    'base_asset_code': baseAssetCode,
    'counter_asset_type': counterAssetType.toJson(),
    'counter_asset_issuer': counterAssetIssuer,
    'counter_asset_code': counterAssetCode,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonTradeAggregation onResponse(Map<String, dynamic> result) {
    return HorizonTradeAggregation.fromJson(result);
  }
}
