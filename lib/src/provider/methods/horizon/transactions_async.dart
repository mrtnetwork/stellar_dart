// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// POST /transactions_async
class HorizonRequestSubmitAsyncTransaction
    extends
        HorizonRequest<
          HorizonAsyncTransactionSubmissionResponse,
          Map<String, dynamic>
        > {
  final String tx;

  const HorizonRequestSubmitAsyncTransaction({required this.tx});

  @override
  String? get path => '/transactions_async';

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  Map<String, dynamic> get queryParameters => {'tx': tx};

  @override
  HorizonAsyncTransactionSubmissionResponse onResponse(
    Map<String, dynamic> result,
  ) {
    return HorizonAsyncTransactionSubmissionResponse.fromJson(result);
  }
}
