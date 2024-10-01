import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint represents successful operations referencing a given liquidity pool and can be used in streaming mode.
/// Streaming mode allows you to listen for new operations referencing this liquidity pool as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known operation unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now, you can stream operations created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/lp-retrieve-related-operations
class HorizonRequestLiquidityPoolOperations
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// A unique identifier for this liquidity pool.
  final String liquidityPoolId;
  const HorizonRequestLiquidityPoolOperations(this.liquidityPoolId,
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.liquidityPoolOperations.url;

  @override
  List<String> get pathParameters => [liquidityPoolId];
}
