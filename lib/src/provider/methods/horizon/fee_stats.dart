// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /fee_stats
class HorizonRequestRetrieveFeeStats
    extends HorizonRequest<HorizonFeeStats, Map<String, dynamic>> {
  const HorizonRequestRetrieveFeeStats();

  @override
  String? get path => '/fee_stats';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonFeeStats onResponse(Map<String, dynamic> result) {
    return HorizonFeeStats.fromJson(result);
  }
}
