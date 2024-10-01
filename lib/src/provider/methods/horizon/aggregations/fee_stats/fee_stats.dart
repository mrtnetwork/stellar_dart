import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/fee.dart';

/// The fee stats endpoint provides information about per-operation fee stats over the last 5 ledgers.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-fee-stats
class HorizonRequestFeeStats
    extends HorizonRequestParam<StellarFeeStatsResponse, Map<String, dynamic>> {
  const HorizonRequestFeeStats();

  @override
  String get method => StellarHorizonMethods.feeStats.url;

  @override
  Map<String, dynamic> get queryParameters => {};

  @override
  StellarFeeStatsResponse onResonse(Map<String, dynamic> result) {
    return StellarFeeStatsResponse.fromJson(result);
  }
}
