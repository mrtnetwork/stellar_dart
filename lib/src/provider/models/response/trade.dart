class StellarTradeResponse {
  final String id;
  final String pagingToken;
  final String ledgerCloseTime;
  final String? offerId;
  final String? baseOfferId;
  final String? baseAccount;
  final String baseAmount;
  final String baseAssetType;
  final String counterOfferId;
  final String counterAccount;
  final String counterAmount;
  final String counterAssetType;
  final String? counterAssetCode;
  final String? counterAssetIssuer;
  final bool baseIsSeller;
  final StellarPriceResponse price;

  StellarTradeResponse({
    required this.id,
    required this.pagingToken,
    required this.ledgerCloseTime,
    required this.offerId,
    required this.baseOfferId,
    required this.baseAccount,
    required this.baseAmount,
    required this.baseAssetType,
    required this.counterOfferId,
    required this.counterAccount,
    required this.counterAmount,
    required this.counterAssetType,
    required this.counterAssetCode,
    required this.counterAssetIssuer,
    required this.baseIsSeller,
    required this.price,
  });

  factory StellarTradeResponse.fromJson(Map<String, dynamic> json) {
    return StellarTradeResponse(
      id: json['id'],
      pagingToken: json['paging_token'],
      ledgerCloseTime: json['ledger_close_time'],
      offerId: json['offer_id'],
      baseOfferId: json['base_offer_id'],
      baseAccount: json['base_account'],
      baseAmount: json['base_amount'],
      baseAssetType: json['base_asset_type'],
      counterOfferId: json['counter_offer_id'],
      counterAccount: json['counter_account'],
      counterAmount: json['counter_amount'],
      counterAssetType: json['counter_asset_type'],
      counterAssetCode: json['counter_asset_code'],
      counterAssetIssuer: json['counter_asset_issuer'],
      baseIsSeller: json['base_is_seller'],
      price: StellarPriceResponse.fromJson(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paging_token': pagingToken,
      'ledger_close_time': ledgerCloseTime,
      'offer_id': offerId,
      'base_offer_id': baseOfferId,
      'base_account': baseAccount,
      'base_amount': baseAmount,
      'base_asset_type': baseAssetType,
      'counter_offer_id': counterOfferId,
      'counter_account': counterAccount,
      'counter_amount': counterAmount,
      'counter_asset_type': counterAssetType,
      'counter_asset_code': counterAssetCode,
      'counter_asset_issuer': counterAssetIssuer,
      'base_is_seller': baseIsSeller,
      'price': price.toJson(),
    };
  }
}

class StellarPriceResponse {
  final String n;
  final String d;

  StellarPriceResponse({
    required this.n,
    required this.d,
  });

  factory StellarPriceResponse.fromJson(Map<String, dynamic> json) {
    return StellarPriceResponse(
      n: json['n']!.toString(),
      d: json['d']!.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'n': n,
      'd': d,
    };
  }
}
