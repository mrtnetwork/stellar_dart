// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getNetwork
class StellarRpcRequestGetNetwork extends StellarRpcRequest<StellarRpcGetNetworkResult, Map<String, dynamic>> {

  const StellarRpcRequestGetNetwork();

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getNetwork';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
      });

  @override
  StellarRpcGetNetworkResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetNetworkResult.fromJson(result);
  }
}
