// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';

/// POST /sendTransaction
class StellarRpcRequestSendTransaction
    extends
        StellarRpcRequest<
          StellarRpcSendTransactionResult,
          Map<String, dynamic>
        > {
  final String transaction;

  const StellarRpcRequestSendTransaction({required this.transaction});

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'sendTransaction';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{'transaction': transaction});

  @override
  StellarRpcSendTransactionResult onResponse(Map<String, dynamic> result) {
    return StellarRpcSendTransactionResult.fromJson(result);
  }
}
