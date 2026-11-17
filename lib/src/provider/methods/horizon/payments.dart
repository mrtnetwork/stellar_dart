// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /payments
class HorizonRequestListAllPayments
    extends
        HorizonRequest<HorizonResponseListAllPayments, Map<String, dynamic>> {
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;
  final HorizonJoin? join;

  const HorizonRequestListAllPayments({
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
    this.join,
  });

  @override
  String? get path => '/payments';

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
  HorizonResponseListAllPayments onResponse(Map<String, dynamic> result) {
    return HorizonResponseListAllPayments.fromJson(result);
  }
}
