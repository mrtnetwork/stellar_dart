import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// The order book endpoint provides an order book's bids and asks and can be used in streaming mode.
/// When filtering for a specific order book, you must use use all six of these arguments:
/// base_asset_type, base_asset_issuer, base_asset_code, counter_asset_type, counter_asset_issuer, and counter_asset_code.
/// If the base or counter asset is XLM, you only need to indicate the asset type as
/// native and do not need to designate the code or the issuer.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-an-order-book
class HorizonRequestOrderBook
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// he type for the asset being sold (base asset).
  final RequestAssetType sellingAssetType;

  /// The Stellar address of the issuer of the asset being sold (base asset). Required if the [sellingAssetType] is not native.
  final String? sellingAssetIssuer;

  /// The code for the asset being sold (base asset). Required if the [sellingAssetType] is not native.
  final String? sellingAssetCode;

  /// The type for the asset being bought (counter asset).
  final RequestAssetType? buyingAssetType;

  /// The Stellar address of the issuer of the asset being bought (counter asset). Required if the [buyingAssetType] is not native
  final String? buyingAssetIssuer;

  /// The code for the asset being bought (counter asset). Required if the [buyingAssetType] is not native
  final String? buyingAssetCode;

  /// The maximum number of records returned. The limit can range from 1 to 200 — an upper limit that is hardcoded in Horizon for performance reasons.
  /// If this argument isn’t designated, it defaults to 20 for order books.
  final int? limit;
  const HorizonRequestOrderBook(
      {required this.sellingAssetType,
      this.sellingAssetIssuer,
      this.sellingAssetCode,
      this.buyingAssetType,
      this.buyingAssetIssuer,
      this.buyingAssetCode,
      this.limit});

  @override
  String get method => StellarHorizonMethods.orderBook.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters => {
        "selling_asset_type": sellingAssetType.name,
        "selling_asset_issuer": sellingAssetIssuer,
        "selling_asset_code": sellingAssetCode,
        "buying_asset_type": buyingAssetType?.name,
        "buying_asset_issuer": buyingAssetIssuer,
        "buying_asset_code": buyingAssetCode,
        "limit": limit
      };
}
