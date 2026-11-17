// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getTransaction
class StellarRpcRequestGetTransaction extends StellarRpcRequest<StellarRpcGetTransactionResult, Map<String, dynamic>> {
  final String hash;
  final String? xdrFormat;

  const StellarRpcRequestGetTransaction({
    required this.hash,
    this.xdrFormat,
  });

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getTransaction';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
        'hash': hash,
        'xdrFormat': xdrFormat,
      });

  @override
  StellarRpcGetTransactionResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetTransactionResult.fromJson(result);
  }
}
