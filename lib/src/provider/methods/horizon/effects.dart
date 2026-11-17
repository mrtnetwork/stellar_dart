// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /effects
class HorizonRequestListAllEffects
    extends
        HorizonRequest<HorizonResponseListAllEffects, Map<String, dynamic>> {
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListAllEffects({this.cursor, this.order, this.limit});

  @override
  String? get path => '/effects';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseListAllEffects onResponse(Map<String, dynamic> result) {
    return HorizonResponseListAllEffects.fromJson(result);
  }
}
