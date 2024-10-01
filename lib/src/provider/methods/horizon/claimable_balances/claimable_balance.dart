import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';

/// The single claimable balance endpoint provides information on a claimable balance.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-claimable-balance
class HorizonRequestClaimableBalance
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// A unique identifier for this claimable balance.
  final String claimableBalanceId;

  const HorizonRequestClaimableBalance(this.claimableBalanceId);

  @override
  String get method => StellarHorizonMethods.claimableBalance.url;

  @override
  List<String> get pathParameters => [claimableBalanceId];
}
