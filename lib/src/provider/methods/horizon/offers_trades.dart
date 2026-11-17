// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /offers/{offer_id}/trades
class HorizonRequestGetTradesByOfferId
    extends
        HorizonRequest<
          HorizonResponseGetTradesByAccountId,
          Map<String, dynamic>
        > {
  final String offerId;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestGetTradesByOfferId({
    required this.offerId,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/offers/{offer_id}/trades';

  @override
  List<String> get pathParameters => [offerId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseGetTradesByAccountId onResponse(Map<String, dynamic> result) {
    return HorizonResponseGetTradesByAccountId.fromJson(result);
  }
}
