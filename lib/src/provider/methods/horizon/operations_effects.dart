// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /operations/{id}/effects
class HorizonRequestRetrieveAnOperationsEffects
    extends
        HorizonRequest<HorizonResponseListAllEffects, Map<String, dynamic>> {
  final String id;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestRetrieveAnOperationsEffects({
    required this.id,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/operations/{id}/effects';

  @override
  List<String> get pathParameters => [id];

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
