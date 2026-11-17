// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /paths/strict-send
class HorizonRequestListStrictSendPaymentPaths
    extends HorizonRequest<HorizonPath, Map<String, dynamic>> {
  final HorizonBalanceLineAssetAssetType sourceAssetType;
  final String? sourceAssetIssuer;
  final String? sourceAssetCode;
  final String sourceAmount;
  final String? destinationAccount;
  final String? destinationAssets;

  const HorizonRequestListStrictSendPaymentPaths({
    required this.sourceAssetType,
    this.sourceAssetIssuer,
    this.sourceAssetCode,
    required this.sourceAmount,
    this.destinationAccount,
    this.destinationAssets,
  });

  @override
  String? get path => '/paths/strict-send';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'source_asset_type': sourceAssetType.toJson(),
    'source_asset_issuer': sourceAssetIssuer,
    'source_asset_code': sourceAssetCode,
    'source_amount': sourceAmount,
    'destination_account': destinationAccount,
    'destination_assets': destinationAssets,
  };

  @override
  HorizonPath onResponse(Map<String, dynamic> result) {
    return HorizonPath.fromJson(result);
  }
}
