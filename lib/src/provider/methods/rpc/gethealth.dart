// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';

/// POST /getHealth
class StellarRpcRequestGetHealth
    extends StellarRpcRequest<StellarRpcGetHealthResult, Map<String, dynamic>> {
  const StellarRpcRequestGetHealth();

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getHealth';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{});

  @override
  StellarRpcGetHealthResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetHealthResult.fromJson(result);
  }
}
