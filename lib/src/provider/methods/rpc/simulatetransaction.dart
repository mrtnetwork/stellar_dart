// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';
/// POST /simulateTransaction
class StellarRpcRequestSimulateTransaction extends StellarRpcRequest<StellarRpcSimulateTransactionResult, Map<String, dynamic>> {
  final String transaction;
  final StellarRpcSimulateTransactionParamsResourceConfig? resourceConfig;
  final String? xdrFormat;
  final StellarRpcSimulateTransactionParamsAuthMode? authMode;

  const StellarRpcRequestSimulateTransaction({
    required this.transaction,
    this.resourceConfig,
    this.xdrFormat,
    this.authMode,
  });

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'simulateTransaction';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{
        'transaction': transaction,
        'resourceConfig': resourceConfig?.toJson(config: config),
        'xdrFormat': xdrFormat,
        'authMode': authMode?.toJson(config: config),
      });

  @override
  StellarRpcSimulateTransactionResult onResponse(Map<String, dynamic> result) {
    return StellarRpcSimulateTransactionResult.fromJson(result);
  }
}
