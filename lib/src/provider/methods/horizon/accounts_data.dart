// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /accounts/{account_id}/data/{key}
class HorizonRequestGetDataByAccountId
    extends
        HorizonRequest<
          HorizonResponseGetDataByAccountId,
          Map<String, dynamic>
        > {
  final String accountId;
  final String key;

  const HorizonRequestGetDataByAccountId({
    required this.accountId,
    required this.key,
  });

  @override
  String? get path => '/accounts/{account_id}/data/{key}';

  @override
  List<String> get pathParameters => [accountId, key];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonResponseGetDataByAccountId onResponse(Map<String, dynamic> result) {
    return HorizonResponseGetDataByAccountId.fromJson(result);
  }
}
