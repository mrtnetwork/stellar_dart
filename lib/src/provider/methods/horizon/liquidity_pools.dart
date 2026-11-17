// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /liquidity_pools
class HorizonRequestListLiquidityPools
    extends
        HorizonRequest<
          HorizonResponseListLiquidityPools,
          Map<String, dynamic>
        > {
  final String? reserves;
  final String? account;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListLiquidityPools({
    this.reserves,
    this.account,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/liquidity_pools';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'reserves': reserves,
    'account': account,
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseListLiquidityPools onResponse(Map<String, dynamic> result) {
    return HorizonResponseListLiquidityPools.fromJson(result);
  }
}

/// GET /liquidity_pools/{liquidity_pool_id}
class HorizonRequestRetrieveALiquidityPool
    extends HorizonRequest<HorizonLiquidityPool, Map<String, dynamic>> {
  final String liquidityPoolId;

  const HorizonRequestRetrieveALiquidityPool({required this.liquidityPoolId});

  @override
  String? get path => '/liquidity_pools/{liquidity_pool_id}';

  @override
  List<String> get pathParameters => [liquidityPoolId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonLiquidityPool onResponse(Map<String, dynamic> result) {
    return HorizonLiquidityPool.fromJson(result);
  }
}
