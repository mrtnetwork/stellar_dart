import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint represents successful trades fulfilled by the given liquidity pool and can be used in streaming mode.
/// Streaming mode allows you to listen for new trades referencing this liquidity pool as they are added to the Stellar ledger.
///  If called in streaming mode, Horizon will start at the earliest known trade unless a cursor is set, in which case it
/// will start from that cursor. By setting the cursor value to now, you can stream trade created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-related-trades
class HorizonRequestLiquidityPoolTrades
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// A unique identifier for this liquidity pool.
  final String liquidityPoolId;
  const HorizonRequestLiquidityPoolTrades(this.liquidityPoolId,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.liquidityPoolTrades.url;

  @override
  List<String> get pathParameters => [liquidityPoolId];
}
