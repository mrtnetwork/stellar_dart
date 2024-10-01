import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint lists all available claimable balances.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-claimable-balances
class HorizonRequestClaimableBalances
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// Account ID of the sponsor. Every account in the response will either be sponsored by
  /// the given account ID or have a subentry (trustline, offer, or data entry) which is sponsored by the given account ID.
  final String? sponser;

  /// An issued asset represented as “Code:IssuerAccountID”. Every account in the response will have a trustline for the given asset.
  final Object? asset;

  /// Account ID of the destination address. Only include claimable balances which can be claimed by the given account ID.
  final Object? claimant;

  const HorizonRequestClaimableBalances({
    this.sponser,
    this.asset,
    this.claimant,
    HorizonPaginationParams? paginationParams,
  }) : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.claimableBalances.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters =>
      {"sponser": sponser, "asset": asset, "claimant": claimant};
}
