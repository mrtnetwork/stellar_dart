// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /trades
class HorizonRequestGetAllTrades
    extends
        HorizonRequest<
          HorizonResponseGetTradesByAccountId,
          Map<String, dynamic>
        > {
  final String? offerId;
  final HorizonBalanceLineAssetAssetType? baseAssetType;
  final String? baseAssetIssuer;
  final String? baseAssetCode;
  final HorizonBalanceLineAssetAssetType? counterAssetType;
  final String? counterAssetIssuer;
  final String? counterAssetCode;
  final HorizonTradeType? tradeType;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestGetAllTrades({
    this.offerId,
    this.baseAssetType,
    this.baseAssetIssuer,
    this.baseAssetCode,
    this.counterAssetType,
    this.counterAssetIssuer,
    this.counterAssetCode,
    this.tradeType,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/trades';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'offer_id': offerId,
    'base_asset_type': baseAssetType?.toJson(),
    'base_asset_issuer': baseAssetIssuer,
    'base_asset_code': baseAssetCode,
    'counter_asset_type': counterAssetType?.toJson(),
    'counter_asset_issuer': counterAssetIssuer,
    'counter_asset_code': counterAssetCode,
    'trade_type': tradeType?.toJson(),
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseGetTradesByAccountId onResponse(Map<String, dynamic> result) {
    return HorizonResponseGetTradesByAccountId.fromJson(result);
  }
}
