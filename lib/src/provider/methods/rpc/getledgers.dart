// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';

/// POST /getLedgers
class StellarRpcRequestGetLedgers
    extends
        StellarRpcRequest<StellarRpcGetLedgersResult, Map<String, dynamic>> {
  final num? startLedger;
  final StellarRpcGetEventsParamsPagination? pagination;
  final String? xdrFormat;

  const StellarRpcRequestGetLedgers({
    this.startLedger,
    this.pagination,
    this.xdrFormat,
  });

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getLedgers';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
        'startLedger': startLedger,
        'pagination': pagination?.toJson(config: config),
        'xdrFormat': xdrFormat,
      });

  @override
  StellarRpcGetLedgersResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetLedgersResult.fromJson(result);
  }
}
