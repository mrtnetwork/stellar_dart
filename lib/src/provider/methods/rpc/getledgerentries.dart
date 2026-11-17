// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/rpc/core.dart';
import 'types.dart';

/// POST /getLedgerEntries
class StellarRpcRequestGetLedgerEntries
    extends
        StellarRpcRequest<
          StellarRpcGetLedgerEntriesResult,
          Map<String, dynamic>
        > {
  final List<String> keys;
  final String? xdrFormat;

  const StellarRpcRequestGetLedgerEntries({required this.keys, this.xdrFormat});

  @override
  String? get path => null;

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  String? get jsonRpcMethod => 'getLedgerEntries';

  @override
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      config.encodeMap(<String, dynamic>{'keys': keys, 'xdrFormat': xdrFormat});

  @override
  StellarRpcGetLedgerEntriesResult onResponse(Map<String, dynamic> result) {
    return StellarRpcGetLedgerEntriesResult.fromJson(result);
  }
}
