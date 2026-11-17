// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /ledgers/{sequence}/operations
class HorizonRequestRetrieveALedgersOperations
    extends HorizonRequest<HorizonOperation, Map<String, dynamic>> {
  final int sequence;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;
  final HorizonJoin? join;

  const HorizonRequestRetrieveALedgersOperations({
    required this.sequence,
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
    this.join,
  });

  @override
  String? get path => '/ledgers/{sequence}/operations';

  @override
  List<String> get pathParameters => [sequence.toString()];

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
  HorizonOperation onResponse(Map<String, dynamic> result) {
    return HorizonOperation.fromJson(result);
  }
}
