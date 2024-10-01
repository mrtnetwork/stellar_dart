import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint lists all available liquidity pools.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-liquidity-pools
class HorizonRequestLiquidityPools
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// Comma-separated list of assets in canonical form (Code:IssuerAccountID),
  /// to only include liquidity pools which have reserves matching all listed assets.
  final Object? reserves;

  /// A Stellar account ID, to only include liquidity pools in which this account
  /// is participating in (i.e. holds pool shares to).
  final Object? account;

  const HorizonRequestLiquidityPools(
      {this.reserves, this.account, HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.liquidityPools.url;

  @override
  List<String> get pathParameters => [];
}
