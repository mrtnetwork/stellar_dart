import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// For finding out the current latest known ledger of this node. This is a subset of the ledger info from Horizon.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getLatestLedger
class SorobanRequestGetLatestLedger extends SorobanRequestParam<
    SorobanLastLedgerResponse, Map<String, dynamic>> {
  SorobanRequestGetLatestLedger();

  @override
  String get method => SorobanAPIMethods.getLatestLedger.name;
  @override
  SorobanLastLedgerResponse onResonse(Map<String, dynamic> result) {
    return SorobanLastLedgerResponse.fromJson(result);
  }
}
