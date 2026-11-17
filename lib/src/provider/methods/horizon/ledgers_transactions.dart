// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /ledgers/{sequence}/transactions
class HorizonRequestRetrieveALedgersTransactions
    extends
        HorizonRequest<
          HorizonResponseGetTransactionsByAccountId,
          Map<String, dynamic>
        > {
  final int sequence;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;

  const HorizonRequestRetrieveALedgersTransactions({
    required this.sequence,
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
  });

  @override
  String? get path => '/ledgers/{sequence}/transactions';

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
  };

  @override
  HorizonResponseGetTransactionsByAccountId onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseGetTransactionsByAccountId.fromJson(result);
  }
}
