// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /accounts
class HorizonRequestListAllAccounts
    extends
        HorizonRequest<HorizonResponseListAllAccounts, Map<String, dynamic>> {
  final String? sponsor;
  final String? asset;
  final String? signer;
  final String? liqudityPool;
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListAllAccounts({
    this.sponsor,
    this.asset,
    this.signer,
    this.liqudityPool,
    this.cursor,
    this.order,
    this.limit,
  });

  @override
  String? get path => '/accounts';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'sponsor': sponsor,
    'asset': asset,
    'signer': signer,
    'liqudity_pool': liqudityPool,
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonResponseListAllAccounts onResponse(Map<String, dynamic> result) {
    return HorizonResponseListAllAccounts.fromJson(result);
  }
}

/// GET /accounts/{account_id}
class HorizonRequestRetrieveAnAccount
    extends
        HorizonRequest<
          HorizonAccountEmbeddedRecordsItem,
          Map<String, dynamic>
        > {
  final String accountId;

  const HorizonRequestRetrieveAnAccount({required this.accountId});

  @override
  String? get path => '/accounts/{account_id}';

  @override
  List<String> get pathParameters => [accountId];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonAccountEmbeddedRecordsItem onResponse(Map<String, dynamic> result) {
    return HorizonAccountEmbeddedRecordsItem.fromJson(result);
  }
}
