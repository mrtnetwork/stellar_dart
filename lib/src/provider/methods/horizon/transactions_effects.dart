// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /transactions/{transaction_hash}/effects
class HorizonRequestRetrieveATransactionsEffects
    extends
        HorizonRequest<HorizonResponseListAllEffects, Map<String, dynamic>> {
  final String transactionHash;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestRetrieveATransactionsEffects({
    required this.transactionHash,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/transactions/{transaction_hash}/effects';

  @override
  List<String> get pathParameters => [transactionHash];

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
