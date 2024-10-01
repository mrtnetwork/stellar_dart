import 'package:stellar_dart/src/provider/models/response/trade.dart';

class StellarOfferResponse {
  final String id;
  final String pagingToken;
  final String seller;
  final StellarAssetResponse selling;
  final StellarAssetResponse buying;
  final String amount;
  final StellarPriceResponse priceR;
  final String price;
  final int lastModifiedLedger;
  final String lastModifiedTime;
  final String? sponsor;

  StellarOfferResponse({
    required this.id,
    required this.pagingToken,
    required this.seller,
    required this.selling,
    required this.buying,
    required this.amount,
    required this.priceR,
    required this.price,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
    required this.sponsor,
  });

  factory StellarOfferResponse.fromJson(Map<String, dynamic> json) {
    return StellarOfferResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      seller: json['seller'],
      selling: StellarAssetResponse.fromJson(json['selling']),
      buying: StellarAssetResponse.fromJson(json['buying']),
      amount: json['amount'],
      priceR: StellarPriceResponse.fromJson(json['price_r']),
      price: json['price'],
      lastModifiedLedger: json['last_modified_ledger'],
      lastModifiedTime: json['last_modified_time'],
      sponsor: json['sponser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'seller': seller,
      'selling': selling.toJson(),
      'buying': buying.toJson(),
      'amount': amount,
      'price_r': priceR.toJson(),
      'price': price,
      'last_modified_ledger': lastModifiedLedger,
      'last_modified_time': lastModifiedTime,
      'sponser': sponsor,
    };
  }
}

class StellarAssetResponse {
  final String assetType;
  final String? assetCode;
  final String? assetIssuer;

  StellarAssetResponse({
    required this.assetType,
    required this.assetCode,
    required this.assetIssuer,
  });

  factory StellarAssetResponse.fromJson(Map<String, dynamic> json) {
    return StellarAssetResponse(
      assetType: json['asset_type'],
      assetCode: json['asset_code'],
      assetIssuer: json['asset_issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_type': assetType,
      'asset_code': assetCode,
      'asset_issuer': assetIssuer,
    };
  }
}
