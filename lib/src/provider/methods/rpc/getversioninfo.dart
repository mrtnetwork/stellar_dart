// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getVersionInfo
class StellarRpcRequestGetVersionInfo extends StellarRpcRequest<StellarRpcGetVersionInfoResult, Map<String, dynamic>> {

  const StellarRpcRequestGetVersionInfo();

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getVersionInfo';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
      });

  @override
  StellarRpcGetVersionInfoResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetVersionInfoResult.fromJson(result);
  }
}
