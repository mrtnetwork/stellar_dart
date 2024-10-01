import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint displays trade data based on filters set in the arguments.

/// This is done by dividing a given time range into segments and aggregating statistics,
/// for a given asset pair (base, counter) over each of these segments.

/// The duration of the segments is specified with the resolution parameter.
/// The start and end of the time range are given by startTime and endTime respectively,
/// which are both rounded to the nearest multiple of resolution since epoch.

/// The individual segments are also aligned with multiples of resolution since epoch.
/// If you want to change this alignment, the segments can be offset by specifying the offset parameter.s
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-trade-aggregations
class HorizonRequestTradeAggregations
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// The lower time boundary represented as milliseconds since epoch.
  final int? startTime;

  /// The upper time boundary represented as milliseconds since epoch.
  final int? endtTime;

  /// The segment duration represented as milliseconds. Supported values are 1 minute (60000),
  /// 5 minutes (300000), 15 minutes (900000), 1 hour (3600000), 1 day (86400000) and 1 week (604800000).
  final int? resolution;

  /// Segments can be offset using this parameter. Expressed in milliseconds.
  /// Can only be used if the resolution is greater than 1 hour. Value must be in whole hours,
  /// less than the provided resolution, and less than 24 hours.
  final int? offset;

  /// The type for the base asset
  final RequestAssetType baseAssetType;

  /// The code for the base asset. Required if the [baseAssetType] is not native.
  final String? baseAssetCode;

  /// The Stellar address of the base asset’s issuer. Required if the [baseAssetType] is not native.
  final String? baseAssetIssuer;

  /// The type for the counter asset.
  final RequestAssetType counterAssetType;

  /// The code for the counter asset. Required if the [counterAssetType] is not native.
  final String? counterAssetCode;

  /// The Stellar address of the counter asset’s issuer. Required if the [counterAssetType] is not native.
  final String? counterAssetIssuer;

  /// A designation of the order in which records should appear.
  final HorizonQueryOrder? order;

  /// The maximum number of records returned.
  final int? limit;
  const HorizonRequestTradeAggregations(
      {required this.baseAssetType,
      required this.counterAssetType,
      this.startTime,
      this.endtTime,
      this.resolution,
      this.offset,
      this.baseAssetCode,
      this.baseAssetIssuer,
      this.counterAssetCode,
      this.counterAssetIssuer,
      this.order,
      this.limit});

  @override
  String get method => StellarHorizonMethods.tradeAggregations.url;

  @override
  Map<String, dynamic> get queryParameters => {
        "start_time": startTime,
        "end_time": endtTime,
        "resolution": resolution,
        "offset": offset,
        "base_asset_type": baseAssetType.name,
        "base_asset_issuer": baseAssetIssuer,
        "base_asset_code": baseAssetCode,
        "counter_asset_type": counterAssetType.name,
        "counter_asset_issuer": counterAssetIssuer,
        "counter_asset_code": counterAssetCode,
        "order": order?.name,
        "limit": limit
      };
}
