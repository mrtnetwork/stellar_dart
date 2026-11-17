// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /transactions/{transaction_hash}
class HorizonRequestRetrieveATransaction
    extends HorizonRequest<HorizonTransaction2, Map<String, dynamic>> {
  final String transactionHash;

  const HorizonRequestRetrieveATransaction({required this.transactionHash});

  @override
  String? get path => '/transactions/{transaction_hash}';

  @override
  List<String> get pathParameters => [transactionHash];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonTransaction2 onResponse(Map<String, dynamic> result) {
    return HorizonTransaction2.fromJson(result);
  }
}

/// GET /transactions
class HorizonRequestListAllTransactions
    extends
        HorizonRequest<
          HorizonResponseGetTransactionsByAccountId,
          Map<String, dynamic>
        > {
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;
  final HorizonIncludeFailed? includeFailed;

  const HorizonRequestListAllTransactions({
    this.cursor,
    this.order,
    this.limit,
    this.includeFailed,
  });

  @override
  String? get path => '/transactions';

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

/// POST /transactions
class HorizonRequestSubmitATransaction
    extends HorizonRequest<HorizonTransaction2, Map<String, dynamic>> {
  final String tx;

  const HorizonRequestSubmitATransaction({required this.tx});

  @override
  String? get path => '/transactions';

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  /// Live Horizon rejects this endpoint with 415 unless the content type is
  /// form-urlencoded (the default POST headers send `application/json`).
  /// Hand-maintained: the generator emits no per-operation headers, so
  /// re-apply after every regen (see tool/specs/README.md).
  @override
  Map<String, String>? get headers => {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  @override
  Map<String, dynamic> get queryParameters => {'tx': tx};

  @override
  HorizonTransaction2 onResponse(Map<String, dynamic> result) {
    return HorizonTransaction2.fromJson(result);
  }
}
