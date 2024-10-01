import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/trade.dart';

/// This endpoint lists all trades and can be used in streaming mode.
/// Streaming mode allows you to listen for new trades as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known trade unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream trades created since your request time. When filtering for a specific orderbook,
/// you must use use all six of these arguments: base_asset_type, base_asset_issuer, base_asset_code,
/// counter_asset_type, counter_asset_issuer, and counter_asset_code. If the base or counter asset is
/// XLM, you only need to indicate the asset type as native and do not need to designate the code or the issuer.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-all-trades
class HorizonRequestTrades extends HorizonRequestParam<
    List<StellarTradeResponse>, Map<String, dynamic>> {
  /// The offer ID. Used to filter for trades originating from a specific offer.
  final String? offerId;

  /// The type for the base asset.
  final RequestAssetType? baseAssetType;

  /// The Stellar address of the base asset’s issuer.
  /// Required if the [baseAssetType] is not native.
  final String? baseAssetIssuer;

  /// The code for the base asset.
  /// Required if the [baseAssetType] is not native.
  final String? baseAssetCode;

  /// The type for the counter asset.
  final RequestAssetType? counterAssetType;

  /// The Stellar address of the counter asset’s issuer.
  /// Required if the [counterAssetType] is not native.
  final String? counterAssetIssuer;

  /// The code for the counter asset.
  /// Required if the [counterAssetCode] is not native.
  final String? counterAssetCode;

  /// Can be set to all, orderbook, or liquidity_pools to filter only trades executed across a given mechanism.
  final RequestTradeType? tradeType;
  const HorizonRequestTrades(
      {this.offerId,
      this.baseAssetType,
      this.baseAssetIssuer,
      this.baseAssetCode,
      this.counterAssetType,
      this.counterAssetIssuer,
      this.counterAssetCode,
      this.tradeType,
      HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.trades.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters => {
        "offer_id": offerId,
        "base_asset_type": baseAssetType?.name,
        "base_asset_issuer": baseAssetIssuer,
        "base_asset_code": baseAssetCode,
        "counter_asset_type": counterAssetType?.name,
        "counter_asset_issuer": counterAssetIssuer,
        "counter_asset_code": counterAssetCode,
        "trade_type": tradeType?.name
      };

  @override
  List<StellarTradeResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarTradeResponse.fromJson(e)).toList();
  }
}
