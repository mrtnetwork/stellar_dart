// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /accounts/{account_id}/transactions
class HorizonRequestGetTransactionsByAccountId
    extends
        HorizonRequest<
          HorizonResponseGetTransactionsByAccountId,
          Map<String, dynamic>
        > {
  final String accountId;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;

  const HorizonRequestGetTransactionsByAccountId({
    required this.accountId,
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
  });

  @override
  String? get path => '/accounts/{account_id}/transactions';

  @override
  List<String> get pathParameters => [accountId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
    'include_failed': includeFailed?.toJson(),
  };

  @override
  HorizonResponseGetTransactionsByAccountId onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseGetTransactionsByAccountId.fromJson(result);
  }
}
