import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// Statistics for charged inclusion fees. The inclusion fee statistics are calculated from the
/// inclusion fees that were paid for the transactions to be included onto the ledger.
/// For Soroban transactions and Stellar transactions, they each have their own inclusion fees and own surge pricing.
/// Inclusion fees are used to prevent spam and prioritize transactions during network traffic surge.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getFeeStats
class SorobanRequestGetFeeStats
    extends SorobanRequestParam<SorobanFeeStatsResponse, Map<String, dynamic>> {
  SorobanRequestGetFeeStats();

  @override
  String get method => SorobanAPIMethods.getFeeStats.name;
  @override
  SorobanFeeStatsResponse onResonse(Map<String, dynamic> result) {
    return SorobanFeeStatsResponse.fromJson(result);
  }
}
