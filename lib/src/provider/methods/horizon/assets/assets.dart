import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/asset.dart';

/// This endpoint lists all assets.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-assets
class HorizonRequestAssets extends HorizonRequestParam<
    List<StellarAllAssetResponse>, Map<String, dynamic>> {
  /// The code of the asset you would like to filter by.
  final String? assetCode;

  /// The Stellar address of the issuer for the asset you would like to filter by.
  final String? assetIssuer;

  const HorizonRequestAssets({
    this.assetCode,
    this.assetIssuer,
    HorizonPaginationParams? paginationParams,
  }) : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.assets.url;

  @override
  List<String> get pathParameters => [];

  @override
  Map<String, dynamic> get queryParameters =>
      {"asset_code": assetCode, "asset_issuer": assetIssuer};

  @override
  List<StellarAllAssetResponse> onResonse(Map<String, dynamic> result) {
    final records = (result["_embedded"]?["records"] as List?) ?? [];
    return records.map((e) => StellarAllAssetResponse.fromJson(e)).toList();
  }
}
