// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getLatestLedger
class StellarRpcRequestGetLatestLedger extends StellarRpcRequest<StellarRpcGetLatestLedgerResult, Map<String, dynamic>> {

  const StellarRpcRequestGetLatestLedger();

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getLatestLedger';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
      });

  @override
  StellarRpcGetLatestLedgerResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetLatestLedgerResult.fromJson(result);
  }
}
