// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /operations/{id}
class HorizonRequestRetrieveAnOperation
    extends
        HorizonRequest<
          HorizonResponseLPRetrieveRelatedOperations,
          Map<String, dynamic>
        > {
  final String id;
  final HorizonJoin? join;

  const HorizonRequestRetrieveAnOperation({required this.id, this.join});

  @override
  String? get path => '/operations/{id}';

  @override
  List<String> get pathParameters => [id];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {'join': join?.toJson()};

  @override
  HorizonResponseLPRetrieveRelatedOperations onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseLPRetrieveRelatedOperations.fromJson(result);
  }
}

/// GET /operations
class HorizonRequestListAllOperations
    extends
        HorizonRequest<
          HorizonResponseLPRetrieveRelatedOperations,
          Map<String, dynamic>
        > {
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;
  final HorizonJoin? join;

  const HorizonRequestListAllOperations({
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
    this.join,
  });

  @override
  String? get path => '/operations';

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
