// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /getEvents
class StellarRpcRequestGetEvents extends StellarRpcRequest<StellarRpcGetEventsResult, Map<String, dynamic>> {
  final num? startLedger;
  final num? endLedger;
  final List<StellarRpcGetEventsParamsFiltersItem>? filters;
  final StellarRpcGetEventsParamsPagination? pagination;
  final String? xdrFormat;

  const StellarRpcRequestGetEvents({
    this.startLedger,
    this.endLedger,
    this.filters,
    this.pagination,
    this.xdrFormat,
  });

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getEvents';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
        'startLedger': startLedger,
        'endLedger': endLedger,
        'filters': filters?.map((e) => e.toJson(config: config)).toList(),
        'pagination': pagination?.toJson(config: config),
        'xdrFormat': xdrFormat,
      });

  @override
  StellarRpcGetEventsResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetEventsResult.fromJson(result);
  }
}
