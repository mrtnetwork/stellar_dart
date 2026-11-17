// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /paths/strict-receive
class HorizonRequestListStrictReceivePaymentPaths
    extends HorizonRequest<HorizonPath, Map<String, dynamic>> {
  final String? sourceAccount;
  final String? sourceAssets;
  final HorizonBalanceLineAssetAssetType destinationAssetType;
  final String? destinationAssetIssuer;
  final String? destinationAssetCode;
  final String destinationAmount;

  const HorizonRequestListStrictReceivePaymentPaths({
    this.sourceAccount,
    this.sourceAssets,
    required this.destinationAssetType,
    this.destinationAssetIssuer,
    this.destinationAssetCode,
    required this.destinationAmount,
  });

  @override
  String? get path => '/paths/strict-receive';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'source_account': sourceAccount,
    'source_assets': sourceAssets,
    'destination_asset_type': destinationAssetType.toJson(),
    'destination_asset_issuer': destinationAssetIssuer,
    'destination_asset_code': destinationAssetCode,
    'destination_amount': destinationAmount,
  };

  @override
  HorizonPath onResponse(Map<String, dynamic> result) {
    return HorizonPath.fromJson(result);
  }
}
