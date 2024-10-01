import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';

/// The single liquidity pool endpoint provides information on a liquidity pool.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-liquidity-pool
class HorizonRequestLiquidityPool
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// A unique identifier for this liquidity pool.
  final String liquidityPoolId;
  const HorizonRequestLiquidityPool(this.liquidityPoolId);

  @override
  String get method => StellarHorizonMethods.liquidityPool.url;

  @override
  List<String> get pathParameters => [liquidityPoolId];
}
