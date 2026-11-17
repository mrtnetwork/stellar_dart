// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /liquidity_pools/{liquidity_pool_id}/operations
class HorizonRequestLPRetrieveRelatedOperations
    extends
        HorizonRequest<
          HorizonResponseLPRetrieveRelatedOperations,
          Map<String, dynamic>
        > {
  final String liquidityPoolId;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;
  final HorizonJoin? join;

  const HorizonRequestLPRetrieveRelatedOperations({
    required this.liquidityPoolId,
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
    this.join,
  });

  @override
  String? get path => '/liquidity_pools/{liquidity_pool_id}/operations';

  @override
  List<String> get pathParameters => [liquidityPoolId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
    'include_failed': includeFailed?.toJson(),
    'join': join?.toJson(),
  };

  @override
  HorizonResponseLPRetrieveRelatedOperations onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseLPRetrieveRelatedOperations.fromJson(result);
  }
}
