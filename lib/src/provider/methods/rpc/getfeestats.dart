// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getFeeStats
class StellarRpcRequestGetFeeStats extends StellarRpcRequest<StellarRpcGetFeeStatsResult, Map<String, dynamic>> {

  const StellarRpcRequestGetFeeStats();

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getFeeStats';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
      });

  @override
  StellarRpcGetFeeStatsResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetFeeStatsResult.fromJson(result);
  }
}
