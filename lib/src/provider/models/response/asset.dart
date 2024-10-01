class StellarAllAssetResponse {
  final String assetType;
  final String assetIssuer;
  final String pagingToken;
  final AutorizationResponse accounts;
  final int numClaimableBalances;
  final int numContracts;
  final int numLiquidityPools;
  final AutorizationResponse balances;
  final String? authorized;
  final String? authorizedToMaintainLiabilities;
  final String? unauthorized;
  final String claimableBalancesAmount;
  final String contractsAmount;
  final String liquidityPoolsAmount;
  final String amount;
  final int numAccounts;
  final FlagsResponse flags;

  StellarAllAssetResponse({
    required this.assetType,
    required this.assetIssuer,
    required this.pagingToken,
    required this.accounts,
    required this.numClaimableBalances,
    required this.numContracts,
    required this.numLiquidityPools,
    required this.balances,
    required this.authorized,
    required this.authorizedToMaintainLiabilities,
    required this.unauthorized,
    required this.claimableBalancesAmount,
    required this.contractsAmount,
    required this.liquidityPoolsAmount,
    required this.amount,
    required this.numAccounts,
    required this.flags,
  });

  factory StellarAllAssetResponse.fromJson(Map<String, dynamic> json) {
    return StellarAllAssetResponse(
      assetType: json['asset_type'],
      assetIssuer: json['asset_issuer'],
      pagingToken: json['paging_token'],
      accounts: AutorizationResponse.fromJson(json['accounts']),
      numClaimableBalances: json['num_claimable_balances'],
      numContracts: json['num_contracts'],
      numLiquidityPools: json['num_liquidity_pools'],
      balances: AutorizationResponse.fromJson(json['balances']),
      authorized: json['authorized'],
      authorizedToMaintainLiabilities:
          json['authorized_to_maintain_liabilities'],
      unauthorized: json['unauthorized'],
      claimableBalancesAmount: json['claimable_balances_amount'],
      contractsAmount: json['contracts_amount'],
      liquidityPoolsAmount: json['liquidity_pools_amount'],
      amount: json['amount'],
      numAccounts: json['num_accounts'],
      flags: FlagsResponse.fromJson(json['flags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_type': assetType,
      'asset_issuer': assetIssuer,
      'paging_token': pagingToken,
      'accounts': accounts.toJson(),
      'num_claimable_balances': numClaimableBalances,
      'num_contracts': numContracts,
      'num_liquidity_pools': numLiquidityPools,
      'balances': balances.toJson(),
      'authorized': authorized,
      'authorized_to_maintain_liabilities': authorizedToMaintainLiabilities,
      'unauthorized': unauthorized,
      'claimable_balances_amount': claimableBalancesAmount,
      'contracts_amount': contractsAmount,
      'liquidity_pools_amount': liquidityPoolsAmount,
      'amount': amount,
      'num_accounts': numAccounts,
      'flags': flags.toJson(),
    };
  }
}

class AutorizationResponse {
  final String authorized;
  final String authorizedToMaintainLiabilities;
  final String unauthorized;

  AutorizationResponse({
    required this.authorized,
    required this.authorizedToMaintainLiabilities,
    required this.unauthorized,
  });

  factory AutorizationResponse.fromJson(Map<String, dynamic> json) {
    return AutorizationResponse(
      authorized: json['authorized']!.toString(),
      authorizedToMaintainLiabilities:
          json['authorized_to_maintain_liabilities']!.toString(),
      unauthorized: json['unauthorized']!.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorized': authorized,
      'authorized_to_maintain_liabilities': authorizedToMaintainLiabilities,
      'unauthorized': unauthorized,
    };
  }
}

class FlagsResponse {
  final bool authRequired;
  final bool authRevocable;
  final bool authImmutable;

  FlagsResponse({
    required this.authRequired,
    required this.authRevocable,
    required this.authImmutable,
  });

  factory FlagsResponse.fromJson(Map<String, dynamic> json) {
    return FlagsResponse(
      authRequired: json['auth_required'],
      authRevocable: json['auth_revocable'],
      authImmutable: json['auth_immutable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_required': authRequired,
      'auth_revocable': authRevocable,
      'auth_immutable': authImmutable,
    };
  }
}
