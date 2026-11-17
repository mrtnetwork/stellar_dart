// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /claimable_balances/{claimable_balance_id}/operations
class HorizonRequestCBRetrieveRelatedOperations
    extends
        HorizonRequest<
          HorizonResponseGetOperationsByAccountId,
          Map<String, dynamic>
        > {
  final String claimableBalanceId;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;
  final HorizonJoin? join;

  const HorizonRequestCBRetrieveRelatedOperations({
    required this.claimableBalanceId,
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
    this.join,
  });

  @override
  String? get path => '/claimable_balances/{claimable_balance_id}/operations';

  @override
  List<String> get pathParameters => [claimableBalanceId];

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
  HorizonResponseGetOperationsByAccountId onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseGetOperationsByAccountId.fromJson(result);
  }
}
