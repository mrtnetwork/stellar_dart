import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// This endpoint lists accounts by one of four filters : signer, asset, liquidity pool or sponsor.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-accounts
class HorizonRequestAccounts extends HorizonRequestParam<
    List<StellarAccountResponse>, Map<String, dynamic>> {
  /// Account ID of the sponsor. Every account in the response will either be sponsored by
  /// the given account ID or have a subentry (trustline, offer, or data entry) which is sponsored by the given account ID.
  final String? sponser;

  /// An issued asset represented as “Code:IssuerAccountID”. Every account in the response will have a trustline for the given asset.
  final String? asset;

  /// Account ID of the signer. Every account in the response will have the given account ID as a signer.
  final String? signer;

  /// With this parameter, the results will include only accounts which have trustlines to the specified liquidity pool.
  final String? liqudityPool;

  const HorizonRequestAccounts({
    this.sponser,
    this.asset,
    this.signer,
    this.liqudityPool,
    HorizonPaginationParams? paginationParams,
  }) : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.accounts.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters => {
        "sponser": sponser,
        "asset": asset,
        "signer": signer,
        "liqudity_pool": liqudityPool
      };

  @override
  List<StellarAccountResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarAccountResponse.fromJson(e)).toList();
  }
}
// StellarAccountResponse
