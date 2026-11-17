// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /claimable_balances
class HorizonRequestListAllClaimableBalances
    extends
        HorizonRequest<
          HorizonResponseListAllClaimableBalances,
          Map<String, dynamic>
        > {
  final String? sponsor;
  final String? asset;
  final String? claimant;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListAllClaimableBalances({
    this.sponsor,
    this.asset,
    this.claimant,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/claimable_balances';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'sponsor': sponsor,
    'asset': asset,
    'claimant': claimant,
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseListAllClaimableBalances onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonResponseListAllClaimableBalances.fromJson(result);
  }
}

/// GET /claimable_balances/{claimable_balance_id}
class HorizonRequestRetrieveAClaimableBalance
    extends HorizonRequest<HorizonClaimableBalance, Map<String, dynamic>> {
  final String claimableBalanceId;

  const HorizonRequestRetrieveAClaimableBalance({
    required this.claimableBalanceId,
  });

  @override
  String? get path => '/claimable_balances/{claimable_balance_id}';

  @override
  List<String> get pathParameters => [claimableBalanceId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonClaimableBalance onResponse(Map<String, dynamic> result) {
    return HorizonClaimableBalance.fromJson(result);
  }
}
