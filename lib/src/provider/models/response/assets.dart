import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/helper/helper.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

abstract class StellarAssetResponse {
  abstract final RequestAssetType assetType;
  factory StellarAssetResponse.fromJson(Map<String, dynamic> json) {
    final type = RequestAssetType.fromName(json['asset_type']);
    switch (type) {
      case RequestAssetType.native:
        return StellarNativeBalanceResponse.fromJson(json);
      case RequestAssetType.creditAlphanum12:
      case RequestAssetType.creditAlphanum4:
        return StellarAssetBalanceResponse.fromJson(json);
      default:
        throw DartStellarPlugingException("Invalid asset type.",
            details: {"type": type.name});
    }
  }
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return "StellarAssetResponse${toJson()}";
  }
}

class StellarAssetBalanceResponse implements StellarAssetResponse {
  final String balance;
  final String limit;
  final String buyingLiabilities;
  final String sellingLiabilities;
  final int lastModifiedLedger;
  final bool? isAuthorized;
  final bool? isClawbackEnabled;
  @override
  final RequestAssetType assetType;
  final String assetCode;
  final String assetIssuer;

  StellarAssetBalanceResponse({
    required this.balance,
    required this.limit,
    required this.buyingLiabilities,
    required this.sellingLiabilities,
    required this.lastModifiedLedger,
    required this.isAuthorized,
    required this.isClawbackEnabled,
    required this.assetType,
    required this.assetCode,
    required this.assetIssuer,
  });

  factory StellarAssetBalanceResponse.fromJson(Map<String, dynamic> json) {
    return StellarAssetBalanceResponse(
      balance: json['balance'],
      limit: json['limit'],
      buyingLiabilities: json['buying_liabilities'],
      sellingLiabilities: json['selling_liabilities'],
      lastModifiedLedger: json['last_modified_ledger'],
      isAuthorized: json['is_authorized'],
      isClawbackEnabled: json['is_clawback_enabled'],
      assetType: RequestAssetType.fromName(json['asset_type']),
      assetCode: json['asset_code'],
      assetIssuer: json['asset_issuer'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'limit': limit,
      'buying_liabilities': buyingLiabilities,
      'selling_liabilities': sellingLiabilities,
      'last_modified_ledger': lastModifiedLedger,
      'is_authorized': isAuthorized,
      'is_clawback_enabled': isClawbackEnabled,
      'asset_type': assetType,
      'asset_code': assetCode,
      'asset_issuer': assetIssuer,
    };
  }

  late final BigInt unlockedBalance = StellarHelper.toStroop(balance) -
      StellarHelper.toStroop(sellingLiabilities);
}

class StellarNativeBalanceResponse implements StellarAssetResponse {
  final String balance;
  final String buyingLiabilities;
  final String sellingLiabilities;
  @override
  final RequestAssetType assetType;

  StellarNativeBalanceResponse(
      {required this.balance,
      required this.buyingLiabilities,
      required this.sellingLiabilities,
      required this.assetType});

  factory StellarNativeBalanceResponse.fromJson(Map<String, dynamic> json) {
    return StellarNativeBalanceResponse(
      balance: json['balance'],
      buyingLiabilities: json['buying_liabilities'],
      sellingLiabilities: json['selling_liabilities'],
      assetType: RequestAssetType.fromName(json['asset_type']),
    );
  }

  late final BigInt unlockedBalance = StellarHelper.toStroop(balance) -
      StellarHelper.toStroop(sellingLiabilities);

  @override
  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'buying_liabilities': buyingLiabilities,
      'selling_liabilities': sellingLiabilities,
      'asset_type': assetType,
    };
  }
}
