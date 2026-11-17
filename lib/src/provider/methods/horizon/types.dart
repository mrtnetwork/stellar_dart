// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: OpenAPI 3.1.0
// Horizon 0.0.1
//
// toJson contract (config-driven): every `toJson` takes an optional
// `JsonifyConfig` (`config`, default `DefaultJsonifyConfig.defaultConfig`) and
// returns the result through `config.encodeMap`, so `toJson` never
// returns null — it always yields a Map.
// BigInt / null handling is delegated to the config: `encodeBigint`
// encodes BigInt values and `encodeMap` post-processes the map.
// Make sure the configured output is `jsonEncode`-compatible: raw
// BigInt values are rejected by `jsonEncode`, so either keep the
// default string encoding or handle BigInt in your own encoder.

import 'package:blockchain_utils/blockchain_utils.dart';

typedef HorizonSignatures = List<String>;

sealed class HorizonAccountEmbeddedRecordsItemBalancesItem {
  const HorizonAccountEmbeddedRecordsItemBalancesItem();

  factory HorizonAccountEmbeddedRecordsItemBalancesItem.fromJson(dynamic json) {
    if (json is Map) {
      final map =
          json is Map<String, dynamic> ? json : Map<String, dynamic>.from(json);
      if (map['asset_type'] == "liquidity_pool_shares" &&
          map.hasValue('liquidity_pool_id') &&
          map.hasValue('balance') &&
          map.hasValue('limit') &&
          map.hasValue('last_modified_ledger') &&
          map.hasValue('is_authorized') &&
          map.hasValue('is_authorized_to_maintain_liabilities')) {
        return HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineLiquidityPool(
          HorizonBalanceLineLiquidityPool.fromJson(map),
        );
      }
      if (map['asset_type'] == "native" && map.hasValue('balance')) {
        return HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative(
          HorizonBalanceLineNative.fromJson(map),
        );
      }
      if (map.hasValue('balance') &&
          map.hasValue('limit') &&
          map.hasValue('asset_type') &&
          map.hasValue('asset_code') &&
          map.hasValue('asset_issuer') &&
          map.hasValue('buying_liabilities') &&
          map.hasValue('selling_liabilities') &&
          map.hasValue('last_modified_ledger') &&
          map.hasValue('is_authorized') &&
          map.hasValue('is_authorized_to_maintain_liabilities')) {
        return HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset(
          HorizonBalanceLineAsset.fromJson(map),
        );
      }
    }
    throw CoreErrors.invalidOperationArguments(
      'HorizonAccountEmbeddedRecordsItemBalancesItem',
      reason:
          'Cannot parse HorizonAccountEmbeddedRecordsItemBalancesItem from $json',
    );
  }

  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig});
}

class HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative
    extends HorizonAccountEmbeddedRecordsItemBalancesItem {
  final HorizonBalanceLineNative value;
  const HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative(
    this.value,
  );

  @override
  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value.toJson(config: config);
}

class HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset
    extends HorizonAccountEmbeddedRecordsItemBalancesItem {
  final HorizonBalanceLineAsset value;
  const HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset(
    this.value,
  );

  @override
  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value.toJson(config: config);
}

class HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineLiquidityPool
    extends HorizonAccountEmbeddedRecordsItemBalancesItem {
  final HorizonBalanceLineLiquidityPool value;
  const HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineLiquidityPool(
    this.value,
  );

  @override
  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value.toJson(config: config);
}

enum HorizonAssetBalanceChangeAssetCode {
  native("native"),
  creditAlphanum4("credit_alphanum4"),
  creditAlphanum12("credit_alphanum12");

  final String value;
  const HorizonAssetBalanceChangeAssetCode(this.value);

  static HorizonAssetBalanceChangeAssetCode fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonAssetBalanceChangeAssetCode found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonAssetBalanceChangeType {
  transfer("transfer"),
  mint("mint"),
  clawback("clawback"),
  burn("burn");

  final String value;
  const HorizonAssetBalanceChangeType(this.value);

  static HorizonAssetBalanceChangeType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonAssetBalanceChangeType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// Status of the transaction submission.
enum HorizonAsyncTransactionSubmissionResponseTxStatus {
  error("ERROR"),
  pending("PENDING"),
  duplicate("DUPLICATE"),
  tryAgainLater("TRY_AGAIN_LATER");

  final String value;
  const HorizonAsyncTransactionSubmissionResponseTxStatus(this.value);

  static HorizonAsyncTransactionSubmissionResponseTxStatus fromJson(
    dynamic json,
  ) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonAsyncTransactionSubmissionResponseTxStatus found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonBalanceLineAssetAssetType {
  native("native"),
  creditAlphanum4("credit_alphanum4"),
  creditAlphanum12("credit_alphanum12");

  final String value;
  const HorizonBalanceLineAssetAssetType(this.value);

  static HorizonBalanceLineAssetAssetType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonBalanceLineAssetAssetType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonBalanceLineLiquidityPoolAssetType {
  liquidityPoolShares("liquidity_pool_shares");

  final String value;
  const HorizonBalanceLineLiquidityPoolAssetType(this.value);

  static HorizonBalanceLineLiquidityPoolAssetType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonBalanceLineLiquidityPoolAssetType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonBalanceLineNativeAssetType {
  native("native");

  final String value;
  const HorizonBalanceLineNativeAssetType(this.value);

  static HorizonBalanceLineNativeAssetType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonBalanceLineNativeAssetType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonEffectEmbeddedRecordsItemType {
  accountCreated("Account Created"),
  accountRemoved("Account Removed"),
  accountCredited("Account Credited"),
  accountDebited("Account Debited"),
  accountThresholdsUpdated("Account Thresholds Updated"),
  accountHomeDomainUpdated("Account Home Domain Updated"),
  accountFlagsUpdated("Account Flags Updated"),
  accountInflationDestinationUpdated("Account Inflation Destination Updated"),
  signerCreated("Signer Created"),
  signerRemoved("Signer Removed"),
  signerUpdated("Signer Updated"),
  trustlineCreated("Trustline Created"),
  trustlineRemoved("Trustline Removed"),
  trustlineUpdated("Trustline Updated"),
  trustlineAuthorized("Trustline Authorized"),
  trustlineDeauthorized("Trustline Deauthorized"),
  offerCreated("Offer Created"),
  offerRemoved("Offer Removed"),
  offerUpdated("Offer Updated"),
  trade("Trade"),
  dataCreated("Data Created"),
  dataRemoved("Data Removed"),
  dataUpdated("Data Updated"),
  claimableBalanceCreated("Claimable Balance Created"),
  claimableBalanceClaimantCreated("Claimable Balance Claimant Created"),
  claimableBalanceClaimed("Claimable Balance Claimed"),
  accountSponsorshipCreated("Account Sponsorship Created"),
  accountSponsorshipUpdated("Account Sponsorship Updated"),
  accountSponsorshipRemoved("Account Sponsorship Removed"),
  trustlineSponsorshipCreated("Trustline Sponsorship Created"),
  trustlineSponsorshipUpdated("Trustline Sponsorship Updated"),
  trustlineSponsorshipRemoved("Trustline Sponsorship Removed"),
  accountDataSponsorshipCreated("Account Data Sponsorship Created"),
  accountDataSponsorshipUpdated("Account Data Sponsorship Updated"),
  accountDataSponsorshipRemoved("Account Data Sponsorship Removed"),
  claimableBalanceSponsorshipCreated("Claimable Balance Sponsorship Created"),
  claimableBalanceSponsorshipUpdated("Claimable Balance Sponsorship Updated"),
  claimableBalanceSponsorshipRemoved("Claimable Balance Sponsorship Removed"),
  accountSignerSponsorshipCreated("Account Signer Sponsorship Created"),
  accountSignerSponsorshipUpdated("Account Signer Sponsorship Updated"),
  accountSignerSponsorshipRemoved("Account Signer Sponsorship Removed"),
  liquidityPoolCreated("Liquidity Pool Created"),
  liquidityPoolRemoved("Liquidity Pool Removed"),
  liquidityPoolRevoked("Liquidity Pool Revoked"),
  liquidityPoolDeposited("Liquidity Pool Deposited"),
  liquidityPoolWithdraw("Liquidity Pool Withdraw"),
  liquidityPoolTrade("Liquidity Pool Trade"),
  sequenceBumped("Sequence Bumped");

  final String value;
  const HorizonEffectEmbeddedRecordsItemType(this.value);

  static HorizonEffectEmbeddedRecordsItemType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonEffectEmbeddedRecordsItemType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonIncludeFailed {
  true_(true),
  false_(false);

  final bool value;
  const HorizonIncludeFailed(this.value);

  static HorizonIncludeFailed fromJson(dynamic json) {
    final value = json;
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonIncludeFailed found for the given value. null",
              ),
    );
  }

  bool toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonJoin {
  transactions("transactions");

  final String value;
  const HorizonJoin(this.value);

  static HorizonJoin fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonJoin found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonOrder {
  asc("asc"),
  desc("desc");

  final String value;
  const HorizonOrder(this.value);

  static HorizonOrder fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonOrder found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

/// NOTE: structurally-identical oneOf/anyOf branch(es) HorizonResolutionVariant1, HorizonResolutionVariant2, HorizonResolutionVariant3, HorizonResolutionVariant4, HorizonResolutionVariant5 parse as HorizonResolutionVariant0; no separate class generated.
sealed class HorizonResolution {
  const HorizonResolution();

  factory HorizonResolution.fromJson(dynamic json) {
    throw CoreErrors.invalidOperationArguments(
      'HorizonResolution',
      reason: 'Cannot parse HorizonResolution from $json',
    );
  }

  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig});
}

class HorizonResolutionVariant0 extends HorizonResolution {
  final dynamic value;
  const HorizonResolutionVariant0(this.value);

  @override
  dynamic toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonSignersType {
  ed25519PublicKey("ed25519_public_key"),
  sha256Hash("sha256_hash"),
  preauthTx("preauth_tx");

  final String value;
  const HorizonSignersType(this.value);

  static HorizonSignersType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonSignersType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

enum HorizonTradeType {
  all("all"),
  orderbook("orderbook"),
  liquidityPools("liquidity_pools");

  final String value;
  const HorizonTradeType(this.value);

  static HorizonTradeType fromJson(dynamic json) {
    final value = json is String ? json : json?.toString();
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching HorizonTradeType found for the given value. null",
              ),
    );
  }

  String toJson({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig}) =>
      value;
}

class HorizonAccount {
  final HorizonAccountEmbedded? embedded;

  const HorizonAccount({this.embedded});

  factory HorizonAccount.fromJson(Map<String, dynamic> json) {
    return HorizonAccount(
      embedded: json.valueTo<HorizonAccountEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonAccountEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonAccountMerge {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final num typeI;
  final String createdAt;
  final String transactionHash;
  final String account;
  final String into;

  const HorizonAccountMerge({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.account,
    required this.into,
  });

  factory HorizonAccountMerge.fromJson(Map<String, dynamic> json) {
    return HorizonAccountMerge(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI: json.valueAsNum<num>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      account:
          (json['account'] is num
              ? json['account'].toString()
              : json.valueAsString<String>('account')),
      into:
          (json['into'] is num
              ? json['into'].toString()
              : json.valueAsString<String>('into')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'account': account,
    'into': into,
  });
}

class HorizonAsset {
  final HorizonAssetEmbedded? embedded;

  const HorizonAsset({this.embedded});

  factory HorizonAsset.fromJson(Map<String, dynamic> json) {
    return HorizonAsset(
      embedded: json.valueTo<HorizonAssetEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonAssetEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonAsset2 {
  final String assetType;
  final String? assetCode;
  final String? assetIssuer;

  const HorizonAsset2({
    required this.assetType,
    this.assetCode,
    this.assetIssuer,
  });

  factory HorizonAsset2.fromJson(Map<String, dynamic> json) {
    return HorizonAsset2(
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String>('asset_type')),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'asset_type': assetType,
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
  });
}

/// POST /transactions_async (response)
class HorizonAsyncTransactionSubmissionResponse {
  /// TransactionResult XDR string which is present only if the submission status from core is an ERROR.
  final String? errorResultXdr;

  /// Status of the transaction submission.
  final HorizonAsyncTransactionSubmissionResponseTxStatus? txStatus;

  /// Hash of the transaction.
  final String? hash;

  const HorizonAsyncTransactionSubmissionResponse({
    this.errorResultXdr,
    this.txStatus,
    this.hash,
  });

  factory HorizonAsyncTransactionSubmissionResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAsyncTransactionSubmissionResponse(
      errorResultXdr:
          (json['error_result_xdr'] is num
              ? json['error_result_xdr'].toString()
              : json.valueAsString<String?>('error_result_xdr')),
      txStatus: json
          .valueTo<HorizonAsyncTransactionSubmissionResponseTxStatus?, Object>(
            key: 'tx_status',
            parse:
                (e) =>
                    HorizonAsyncTransactionSubmissionResponseTxStatus.fromJson(
                      JsonParser.valueAs(e),
                    ),
          ),
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'error_result_xdr': errorResultXdr,
    'tx_status': txStatus?.toJson(config: config),
    'hash': hash,
  });
}

class HorizonBalanceLineAsset {
  final String balance;
  final String limit;
  final String buyingLiabilities;
  final String sellingLiabilities;
  final String? sponsor;
  final int lastModifiedLedger;
  final bool isAuthorized;
  final bool isAuthorizedToMaintainLiabilities;
  final bool? isClawbackEnabled;
  final HorizonBalanceLineAssetAssetType assetType;
  final String assetCode;
  final String assetIssuer;

  const HorizonBalanceLineAsset({
    required this.balance,
    required this.limit,
    required this.buyingLiabilities,
    required this.sellingLiabilities,
    this.sponsor,
    required this.lastModifiedLedger,
    required this.isAuthorized,
    required this.isAuthorizedToMaintainLiabilities,
    this.isClawbackEnabled,
    required this.assetType,
    required this.assetCode,
    required this.assetIssuer,
  });

  factory HorizonBalanceLineAsset.fromJson(Map<String, dynamic> json) {
    return HorizonBalanceLineAsset(
      balance:
          (json['balance'] is num
              ? json['balance'].toString()
              : json.valueAsString<String>('balance')),
      limit:
          (json['limit'] is num
              ? json['limit'].toString()
              : json.valueAsString<String>('limit')),
      buyingLiabilities:
          (json['buying_liabilities'] is num
              ? json['buying_liabilities'].toString()
              : json.valueAsString<String>('buying_liabilities')),
      sellingLiabilities:
          (json['selling_liabilities'] is num
              ? json['selling_liabilities'].toString()
              : json.valueAsString<String>('selling_liabilities')),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      lastModifiedLedger: json.valueAsInt<int>('last_modified_ledger'),
      isAuthorized: json.valueAsBool<bool>('is_authorized'),
      isAuthorizedToMaintainLiabilities: json.valueAsBool<bool>(
        'is_authorized_to_maintain_liabilities',
      ),
      isClawbackEnabled: json.valueAsBool<bool?>('is_clawback_enabled'),
      assetType: json.valueTo<HorizonBalanceLineAssetAssetType, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineAssetAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String>('asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'balance': balance,
    'limit': limit,
    'buying_liabilities': buyingLiabilities,
    'selling_liabilities': sellingLiabilities,
    'sponsor': sponsor,
    'last_modified_ledger': lastModifiedLedger,
    'is_authorized': isAuthorized,
    'is_authorized_to_maintain_liabilities': isAuthorizedToMaintainLiabilities,
    'is_clawback_enabled': isClawbackEnabled,
    'asset_type': assetType.toJson(config: config),
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
  });
}

class HorizonBalanceLineLiquidityPool {
  final String liquidityPoolId;
  final HorizonBalanceLineLiquidityPoolAssetType assetType;
  final String balance;
  final String limit;
  final int lastModifiedLedger;
  final String? sponsor;
  final bool isAuthorized;
  final bool isAuthorizedToMaintainLiabilities;
  final bool? isClawbackEnabled;

  const HorizonBalanceLineLiquidityPool({
    required this.liquidityPoolId,
    required this.assetType,
    required this.balance,
    required this.limit,
    required this.lastModifiedLedger,
    this.sponsor,
    required this.isAuthorized,
    required this.isAuthorizedToMaintainLiabilities,
    this.isClawbackEnabled,
  });

  factory HorizonBalanceLineLiquidityPool.fromJson(Map<String, dynamic> json) {
    return HorizonBalanceLineLiquidityPool(
      liquidityPoolId:
          (json['liquidity_pool_id'] is num
              ? json['liquidity_pool_id'].toString()
              : json.valueAsString<String>('liquidity_pool_id')),
      assetType: json.valueTo<HorizonBalanceLineLiquidityPoolAssetType, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineLiquidityPoolAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      balance:
          (json['balance'] is num
              ? json['balance'].toString()
              : json.valueAsString<String>('balance')),
      limit:
          (json['limit'] is num
              ? json['limit'].toString()
              : json.valueAsString<String>('limit')),
      lastModifiedLedger: json.valueAsInt<int>('last_modified_ledger'),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      isAuthorized: json.valueAsBool<bool>('is_authorized'),
      isAuthorizedToMaintainLiabilities: json.valueAsBool<bool>(
        'is_authorized_to_maintain_liabilities',
      ),
      isClawbackEnabled: json.valueAsBool<bool?>('is_clawback_enabled'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'liquidity_pool_id': liquidityPoolId,
    'asset_type': assetType.toJson(config: config),
    'balance': balance,
    'limit': limit,
    'last_modified_ledger': lastModifiedLedger,
    'sponsor': sponsor,
    'is_authorized': isAuthorized,
    'is_authorized_to_maintain_liabilities': isAuthorizedToMaintainLiabilities,
    'is_clawback_enabled': isClawbackEnabled,
  });
}

class HorizonBalanceLineNative {
  final String balance;
  final String? liquidityPoolId;
  final String? limit;
  final String? buyingLiabilities;
  final String? sellingLiabilities;
  final String? sponsor;
  final int? lastModifiedLedger;
  final bool? isAuthorized;
  final bool? isAuthorizedToMaintainLiabilities;
  final bool? isClawbackEnabled;
  final HorizonBalanceLineNativeAssetType assetType;

  const HorizonBalanceLineNative({
    required this.balance,
    this.liquidityPoolId,
    this.limit,
    this.buyingLiabilities,
    this.sellingLiabilities,
    this.sponsor,
    this.lastModifiedLedger,
    this.isAuthorized,
    this.isAuthorizedToMaintainLiabilities,
    this.isClawbackEnabled,
    required this.assetType,
  });

  factory HorizonBalanceLineNative.fromJson(Map<String, dynamic> json) {
    return HorizonBalanceLineNative(
      balance:
          (json['balance'] is num
              ? json['balance'].toString()
              : json.valueAsString<String>('balance')),
      liquidityPoolId:
          (json['liquidity_pool_id'] is num
              ? json['liquidity_pool_id'].toString()
              : json.valueAsString<String?>('liquidity_pool_id')),
      limit:
          (json['limit'] is num
              ? json['limit'].toString()
              : json.valueAsString<String?>('limit')),
      buyingLiabilities:
          (json['buying_liabilities'] is num
              ? json['buying_liabilities'].toString()
              : json.valueAsString<String?>('buying_liabilities')),
      sellingLiabilities:
          (json['selling_liabilities'] is num
              ? json['selling_liabilities'].toString()
              : json.valueAsString<String?>('selling_liabilities')),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      lastModifiedLedger: json.valueAsInt<int?>('last_modified_ledger'),
      isAuthorized: json.valueAsBool<bool?>('is_authorized'),
      isAuthorizedToMaintainLiabilities: json.valueAsBool<bool?>(
        'is_authorized_to_maintain_liabilities',
      ),
      isClawbackEnabled: json.valueAsBool<bool?>('is_clawback_enabled'),
      assetType: json.valueTo<HorizonBalanceLineNativeAssetType, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineNativeAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'balance': balance,
    'liquidity_pool_id': liquidityPoolId,
    'limit': limit,
    'buying_liabilities': buyingLiabilities,
    'selling_liabilities': sellingLiabilities,
    'sponsor': sponsor,
    'last_modified_ledger': lastModifiedLedger,
    'is_authorized': isAuthorized,
    'is_authorized_to_maintain_liabilities': isAuthorizedToMaintainLiabilities,
    'is_clawback_enabled': isClawbackEnabled,
    'asset_type': assetType.toJson(config: config),
  });
}

class HorizonBaseAsset {
  final String assetType;
  final String? assetCode;
  final String? assetIssuer;

  const HorizonBaseAsset({
    required this.assetType,
    this.assetCode,
    this.assetIssuer,
  });

  factory HorizonBaseAsset.fromJson(Map<String, dynamic> json) {
    return HorizonBaseAsset(
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String>('asset_type')),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'asset_type': assetType,
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
  });
}

class HorizonBaseFeeDistribution {
  final String? max;
  final String? min;
  final String? mode;
  final String? p10;
  final String? p20;
  final String? p30;
  final String? p40;
  final String? p50;
  final String? p60;
  final String? p70;
  final String? p80;
  final String? p90;
  final String? p95;
  final String? p99;

  const HorizonBaseFeeDistribution({
    this.max,
    this.min,
    this.mode,
    this.p10,
    this.p20,
    this.p30,
    this.p40,
    this.p50,
    this.p60,
    this.p70,
    this.p80,
    this.p90,
    this.p95,
    this.p99,
  });

  factory HorizonBaseFeeDistribution.fromJson(Map<String, dynamic> json) {
    return HorizonBaseFeeDistribution(
      max:
          (json['max'] is num
              ? json['max'].toString()
              : json.valueAsString<String?>('max')),
      min:
          (json['min'] is num
              ? json['min'].toString()
              : json.valueAsString<String?>('min')),
      mode:
          (json['mode'] is num
              ? json['mode'].toString()
              : json.valueAsString<String?>('mode')),
      p10:
          (json['p10'] is num
              ? json['p10'].toString()
              : json.valueAsString<String?>('p10')),
      p20:
          (json['p20'] is num
              ? json['p20'].toString()
              : json.valueAsString<String?>('p20')),
      p30:
          (json['p30'] is num
              ? json['p30'].toString()
              : json.valueAsString<String?>('p30')),
      p40:
          (json['p40'] is num
              ? json['p40'].toString()
              : json.valueAsString<String?>('p40')),
      p50:
          (json['p50'] is num
              ? json['p50'].toString()
              : json.valueAsString<String?>('p50')),
      p60:
          (json['p60'] is num
              ? json['p60'].toString()
              : json.valueAsString<String?>('p60')),
      p70:
          (json['p70'] is num
              ? json['p70'].toString()
              : json.valueAsString<String?>('p70')),
      p80:
          (json['p80'] is num
              ? json['p80'].toString()
              : json.valueAsString<String?>('p80')),
      p90:
          (json['p90'] is num
              ? json['p90'].toString()
              : json.valueAsString<String?>('p90')),
      p95:
          (json['p95'] is num
              ? json['p95'].toString()
              : json.valueAsString<String?>('p95')),
      p99:
          (json['p99'] is num
              ? json['p99'].toString()
              : json.valueAsString<String?>('p99')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'max': max,
    'min': min,
    'mode': mode,
    'p10': p10,
    'p20': p20,
    'p30': p30,
    'p40': p40,
    'p50': p50,
    'p60': p60,
    'p70': p70,
    'p80': p80,
    'p90': p90,
    'p95': p95,
    'p99': p99,
  });
}

class HorizonChargedFeeDistribution {
  /// Maximum (highest) fee charged over the last 5 ledgers.
  final dynamic max;

  /// Minimum (lowest) fee charged over the last 5 ledgers.
  final dynamic min;

  /// Mode (middle) fee charged over the last 5 ledgers.
  final dynamic mode;

  /// 10th percentile fee charged over the last 5 ledgers.
  final dynamic p10;

  /// 20th percentile fee charged over the last 5 ledgers.
  final dynamic p20;

  /// 30th percentile fee charged over the last 5 ledgers.
  final dynamic p30;

  /// 40th percentile fee charged over the last 5 ledgers.
  final dynamic p40;

  /// 50th percentile fee charged over the last 5 ledgers.
  final dynamic p50;

  /// 60th percentile fee charged over the last 5 ledgers.
  final dynamic p60;

  /// 70th percentile fee charged over the last 5 ledgers.
  final dynamic p70;

  /// 80th percentile fee charged over the last 5 ledgers.
  final dynamic p80;

  /// 90th percentile fee charged over the last 5 ledgers.
  final dynamic p90;

  /// 95th percentile fee charged over the last 5 ledgers.
  final dynamic p95;

  /// 99th percentile fee charged over the last 5 ledgers.
  final dynamic p99;

  const HorizonChargedFeeDistribution({
    this.max,
    this.min,
    this.mode,
    this.p10,
    this.p20,
    this.p30,
    this.p40,
    this.p50,
    this.p60,
    this.p70,
    this.p80,
    this.p90,
    this.p95,
    this.p99,
  });

  factory HorizonChargedFeeDistribution.fromJson(Map<String, dynamic> json) {
    return HorizonChargedFeeDistribution(
      max: json['max'],
      min: json['min'],
      mode: json['mode'],
      p10: json['p10'],
      p20: json['p20'],
      p30: json['p30'],
      p40: json['p40'],
      p50: json['p50'],
      p60: json['p60'],
      p70: json['p70'],
      p80: json['p80'],
      p90: json['p90'],
      p95: json['p95'],
      p99: json['p99'],
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'max': max,
    'min': min,
    'mode': mode,
    'p10': p10,
    'p20': p20,
    'p30': p30,
    'p40': p40,
    'p50': p50,
    'p60': p60,
    'p70': p70,
    'p80': p80,
    'p90': p90,
    'p95': p95,
    'p99': p99,
  });
}

/// GET /claimable_balances/{claimable_balance_id} (response)
class HorizonClaimableBalanceFlags {
  final bool? clawbackEnabled;

  const HorizonClaimableBalanceFlags({this.clawbackEnabled});

  factory HorizonClaimableBalanceFlags.fromJson(Map<String, dynamic> json) {
    return HorizonClaimableBalanceFlags(
      clawbackEnabled: json.valueAsBool<bool?>('clawback_enabled'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) =>
      config.encodeMap(<String, dynamic>{'clawback_enabled': clawbackEnabled});
}

/// GET /claimable_balances/{claimable_balance_id} (response)
class HorizonClaimableBalance {
  final HorizonClaimableBalanceLinks? links;
  final String id;
  final String asset;
  final String amount;
  final String? sponsor;
  final String lastModifiedLedger;
  final String lastModifiedTime;
  final List<HorizonClaimableBalanceClaimantsItem>? claimants;
  final HorizonClaimableBalanceFlags? flags;
  final String pagingToken;

  const HorizonClaimableBalance({
    this.links,
    required this.id,
    required this.asset,
    required this.amount,
    this.sponsor,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
    this.claimants,
    this.flags,
    required this.pagingToken,
  });

  factory HorizonClaimableBalance.fromJson(Map<String, dynamic> json) {
    return HorizonClaimableBalance(
      links: json.valueTo<HorizonClaimableBalanceLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonClaimableBalanceLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      asset:
          (json['asset'] is num
              ? json['asset'].toString()
              : json.valueAsString<String>('asset')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      lastModifiedLedger:
          (json['last_modified_ledger'] is num
              ? json['last_modified_ledger'].toString()
              : json.valueAsString<String>('last_modified_ledger')),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
      claimants:
          json.hasValue('claimants')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('claimants')
                  .map((e) => HorizonClaimableBalanceClaimantsItem.fromJson(e))
                  .toList()
              : null,
      flags: json.valueTo<HorizonClaimableBalanceFlags?, Map<String, dynamic>>(
        key: 'flags',
        parse: (v) => HorizonClaimableBalanceFlags.fromJson(v),
      ),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'asset': asset,
    'amount': amount,
    'sponsor': sponsor,
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
    'claimants': claimants?.map((e) => e.toJson(config: config)).toList(),
    'flags': flags?.toJson(config: config),
    'paging_token': pagingToken,
  });
}

class HorizonClaimableBalances {
  final HorizonClaimableBalancesEmbedded? embedded;

  const HorizonClaimableBalances({this.embedded});

  factory HorizonClaimableBalances.fromJson(Map<String, dynamic> json) {
    return HorizonClaimableBalances(
      embedded: json
          .valueTo<HorizonClaimableBalancesEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonClaimableBalancesEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonCreateAccount {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final num typeI;
  final String createdAt;
  final String transactionHash;
  final String startingBalance;
  final String funder;
  final String account;

  const HorizonCreateAccount({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.startingBalance,
    required this.funder,
    required this.account,
  });

  factory HorizonCreateAccount.fromJson(Map<String, dynamic> json) {
    return HorizonCreateAccount(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI: json.valueAsNum<num>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      startingBalance:
          (json['starting_balance'] is num
              ? json['starting_balance'].toString()
              : json.valueAsString<String>('starting_balance')),
      funder:
          (json['funder'] is num
              ? json['funder'].toString()
              : json.valueAsString<String>('funder')),
      account:
          (json['account'] is num
              ? json['account'].toString()
              : json.valueAsString<String>('account')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'starting_balance': startingBalance,
    'funder': funder,
    'account': account,
  });
}

class HorizonEffect {
  final HorizonEffectEmbedded? embedded;

  const HorizonEffect({this.embedded});

  factory HorizonEffect.fromJson(Map<String, dynamic> json) {
    return HorizonEffect(
      embedded: json.valueTo<HorizonEffectEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonEffectEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonFeeBumpTransaction {
  final String? hash;
  final HorizonSignatures? signatures;

  const HorizonFeeBumpTransaction({this.hash, this.signatures});

  factory HorizonFeeBumpTransaction.fromJson(Map<String, dynamic> json) {
    return HorizonFeeBumpTransaction(
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
      signatures: json.valueAsList<List<String>?>('signatures'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'hash': hash,
    'signatures': signatures,
  });
}

/// GET /fee_stats (response)
class HorizonFeeStats {
  /// The last ledger's sequence number.
  final String? lastLedger;

  /// The base fee as defined in the last ledger.
  final String? lastLedgerBaseFee;

  /// The average capacity usage over the last 5 ledgers (0 is no usage, 1.0 is completely full ledgers).
  final String? ledgerCapacityUsage;
  final HorizonFeeStatsFeeCharged? feeCharged;
  final HorizonFeeStatsFeeCharged? maxFee;

  const HorizonFeeStats({
    this.lastLedger,
    this.lastLedgerBaseFee,
    this.ledgerCapacityUsage,
    this.feeCharged,
    this.maxFee,
  });

  factory HorizonFeeStats.fromJson(Map<String, dynamic> json) {
    return HorizonFeeStats(
      lastLedger:
          (json['last_ledger'] is num
              ? json['last_ledger'].toString()
              : json.valueAsString<String?>('last_ledger')),
      lastLedgerBaseFee:
          (json['last_ledger_base_fee'] is num
              ? json['last_ledger_base_fee'].toString()
              : json.valueAsString<String?>('last_ledger_base_fee')),
      ledgerCapacityUsage:
          (json['ledger_capacity_usage'] is num
              ? json['ledger_capacity_usage'].toString()
              : json.valueAsString<String?>('ledger_capacity_usage')),
      feeCharged: json
          .valueTo<HorizonFeeStatsFeeCharged?, Map<String, dynamic>>(
            key: 'fee_charged',
            parse: (v) => HorizonFeeStatsFeeCharged.fromJson(v),
          ),
      maxFee: json.valueTo<HorizonFeeStatsFeeCharged?, Map<String, dynamic>>(
        key: 'max_fee',
        parse: (v) => HorizonFeeStatsFeeCharged.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'last_ledger': lastLedger,
    'last_ledger_base_fee': lastLedgerBaseFee,
    'ledger_capacity_usage': ledgerCapacityUsage,
    'fee_charged': feeCharged?.toJson(config: config),
    'max_fee': maxFee?.toJson(config: config),
  });
}

class HorizonInnerTransaction {
  final String? hash;
  final HorizonSignatures? signatures;
  final String? maxFee;

  const HorizonInnerTransaction({this.hash, this.signatures, this.maxFee});

  factory HorizonInnerTransaction.fromJson(Map<String, dynamic> json) {
    return HorizonInnerTransaction(
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
      signatures: json.valueAsList<List<String>?>('signatures'),
      maxFee:
          (json['max_fee'] is num
              ? json['max_fee'].toString()
              : json.valueAsString<String?>('max_fee')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'hash': hash,
    'signatures': signatures,
    'max_fee': maxFee,
  });
}

class HorizonInvokeHostFunction {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final num typeI;
  final String createdAt;
  final String transactionHash;
  final String function;
  final List<HorizonHostFunctionParameter>? parameters;
  final String? address;
  final String? salt;
  final List<HorizonAssetBalanceChange>? assetBalanceChanges;

  const HorizonInvokeHostFunction({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.function,
    this.parameters,
    this.address,
    this.salt,
    this.assetBalanceChanges,
  });

  factory HorizonInvokeHostFunction.fromJson(Map<String, dynamic> json) {
    return HorizonInvokeHostFunction(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI: json.valueAsNum<num>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      function:
          (json['function'] is num
              ? json['function'].toString()
              : json.valueAsString<String>('function')),
      parameters:
          json.hasValue('parameters')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('parameters')
                  .map((e) => HorizonHostFunctionParameter.fromJson(e))
                  .toList()
              : null,
      address:
          (json['address'] is num
              ? json['address'].toString()
              : json.valueAsString<String?>('address')),
      salt:
          (json['salt'] is num
              ? json['salt'].toString()
              : json.valueAsString<String?>('salt')),
      assetBalanceChanges:
          json.hasValue('asset_balance_changes')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>(
                    'asset_balance_changes',
                  )
                  .map((e) => HorizonAssetBalanceChange.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'function': function,
    'parameters': parameters?.map((e) => e.toJson(config: config)).toList(),
    'address': address,
    'salt': salt,
    'asset_balance_changes':
        assetBalanceChanges?.map((e) => e.toJson(config: config)).toList(),
  });
}

/// GET /ledgers/{sequence} (response)
/// GET /ledgers (response)
class HorizonLedger {
  final HorizonLedgerEmbedded? embedded;

  const HorizonLedger({this.embedded});

  factory HorizonLedger.fromJson(Map<String, dynamic> json) {
    return HorizonLedger(
      embedded: json.valueTo<HorizonLedgerEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonLedgerEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonLinks {
  final HorizonLinksLinks? links;

  const HorizonLinks({this.links});

  factory HorizonLinks.fromJson(Map<String, dynamic> json) {
    return HorizonLinks(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
  });
}

/// GET /liquidity_pools/{liquidity_pool_id} (response)
class HorizonLiquidityPool {
  final HorizonClaimableBalanceLinks? links;
  final String id;
  final String pagingToken;
  final int feeBp;
  final String type;
  final String totalTrustlines;
  final String totalShares;
  final HorizonLiquidityPoolReserves reserves;
  final String lastModifiedLedger;
  final String lastModifiedTime;

  const HorizonLiquidityPool({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.feeBp,
    required this.type,
    required this.totalTrustlines,
    required this.totalShares,
    required this.reserves,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
  });

  factory HorizonLiquidityPool.fromJson(Map<String, dynamic> json) {
    return HorizonLiquidityPool(
      links: json.valueTo<HorizonClaimableBalanceLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonClaimableBalanceLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      feeBp: json.valueAsInt<int>('fee_bp'),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      totalTrustlines:
          (json['total_trustlines'] is num
              ? json['total_trustlines'].toString()
              : json.valueAsString<String>('total_trustlines')),
      totalShares:
          (json['total_shares'] is num
              ? json['total_shares'].toString()
              : json.valueAsString<String>('total_shares')),
      reserves: json
          .valueTo<HorizonLiquidityPoolReserves, Map<String, dynamic>>(
            key: 'reserves',
            parse: (v) => HorizonLiquidityPoolReserves.fromJson(v),
          ),
      lastModifiedLedger:
          (json['last_modified_ledger'] is num
              ? json['last_modified_ledger'].toString()
              : json.valueAsString<String>('last_modified_ledger')),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'fee_bp': feeBp,
    'type': type,
    'total_trustlines': totalTrustlines,
    'total_shares': totalShares,
    'reserves': reserves.toJson(config: config),
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
  });
}

class HorizonLiquidityPools {
  final HorizonLiquidityPoolsEmbedded? embedded;

  const HorizonLiquidityPools({this.embedded});

  factory HorizonLiquidityPools.fromJson(Map<String, dynamic> json) {
    return HorizonLiquidityPools(
      embedded: json
          .valueTo<HorizonLiquidityPoolsEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonLiquidityPoolsEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonMaxFeeDistribution {
  /// Maximum (highest) value of the maximum fee bid over the last 5 ledgers.
  final dynamic max;

  /// Minimum (lowest) value of the maximum fee bid over the last 5 ledgers.
  final dynamic min;

  /// Mode (middle) value of the maximum fee bid over the last 5 ledgers.
  final dynamic mode;

  /// 10th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p10;

  /// 20th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p20;

  /// 30th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p30;

  /// 40th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p40;

  /// 50th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p50;

  /// 60th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p60;

  /// 70th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p70;

  /// 80th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p80;

  /// 90th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p90;

  /// 95th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p95;

  /// 99th percentile value of the maximum fee bid over the last 5 ledgers.
  final dynamic p99;

  const HorizonMaxFeeDistribution({
    this.max,
    this.min,
    this.mode,
    this.p10,
    this.p20,
    this.p30,
    this.p40,
    this.p50,
    this.p60,
    this.p70,
    this.p80,
    this.p90,
    this.p95,
    this.p99,
  });

  factory HorizonMaxFeeDistribution.fromJson(Map<String, dynamic> json) {
    return HorizonMaxFeeDistribution(
      max: json['max'],
      min: json['min'],
      mode: json['mode'],
      p10: json['p10'],
      p20: json['p20'],
      p30: json['p30'],
      p40: json['p40'],
      p50: json['p50'],
      p60: json['p60'],
      p70: json['p70'],
      p80: json['p80'],
      p90: json['p90'],
      p95: json['p95'],
      p99: json['p99'],
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'max': max,
    'min': min,
    'mode': mode,
    'p10': p10,
    'p20': p20,
    'p30': p30,
    'p40': p40,
    'p50': p50,
    'p60': p60,
    'p70': p70,
    'p80': p80,
    'p90': p90,
    'p95': p95,
    'p99': p99,
  });
}

class HorizonOffer {
  final HorizonOfferEmbedded? embedded;

  const HorizonOffer({this.embedded});

  factory HorizonOffer.fromJson(Map<String, dynamic> json) {
    return HorizonOffer(
      embedded: json.valueTo<HorizonOfferEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonOfferEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

/// GET /ledgers/{sequence}/operations (response)
class HorizonOperation {
  final HorizonOperationLinks? links;
  final String? id;
  final String? pagingToken;
  final num? typeI;
  final String? type;

  const HorizonOperation({
    this.links,
    this.id,
    this.pagingToken,
    this.typeI,
    this.type,
  });

  factory HorizonOperation.fromJson(Map<String, dynamic> json) {
    return HorizonOperation(
      links: json.valueTo<HorizonOperationLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonOperationLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      typeI: json.valueAsNum<num?>('type_i'),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String?>('type')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'type_i': typeI,
    'type': type,
  });
}

/// GET /order_book (response)
class HorizonOrderBook {
  final List<HorizonOrderBookBidsItem>? bids;
  final List<HorizonOrderBookBidsItem>? asks;
  final HorizonOrderBookBase? base_;
  final HorizonOrderBookCounter? counter;

  const HorizonOrderBook({this.bids, this.asks, this.base_, this.counter});

  factory HorizonOrderBook.fromJson(Map<String, dynamic> json) {
    return HorizonOrderBook(
      bids:
          json.hasValue('bids')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('bids')
                  .map((e) => HorizonOrderBookBidsItem.fromJson(e))
                  .toList()
              : null,
      asks:
          json.hasValue('asks')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('asks')
                  .map((e) => HorizonOrderBookBidsItem.fromJson(e))
                  .toList()
              : null,
      base_: json.valueTo<HorizonOrderBookBase?, Map<String, dynamic>>(
        key: 'base',
        parse: (v) => HorizonOrderBookBase.fromJson(v),
      ),
      counter: json.valueTo<HorizonOrderBookCounter?, Map<String, dynamic>>(
        key: 'counter',
        parse: (v) => HorizonOrderBookCounter.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'bids': bids?.map((e) => e.toJson(config: config)).toList(),
    'asks': asks?.map((e) => e.toJson(config: config)).toList(),
    'base': base_?.toJson(config: config),
    'counter': counter?.toJson(config: config),
  });
}

/// GET /paths/strict-receive (response)
/// GET /paths/strict-send (response)
class HorizonPath {
  final HorizonPathEmbedded? embedded;

  const HorizonPath({this.embedded});

  factory HorizonPath.fromJson(Map<String, dynamic> json) {
    return HorizonPath(
      embedded: json.valueTo<HorizonPathEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonPathEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonPathPaymentStrictReceive {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final num typeI;
  final String createdAt;
  final String transactionHash;
  final HorizonBalanceLineAssetAssetType? assetType;
  final String? assetCode;
  final String? assetIssuer;
  final String from;
  final String to;
  final String amount;
  final List<HorizonPathPaymentStrictReceivePathItem> path;
  final String sourceAmount;
  final String destinationMin;
  final String? sourceAssetType;
  final String? sourceAssetCode;
  final String? sourceAssetIssuer;

  const HorizonPathPaymentStrictReceive({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    this.assetType,
    this.assetCode,
    this.assetIssuer,
    required this.from,
    required this.to,
    required this.amount,
    required this.path,
    required this.sourceAmount,
    required this.destinationMin,
    this.sourceAssetType,
    this.sourceAssetCode,
    this.sourceAssetIssuer,
  });

  factory HorizonPathPaymentStrictReceive.fromJson(Map<String, dynamic> json) {
    return HorizonPathPaymentStrictReceive(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI: json.valueAsNum<num>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      assetType: json.valueTo<HorizonBalanceLineAssetAssetType?, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineAssetAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
      from:
          (json['from'] is num
              ? json['from'].toString()
              : json.valueAsString<String>('from')),
      to:
          (json['to'] is num
              ? json['to'].toString()
              : json.valueAsString<String>('to')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
      path:
          json
              .valueEnsureAsList<Map<String, dynamic>>('path')
              .map((e) => HorizonPathPaymentStrictReceivePathItem.fromJson(e))
              .toList(),
      sourceAmount:
          (json['source_amount'] is num
              ? json['source_amount'].toString()
              : json.valueAsString<String>('source_amount')),
      destinationMin:
          (json['destination_min'] is num
              ? json['destination_min'].toString()
              : json.valueAsString<String>('destination_min')),
      sourceAssetType:
          (json['source_asset_type'] is num
              ? json['source_asset_type'].toString()
              : json.valueAsString<String?>('source_asset_type')),
      sourceAssetCode:
          (json['source_asset_code'] is num
              ? json['source_asset_code'].toString()
              : json.valueAsString<String?>('source_asset_code')),
      sourceAssetIssuer:
          (json['source_asset_issuer'] is num
              ? json['source_asset_issuer'].toString()
              : json.valueAsString<String?>('source_asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'asset_type': assetType?.toJson(config: config),
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
    'from': from,
    'to': to,
    'amount': amount,
    'path': path.map((e) => e.toJson(config: config)).toList(),
    'source_amount': sourceAmount,
    'destination_min': destinationMin,
    'source_asset_type': sourceAssetType,
    'source_asset_code': sourceAssetCode,
    'source_asset_issuer': sourceAssetIssuer,
  });
}

class HorizonPathPaymentStrictSend {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final num typeI;
  final String createdAt;
  final String transactionHash;
  final HorizonBalanceLineAssetAssetType? assetType;
  final String? assetCode;
  final String? assetIssuer;
  final String from;
  final String to;
  final String amount;
  final List<HorizonPathPaymentStrictReceivePathItem> path;
  final String sourceAmount;
  final String? sourceMax;
  final String sourceAssetType;
  final String? sourceAssetCode;
  final String? sourceAssetIssuer;

  const HorizonPathPaymentStrictSend({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    this.assetType,
    this.assetCode,
    this.assetIssuer,
    required this.from,
    required this.to,
    required this.amount,
    required this.path,
    required this.sourceAmount,
    this.sourceMax,
    required this.sourceAssetType,
    this.sourceAssetCode,
    this.sourceAssetIssuer,
  });

  factory HorizonPathPaymentStrictSend.fromJson(Map<String, dynamic> json) {
    return HorizonPathPaymentStrictSend(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI: json.valueAsNum<num>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      assetType: json.valueTo<HorizonBalanceLineAssetAssetType?, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineAssetAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
      from:
          (json['from'] is num
              ? json['from'].toString()
              : json.valueAsString<String>('from')),
      to:
          (json['to'] is num
              ? json['to'].toString()
              : json.valueAsString<String>('to')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
      path:
          json
              .valueEnsureAsList<Map<String, dynamic>>('path')
              .map((e) => HorizonPathPaymentStrictReceivePathItem.fromJson(e))
              .toList(),
      sourceAmount:
          (json['source_amount'] is num
              ? json['source_amount'].toString()
              : json.valueAsString<String>('source_amount')),
      sourceMax:
          (json['source_max'] is num
              ? json['source_max'].toString()
              : json.valueAsString<String?>('source_max')),
      sourceAssetType:
          (json['source_asset_type'] is num
              ? json['source_asset_type'].toString()
              : json.valueAsString<String>('source_asset_type')),
      sourceAssetCode:
          (json['source_asset_code'] is num
              ? json['source_asset_code'].toString()
              : json.valueAsString<String?>('source_asset_code')),
      sourceAssetIssuer:
          (json['source_asset_issuer'] is num
              ? json['source_asset_issuer'].toString()
              : json.valueAsString<String?>('source_asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'asset_type': assetType?.toJson(config: config),
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
    'from': from,
    'to': to,
    'amount': amount,
    'path': path.map((e) => e.toJson(config: config)).toList(),
    'source_amount': sourceAmount,
    'source_max': sourceMax,
    'source_asset_type': sourceAssetType,
    'source_asset_code': sourceAssetCode,
    'source_asset_issuer': sourceAssetIssuer,
  });
}

class HorizonPayment {
  final HorizonPaymentEmbedded? embedded;

  const HorizonPayment({this.embedded});

  factory HorizonPayment.fromJson(Map<String, dynamic> json) {
    return HorizonPayment(
      embedded: json.valueTo<HorizonPaymentEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonPaymentEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonPrice {
  final int? n;
  final int? d;

  const HorizonPrice({this.n, this.d});

  factory HorizonPrice.fromJson(Map<String, dynamic> json) {
    return HorizonPrice(
      n: json.valueAsInt<int?>('n'),
      d: json.valueAsInt<int?>('d'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'n': n, 'd': d});
}

/// POST /transactions_async (response)
class HorizonProblem {
  /// Identifies the problem type.
  final String? type;

  /// A short, human-readable summary of the problem type.
  final String? title;

  /// The HTTP status code for this occurrence of the problem.
  final int? status;

  /// A human-readable explanation specific to this occurrence of the problem.
  final String? detail;

  /// Additional details that might help the client understand the error(s) that occurred.
  final Map<String, dynamic>? extras;

  const HorizonProblem({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.extras,
  });

  factory HorizonProblem.fromJson(Map<String, dynamic> json) {
    return HorizonProblem(
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String?>('type')),
      title:
          (json['title'] is num
              ? json['title'].toString()
              : json.valueAsString<String?>('title')),
      status: json.valueAsInt<int?>('status'),
      detail:
          (json['detail'] is num
              ? json['detail'].toString()
              : json.valueAsString<String?>('detail')),
      extras: json.valueAsMap<Map<String, dynamic>?>('extras'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'type': type,
    'title': title,
    'status': status,
    'detail': detail,
    'extras': extras,
  });
}

/// POST /transactions (response)
class HorizonSubmitTransaction {
  final HorizonSubmitTransactionEmbedded? embedded;

  const HorizonSubmitTransaction({this.embedded});

  factory HorizonSubmitTransaction.fromJson(Map<String, dynamic> json) {
    return HorizonSubmitTransaction(
      embedded: json
          .valueTo<HorizonSubmitTransactionEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonSubmitTransactionEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonTrade {
  final HorizonTradeEmbedded? embedded;

  const HorizonTrade({this.embedded});

  factory HorizonTrade.fromJson(Map<String, dynamic> json) {
    return HorizonTrade(
      embedded: json.valueTo<HorizonTradeEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonTradeEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

/// GET /trade_aggregations (response)
class HorizonTradeAggregation {
  final HorizonTradeAggregationEmbedded? embedded;

  const HorizonTradeAggregation({this.embedded});

  factory HorizonTradeAggregation.fromJson(Map<String, dynamic> json) {
    return HorizonTradeAggregation(
      embedded: json
          .valueTo<HorizonTradeAggregationEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonTradeAggregationEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonTransaction {
  final HorizonTransactionEmbedded? embedded;

  const HorizonTransaction({this.embedded});

  factory HorizonTransaction.fromJson(Map<String, dynamic> json) {
    return HorizonTransaction(
      embedded: json.valueTo<HorizonTransactionEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonTransactionEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_embedded': embedded?.toJson(config: config),
  });
}

/// GET /transactions/{transaction_hash} (response)
class HorizonTransaction2 {
  final HorizonTransaction2Links? links;
  final String? id;
  final String? pagingToken;
  final bool? successful;
  final String? hash;
  final int? ledger;
  final String? createdAt;
  final String? sourceAccount;
  final String? accountMuxed;
  final String? accountMuxedId;
  final String? sourceAccountSequence;
  final String? feeAccount;
  final String? feeAccountMuxed;
  final String? feeAccountMuxedId;
  final String? feeCharged;
  final String? maxFee;
  final int? operationCount;
  final String? envelopeXdr;
  final String? resultXdr;
  final String? resultMetaXdr;
  final String? feeMetaXdr;
  final String? memoType;
  final HorizonSignatures? signatures;

  const HorizonTransaction2({
    this.links,
    this.id,
    this.pagingToken,
    this.successful,
    this.hash,
    this.ledger,
    this.createdAt,
    this.sourceAccount,
    this.accountMuxed,
    this.accountMuxedId,
    this.sourceAccountSequence,
    this.feeAccount,
    this.feeAccountMuxed,
    this.feeAccountMuxedId,
    this.feeCharged,
    this.maxFee,
    this.operationCount,
    this.envelopeXdr,
    this.resultXdr,
    this.resultMetaXdr,
    this.feeMetaXdr,
    this.memoType,
    this.signatures,
  });

  factory HorizonTransaction2.fromJson(Map<String, dynamic> json) {
    return HorizonTransaction2(
      links: json.valueTo<HorizonTransaction2Links?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonTransaction2Links.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      successful: json.valueAsBool<bool?>('successful'),
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
      ledger: json.valueAsInt<int?>('ledger'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String?>('created_at')),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String?>('source_account')),
      accountMuxed:
          (json['account_muxed'] is num
              ? json['account_muxed'].toString()
              : json.valueAsString<String?>('account_muxed')),
      accountMuxedId:
          (json['account_muxed_id'] is num
              ? json['account_muxed_id'].toString()
              : json.valueAsString<String?>('account_muxed_id')),
      sourceAccountSequence:
          (json['source_account_sequence'] is num
              ? json['source_account_sequence'].toString()
              : json.valueAsString<String?>('source_account_sequence')),
      feeAccount:
          (json['fee_account'] is num
              ? json['fee_account'].toString()
              : json.valueAsString<String?>('fee_account')),
      feeAccountMuxed:
          (json['fee_account_muxed'] is num
              ? json['fee_account_muxed'].toString()
              : json.valueAsString<String?>('fee_account_muxed')),
      feeAccountMuxedId:
          (json['fee_account_muxed_id'] is num
              ? json['fee_account_muxed_id'].toString()
              : json.valueAsString<String?>('fee_account_muxed_id')),
      feeCharged:
          (json['fee_charged'] is num
              ? json['fee_charged'].toString()
              : json.valueAsString<String?>('fee_charged')),
      maxFee:
          (json['max_fee'] is num
              ? json['max_fee'].toString()
              : json.valueAsString<String?>('max_fee')),
      operationCount: json.valueAsInt<int?>('operation_count'),
      envelopeXdr:
          (json['envelope_xdr'] is num
              ? json['envelope_xdr'].toString()
              : json.valueAsString<String?>('envelope_xdr')),
      resultXdr:
          (json['result_xdr'] is num
              ? json['result_xdr'].toString()
              : json.valueAsString<String?>('result_xdr')),
      resultMetaXdr:
          (json['result_meta_xdr'] is num
              ? json['result_meta_xdr'].toString()
              : json.valueAsString<String?>('result_meta_xdr')),
      feeMetaXdr:
          (json['fee_meta_xdr'] is num
              ? json['fee_meta_xdr'].toString()
              : json.valueAsString<String?>('fee_meta_xdr')),
      memoType:
          (json['memo_type'] is num
              ? json['memo_type'].toString()
              : json.valueAsString<String?>('memo_type')),
      signatures: json.valueAsList<List<String>?>('signatures'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'successful': successful,
    'hash': hash,
    'ledger': ledger,
    'created_at': createdAt,
    'source_account': sourceAccount,
    'account_muxed': accountMuxed,
    'account_muxed_id': accountMuxedId,
    'source_account_sequence': sourceAccountSequence,
    'fee_account': feeAccount,
    'fee_account_muxed': feeAccountMuxed,
    'fee_account_muxed_id': feeAccountMuxedId,
    'fee_charged': feeCharged,
    'max_fee': maxFee,
    'operation_count': operationCount,
    'envelope_xdr': envelopeXdr,
    'result_xdr': resultXdr,
    'result_meta_xdr': resultMetaXdr,
    'fee_meta_xdr': feeMetaXdr,
    'memo_type': memoType,
    'signatures': signatures,
  });
}

class HorizonTransactionPreconditions {
  final HorizonTransactionPreconditionsTimebounds? timebounds;
  final HorizonTransactionPreconditionsLedgerbounds? ledgerbounds;
  final String? minAccountSequence;
  final String? minAccountSequenceAge;
  final int? minAccountSequenceLedgerGap;
  final List<String>? extraSigners;

  const HorizonTransactionPreconditions({
    this.timebounds,
    this.ledgerbounds,
    this.minAccountSequence,
    this.minAccountSequenceAge,
    this.minAccountSequenceLedgerGap,
    this.extraSigners,
  });

  factory HorizonTransactionPreconditions.fromJson(Map<String, dynamic> json) {
    return HorizonTransactionPreconditions(
      timebounds: json.valueTo<
        HorizonTransactionPreconditionsTimebounds?,
        Map<String, dynamic>
      >(
        key: 'timebounds',
        parse: (v) => HorizonTransactionPreconditionsTimebounds.fromJson(v),
      ),
      ledgerbounds: json.valueTo<
        HorizonTransactionPreconditionsLedgerbounds?,
        Map<String, dynamic>
      >(
        key: 'ledgerbounds',
        parse: (v) => HorizonTransactionPreconditionsLedgerbounds.fromJson(v),
      ),
      minAccountSequence:
          (json['min_account_sequence'] is num
              ? json['min_account_sequence'].toString()
              : json.valueAsString<String?>('min_account_sequence')),
      minAccountSequenceAge:
          (json['min_account_sequence_age'] is num
              ? json['min_account_sequence_age'].toString()
              : json.valueAsString<String?>('min_account_sequence_age')),
      minAccountSequenceLedgerGap: json.valueAsInt<int?>(
        'min_account_sequence_ledger_gap',
      ),
      extraSigners: json.valueAsList<List<String>?>('extra_signers'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'timebounds': timebounds?.toJson(config: config),
    'ledgerbounds': ledgerbounds?.toJson(config: config),
    'min_account_sequence': minAccountSequence,
    'min_account_sequence_age': minAccountSequenceAge,
    'min_account_sequence_ledger_gap': minAccountSequenceLedgerGap,
    'extra_signers': extraSigners,
  });
}

class HorizonTransactionPreconditionsLedgerbounds {
  final String? minLedger;
  final String? maxLedger;

  const HorizonTransactionPreconditionsLedgerbounds({
    this.minLedger,
    this.maxLedger,
  });

  factory HorizonTransactionPreconditionsLedgerbounds.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonTransactionPreconditionsLedgerbounds(
      minLedger:
          (json['min_ledger'] is num
              ? json['min_ledger'].toString()
              : json.valueAsString<String?>('min_ledger')),
      maxLedger:
          (json['max_ledger'] is num
              ? json['max_ledger'].toString()
              : json.valueAsString<String?>('max_ledger')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'min_ledger': minLedger,
    'max_ledger': maxLedger,
  });
}

class HorizonTransactionPreconditionsTimebounds {
  final String? minTime;
  final String? maxTime;

  const HorizonTransactionPreconditionsTimebounds({this.minTime, this.maxTime});

  factory HorizonTransactionPreconditionsTimebounds.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonTransactionPreconditionsTimebounds(
      minTime:
          (json['min_time'] is num
              ? json['min_time'].toString()
              : json.valueAsString<String?>('min_time')),
      maxTime:
          (json['max_time'] is num
              ? json['max_time'].toString()
              : json.valueAsString<String?>('max_time')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'min_time': minTime,
    'max_time': maxTime,
  });
}

class HorizonAssetBalanceChange {
  final String assetType;
  final HorizonAssetBalanceChangeAssetCode? assetCode;
  final String? assetIssuer;
  final HorizonAssetBalanceChangeType type;
  final String? from;
  final String? to;
  final String amount;

  const HorizonAssetBalanceChange({
    required this.assetType,
    this.assetCode,
    this.assetIssuer,
    required this.type,
    this.from,
    this.to,
    required this.amount,
  });

  factory HorizonAssetBalanceChange.fromJson(Map<String, dynamic> json) {
    return HorizonAssetBalanceChange(
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String>('asset_type')),
      assetCode: json.valueTo<HorizonAssetBalanceChangeAssetCode?, Object>(
        key: 'asset_code',
        parse:
            (e) => HorizonAssetBalanceChangeAssetCode.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
      type: json.valueTo<HorizonAssetBalanceChangeType, Object>(
        key: 'type',
        parse:
            (e) =>
                HorizonAssetBalanceChangeType.fromJson(JsonParser.valueAs(e)),
      ),
      from:
          (json['from'] is num
              ? json['from'].toString()
              : json.valueAsString<String?>('from')),
      to:
          (json['to'] is num
              ? json['to'].toString()
              : json.valueAsString<String?>('to')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'asset_type': assetType,
    'asset_code': assetCode?.toJson(config: config),
    'asset_issuer': assetIssuer,
    'type': type.toJson(config: config),
    'from': from,
    'to': to,
    'amount': amount,
  });
}

class HorizonFlags {
  final bool? authRequired;
  final bool? authRevocable;
  final bool? authImmutable;
  final bool? authClawbackEnabled;

  const HorizonFlags({
    this.authRequired,
    this.authRevocable,
    this.authImmutable,
    this.authClawbackEnabled,
  });

  factory HorizonFlags.fromJson(Map<String, dynamic> json) {
    return HorizonFlags(
      authRequired: json.valueAsBool<bool?>('auth_required'),
      authRevocable: json.valueAsBool<bool?>('auth_revocable'),
      authImmutable: json.valueAsBool<bool?>('auth_immutable'),
      authClawbackEnabled: json.valueAsBool<bool?>('auth_clawback_enabled'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'auth_required': authRequired,
    'auth_revocable': authRevocable,
    'auth_immutable': authImmutable,
    'auth_clawback_enabled': authClawbackEnabled,
  });
}

class HorizonHostFunctionParameter {
  final String value;
  final String type;

  const HorizonHostFunctionParameter({required this.value, required this.type});

  factory HorizonHostFunctionParameter.fromJson(Map<String, dynamic> json) {
    return HorizonHostFunctionParameter(
      value:
          (json['value'] is num
              ? json['value'].toString()
              : json.valueAsString<String>('value')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'value': value, 'type': type});
}

class HorizonLink {
  final String href;
  final bool? templated;

  const HorizonLink({required this.href, this.templated});

  factory HorizonLink.fromJson(Map<String, dynamic> json) {
    return HorizonLink(
      href:
          (json['href'] is num
              ? json['href'].toString()
              : json.valueAsString<String>('href')),
      templated: json.valueAsBool<bool?>('templated'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) =>
      config.encodeMap(<String, dynamic>{'href': href, 'templated': templated});
}

class HorizonSigners {
  final String key;
  final int weight;
  final HorizonSignersType type;
  final String? sponsor;

  const HorizonSigners({
    required this.key,
    required this.weight,
    required this.type,
    this.sponsor,
  });

  factory HorizonSigners.fromJson(Map<String, dynamic> json) {
    return HorizonSigners(
      key:
          (json['key'] is num
              ? json['key'].toString()
              : json.valueAsString<String>('key')),
      weight: json.valueAsInt<int>('weight'),
      type: json.valueTo<HorizonSignersType, Object>(
        key: 'type',
        parse: (e) => HorizonSignersType.fromJson(JsonParser.valueAs(e)),
      ),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'key': key,
    'weight': weight,
    'type': type.toJson(config: config),
    'sponsor': sponsor,
  });
}

class HorizonThresholds {
  final int? lowThreshold;
  final int? medThreshold;
  final int? highThreshold;

  const HorizonThresholds({
    this.lowThreshold,
    this.medThreshold,
    this.highThreshold,
  });

  factory HorizonThresholds.fromJson(Map<String, dynamic> json) {
    return HorizonThresholds(
      lowThreshold: json.valueAsInt<int?>('low_threshold'),
      medThreshold: json.valueAsInt<int?>('med_threshold'),
      highThreshold: json.valueAsInt<int?>('high_threshold'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'low_threshold': lowThreshold,
    'med_threshold': medThreshold,
    'high_threshold': highThreshold,
  });
}

class HorizonTradePrice {
  final String? n;
  final String? d;

  const HorizonTradePrice({this.n, this.d});

  factory HorizonTradePrice.fromJson(Map<String, dynamic> json) {
    return HorizonTradePrice(
      n:
          (json['n'] is num
              ? json['n'].toString()
              : json.valueAsString<String?>('n')),
      d:
          (json['d'] is num
              ? json['d'].toString()
              : json.valueAsString<String?>('d')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'n': n, 'd': d});
}

class HorizonAccountEmbedded {
  final List<HorizonAccountEmbeddedRecordsItem>? records;

  const HorizonAccountEmbedded({this.records});

  factory HorizonAccountEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonAccountEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonAccountEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonAccountEmbeddedRecordsItem {
  final HorizonAccountEmbeddedRecordsItemLinks? links;
  final String id;
  final String accountId;
  final String sequence;
  final int? sequenceLedger;
  final String? sequenceTime;
  final int subentryCount;
  final String? inflationDestination;
  final String? homeDomain;
  final int lastModifiedLedger;
  final String lastModifiedTime;
  final HorizonThresholds thresholds;
  final HorizonFlags flags;
  final List<HorizonAccountEmbeddedRecordsItemBalancesItem> balances;
  final List<HorizonSigners> signers;
  final Map<String, dynamic> data;
  final int numSponsoring;
  final int numSponsored;
  final String? sponsor;
  final String pagingToken;

  const HorizonAccountEmbeddedRecordsItem({
    this.links,
    required this.id,
    required this.accountId,
    required this.sequence,
    this.sequenceLedger,
    this.sequenceTime,
    required this.subentryCount,
    this.inflationDestination,
    this.homeDomain,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
    required this.thresholds,
    required this.flags,
    required this.balances,
    required this.signers,
    required this.data,
    required this.numSponsoring,
    required this.numSponsored,
    this.sponsor,
    required this.pagingToken,
  });

  factory HorizonAccountEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAccountEmbeddedRecordsItem(
      links: json.valueTo<
        HorizonAccountEmbeddedRecordsItemLinks?,
        Map<String, dynamic>
      >(
        key: '_links',
        parse: (v) => HorizonAccountEmbeddedRecordsItemLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      accountId:
          (json['account_id'] is num
              ? json['account_id'].toString()
              : json.valueAsString<String>('account_id')),
      sequence:
          (json['sequence'] is num
              ? json['sequence'].toString()
              : json.valueAsString<String>('sequence')),
      sequenceLedger: json.valueAsInt<int?>('sequence_ledger'),
      sequenceTime:
          (json['sequence_time'] is num
              ? json['sequence_time'].toString()
              : json.valueAsString<String?>('sequence_time')),
      subentryCount: json.valueAsInt<int>('subentry_count'),
      inflationDestination:
          (json['inflation_destination'] is num
              ? json['inflation_destination'].toString()
              : json.valueAsString<String?>('inflation_destination')),
      homeDomain:
          (json['home_domain'] is num
              ? json['home_domain'].toString()
              : json.valueAsString<String?>('home_domain')),
      lastModifiedLedger: json.valueAsInt<int>('last_modified_ledger'),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
      thresholds: json.valueTo<HorizonThresholds, Map<String, dynamic>>(
        key: 'thresholds',
        parse: (v) => HorizonThresholds.fromJson(v),
      ),
      flags: json.valueTo<HorizonFlags, Map<String, dynamic>>(
        key: 'flags',
        parse: (v) => HorizonFlags.fromJson(v),
      ),
      balances:
          json
              .valueEnsureAsList<dynamic>('balances')
              .map(
                (e) =>
                    HorizonAccountEmbeddedRecordsItemBalancesItem.fromJson(e),
              )
              .toList(),
      signers:
          json
              .valueEnsureAsList<Map<String, dynamic>>('signers')
              .map((e) => HorizonSigners.fromJson(e))
              .toList(),
      data: json.valueAsMap<Map<String, dynamic>>('data'),
      numSponsoring: json.valueAsInt<int>('num_sponsoring'),
      numSponsored: json.valueAsInt<int>('num_sponsored'),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'account_id': accountId,
    'sequence': sequence,
    'sequence_ledger': sequenceLedger,
    'sequence_time': sequenceTime,
    'subentry_count': subentryCount,
    'inflation_destination': inflationDestination,
    'home_domain': homeDomain,
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
    'thresholds': thresholds.toJson(config: config),
    'flags': flags.toJson(config: config),
    'balances': balances.map((e) => e.toJson(config: config)).toList(),
    'signers': signers.map((e) => e.toJson(config: config)).toList(),
    'data': data,
    'num_sponsoring': numSponsoring,
    'num_sponsored': numSponsored,
    'sponsor': sponsor,
    'paging_token': pagingToken,
  });
}

class HorizonAccountEmbeddedRecordsItemLinks {
  final HorizonLink self;
  final HorizonLink transactions;
  final HorizonLink operations;
  final HorizonLink payments;
  final HorizonLink effects;
  final HorizonLink offers;
  final HorizonLink trades;
  final HorizonLink data;

  const HorizonAccountEmbeddedRecordsItemLinks({
    required this.self,
    required this.transactions,
    required this.operations,
    required this.payments,
    required this.effects,
    required this.offers,
    required this.trades,
    required this.data,
  });

  factory HorizonAccountEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAccountEmbeddedRecordsItemLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transactions: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'transactions',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operations: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operations',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      payments: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'payments',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      effects: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      offers: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'offers',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      trades: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'trades',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      data: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'data',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'transactions': transactions.toJson(config: config),
    'operations': operations.toJson(config: config),
    'payments': payments.toJson(config: config),
    'effects': effects.toJson(config: config),
    'offers': offers.toJson(config: config),
    'trades': trades.toJson(config: config),
    'data': data.toJson(config: config),
  });
}

class HorizonAccountMergeLinks {
  final HorizonLink self;
  final HorizonLink transaction;
  final HorizonLink effects;
  final HorizonLink succeeds;
  final HorizonLink precedes;

  const HorizonAccountMergeLinks({
    required this.self,
    required this.transaction,
    required this.effects,
    required this.succeeds,
    required this.precedes,
  });

  factory HorizonAccountMergeLinks.fromJson(Map<String, dynamic> json) {
    return HorizonAccountMergeLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transaction: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'transaction',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      effects: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      succeeds: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'succeeds',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      precedes: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'precedes',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'transaction': transaction.toJson(config: config),
    'effects': effects.toJson(config: config),
    'succeeds': succeeds.toJson(config: config),
    'precedes': precedes.toJson(config: config),
  });
}

class HorizonAssetEmbedded {
  final List<HorizonAssetEmbeddedRecordsItem>? records;

  const HorizonAssetEmbedded({this.records});

  factory HorizonAssetEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonAssetEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonAssetEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonAssetEmbeddedRecordsItem {
  final HorizonAssetEmbeddedRecordsItemLinks? links;
  final String? assetType;
  final String? assetCode;
  final String? assetIssuer;
  final String? pagingToken;
  final HorizonAssetEmbeddedRecordsItemAccounts? accounts;
  final int? numClaimableBalances;
  final int? numContracts;
  final int? numLiquidityPools;
  final HorizonAssetEmbeddedRecordsItemBalances? balances;
  final String? claimableBalancesAmount;
  final String? contractsAmount;
  final String? liquidityPoolsAmount;
  final HorizonAssetEmbeddedRecordsItemFlags? flags;

  const HorizonAssetEmbeddedRecordsItem({
    this.links,
    this.assetType,
    this.assetCode,
    this.assetIssuer,
    this.pagingToken,
    this.accounts,
    this.numClaimableBalances,
    this.numContracts,
    this.numLiquidityPools,
    this.balances,
    this.claimableBalancesAmount,
    this.contractsAmount,
    this.liquidityPoolsAmount,
    this.flags,
  });

  factory HorizonAssetEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonAssetEmbeddedRecordsItem(
      links: json
          .valueTo<HorizonAssetEmbeddedRecordsItemLinks?, Map<String, dynamic>>(
            key: '_links',
            parse: (v) => HorizonAssetEmbeddedRecordsItemLinks.fromJson(v),
          ),
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String?>('asset_type')),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      accounts: json.valueTo<
        HorizonAssetEmbeddedRecordsItemAccounts?,
        Map<String, dynamic>
      >(
        key: 'accounts',
        parse: (v) => HorizonAssetEmbeddedRecordsItemAccounts.fromJson(v),
      ),
      numClaimableBalances: json.valueAsInt<int?>('num_claimable_balances'),
      numContracts: json.valueAsInt<int?>('num_contracts'),
      numLiquidityPools: json.valueAsInt<int?>('num_liquidity_pools'),
      balances: json.valueTo<
        HorizonAssetEmbeddedRecordsItemBalances?,
        Map<String, dynamic>
      >(
        key: 'balances',
        parse: (v) => HorizonAssetEmbeddedRecordsItemBalances.fromJson(v),
      ),
      claimableBalancesAmount:
          (json['claimable_balances_amount'] is num
              ? json['claimable_balances_amount'].toString()
              : json.valueAsString<String?>('claimable_balances_amount')),
      contractsAmount:
          (json['contracts_amount'] is num
              ? json['contracts_amount'].toString()
              : json.valueAsString<String?>('contracts_amount')),
      liquidityPoolsAmount:
          (json['liquidity_pools_amount'] is num
              ? json['liquidity_pools_amount'].toString()
              : json.valueAsString<String?>('liquidity_pools_amount')),
      flags: json
          .valueTo<HorizonAssetEmbeddedRecordsItemFlags?, Map<String, dynamic>>(
            key: 'flags',
            parse: (v) => HorizonAssetEmbeddedRecordsItemFlags.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'asset_type': assetType,
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
    'paging_token': pagingToken,
    'accounts': accounts?.toJson(config: config),
    'num_claimable_balances': numClaimableBalances,
    'num_contracts': numContracts,
    'num_liquidity_pools': numLiquidityPools,
    'balances': balances?.toJson(config: config),
    'claimable_balances_amount': claimableBalancesAmount,
    'contracts_amount': contractsAmount,
    'liquidity_pools_amount': liquidityPoolsAmount,
    'flags': flags?.toJson(config: config),
  });
}

class HorizonAssetEmbeddedRecordsItemAccounts {
  final int? authorized;
  final int? authorizedToMaintainLiabilities;
  final int? unauthorized;

  const HorizonAssetEmbeddedRecordsItemAccounts({
    this.authorized,
    this.authorizedToMaintainLiabilities,
    this.unauthorized,
  });

  factory HorizonAssetEmbeddedRecordsItemAccounts.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAssetEmbeddedRecordsItemAccounts(
      authorized: json.valueAsInt<int?>('authorized'),
      authorizedToMaintainLiabilities: json.valueAsInt<int?>(
        'authorized_to_maintain_liabilities',
      ),
      unauthorized: json.valueAsInt<int?>('unauthorized'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'authorized': authorized,
    'authorized_to_maintain_liabilities': authorizedToMaintainLiabilities,
    'unauthorized': unauthorized,
  });
}

class HorizonAssetEmbeddedRecordsItemBalances {
  final String? authorized;
  final String? authorizedToMaintainLiabilities;
  final String? unauthorized;

  const HorizonAssetEmbeddedRecordsItemBalances({
    this.authorized,
    this.authorizedToMaintainLiabilities,
    this.unauthorized,
  });

  factory HorizonAssetEmbeddedRecordsItemBalances.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAssetEmbeddedRecordsItemBalances(
      authorized:
          (json['authorized'] is num
              ? json['authorized'].toString()
              : json.valueAsString<String?>('authorized')),
      authorizedToMaintainLiabilities:
          (json['authorized_to_maintain_liabilities'] is num
              ? json['authorized_to_maintain_liabilities'].toString()
              : json.valueAsString<String?>(
                'authorized_to_maintain_liabilities',
              )),
      unauthorized:
          (json['unauthorized'] is num
              ? json['unauthorized'].toString()
              : json.valueAsString<String?>('unauthorized')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'authorized': authorized,
    'authorized_to_maintain_liabilities': authorizedToMaintainLiabilities,
    'unauthorized': unauthorized,
  });
}

class HorizonAssetEmbeddedRecordsItemFlags {
  final bool? authRequired;
  final bool? authRevocable;
  final bool? authImmutable;

  const HorizonAssetEmbeddedRecordsItemFlags({
    this.authRequired,
    this.authRevocable,
    this.authImmutable,
  });

  factory HorizonAssetEmbeddedRecordsItemFlags.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAssetEmbeddedRecordsItemFlags(
      authRequired: json.valueAsBool<bool?>('auth_required'),
      authRevocable: json.valueAsBool<bool?>('auth_revocable'),
      authImmutable: json.valueAsBool<bool?>('auth_immutable'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'auth_required': authRequired,
    'auth_revocable': authRevocable,
    'auth_immutable': authImmutable,
  });
}

class HorizonAssetEmbeddedRecordsItemLinks {
  final HorizonLink? toml;

  const HorizonAssetEmbeddedRecordsItemLinks({this.toml});

  factory HorizonAssetEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonAssetEmbeddedRecordsItemLinks(
      toml: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'toml',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) =>
      config.encodeMap(<String, dynamic>{'toml': toml?.toJson(config: config)});
}

class HorizonClaimableBalanceClaimantsItem {
  final String? destination;
  final HorizonClaimableBalanceClaimantsItemPredicate? predicate;

  const HorizonClaimableBalanceClaimantsItem({
    this.destination,
    this.predicate,
  });

  factory HorizonClaimableBalanceClaimantsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalanceClaimantsItem(
      destination:
          (json['destination'] is num
              ? json['destination'].toString()
              : json.valueAsString<String?>('destination')),
      predicate: json.valueTo<
        HorizonClaimableBalanceClaimantsItemPredicate?,
        Map<String, dynamic>
      >(
        key: 'predicate',
        parse: (v) => HorizonClaimableBalanceClaimantsItemPredicate.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'destination': destination,
    'predicate': predicate?.toJson(config: config),
  });
}

class HorizonClaimableBalanceClaimantsItemPredicate {
  final List<HorizonClaimableBalanceClaimantsItemPredicateAndItem>? and;

  const HorizonClaimableBalanceClaimantsItemPredicate({this.and});

  factory HorizonClaimableBalanceClaimantsItemPredicate.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalanceClaimantsItemPredicate(
      and:
          json.hasValue('and')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('and')
                  .map(
                    (e) =>
                        HorizonClaimableBalanceClaimantsItemPredicateAndItem.fromJson(
                          e,
                        ),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'and': and?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonClaimableBalanceClaimantsItemPredicateAndItem {
  final List<HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem>? or;
  final HorizonClaimableBalanceClaimantsItemPredicateAndItemNot? not;

  const HorizonClaimableBalanceClaimantsItemPredicateAndItem({
    this.or,
    this.not,
  });

  factory HorizonClaimableBalanceClaimantsItemPredicateAndItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalanceClaimantsItemPredicateAndItem(
      or:
          json.hasValue('or')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('or')
                  .map(
                    (e) =>
                        HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem.fromJson(
                          e,
                        ),
                  )
                  .toList()
              : null,
      not: json.valueTo<
        HorizonClaimableBalanceClaimantsItemPredicateAndItemNot?,
        Map<String, dynamic>
      >(
        key: 'not',
        parse:
            (v) =>
                HorizonClaimableBalanceClaimantsItemPredicateAndItemNot.fromJson(
                  v,
                ),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'or': or?.map((e) => e.toJson(config: config)).toList(),
    'not': not?.toJson(config: config),
  });
}

class HorizonClaimableBalanceClaimantsItemPredicateAndItemNot {
  final bool? unconditional;
  final String? relBefore;
  final String? absBefore;
  final String? absBeforeEpoch;

  const HorizonClaimableBalanceClaimantsItemPredicateAndItemNot({
    this.unconditional,
    this.relBefore,
    this.absBefore,
    this.absBeforeEpoch,
  });

  factory HorizonClaimableBalanceClaimantsItemPredicateAndItemNot.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalanceClaimantsItemPredicateAndItemNot(
      unconditional: json.valueAsBool<bool?>('unconditional'),
      relBefore:
          (json['relBefore'] is num
              ? json['relBefore'].toString()
              : json.valueAsString<String?>('relBefore')),
      absBefore:
          (json['absBefore'] is num
              ? json['absBefore'].toString()
              : json.valueAsString<String?>('absBefore')),
      absBeforeEpoch:
          (json['absBeforeEpoch'] is num
              ? json['absBeforeEpoch'].toString()
              : json.valueAsString<String?>('absBeforeEpoch')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'unconditional': unconditional,
    'relBefore': relBefore,
    'absBefore': absBefore,
    'absBeforeEpoch': absBeforeEpoch,
  });
}

class HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem {
  final String? relBefore;
  final String? absBefore;
  final String? absBeforeEpoch;

  const HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem({
    this.relBefore,
    this.absBefore,
    this.absBeforeEpoch,
  });

  factory HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalanceClaimantsItemPredicateAndItemOrItem(
      relBefore:
          (json['relBefore'] is num
              ? json['relBefore'].toString()
              : json.valueAsString<String?>('relBefore')),
      absBefore:
          (json['absBefore'] is num
              ? json['absBefore'].toString()
              : json.valueAsString<String?>('absBefore')),
      absBeforeEpoch:
          (json['absBeforeEpoch'] is num
              ? json['absBeforeEpoch'].toString()
              : json.valueAsString<String?>('absBeforeEpoch')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'relBefore': relBefore,
    'absBefore': absBefore,
    'absBeforeEpoch': absBeforeEpoch,
  });
}

class HorizonClaimableBalanceLinks {
  final HorizonLink self;
  final HorizonLink operations;
  final HorizonLink transactions;

  const HorizonClaimableBalanceLinks({
    required this.self,
    required this.operations,
    required this.transactions,
  });

  factory HorizonClaimableBalanceLinks.fromJson(Map<String, dynamic> json) {
    return HorizonClaimableBalanceLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operations: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operations',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transactions: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'transactions',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'operations': operations.toJson(config: config),
    'transactions': transactions.toJson(config: config),
  });
}

class HorizonClaimableBalancesEmbedded {
  final List<HorizonClaimableBalancesEmbeddedRecordsItem>? records;

  const HorizonClaimableBalancesEmbedded({this.records});

  factory HorizonClaimableBalancesEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonClaimableBalancesEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map(
                    (e) =>
                        HorizonClaimableBalancesEmbeddedRecordsItem.fromJson(e),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonClaimableBalancesEmbeddedRecordsItem {
  final HorizonClaimableBalanceLinks? links;
  final String id;
  final String pagingToken;
  final String asset;
  final String amount;
  final String? sponsor;
  final String lastModifiedLedger;
  final String lastModifiedTime;
  final List<HorizonClaimableBalanceClaimantsItem>? claimants;
  final HorizonClaimableBalanceFlags? flags;

  const HorizonClaimableBalancesEmbeddedRecordsItem({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.asset,
    required this.amount,
    this.sponsor,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
    this.claimants,
    this.flags,
  });

  factory HorizonClaimableBalancesEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonClaimableBalancesEmbeddedRecordsItem(
      links: json.valueTo<HorizonClaimableBalanceLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonClaimableBalanceLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      asset:
          (json['asset'] is num
              ? json['asset'].toString()
              : json.valueAsString<String>('asset')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
      lastModifiedLedger:
          (json['last_modified_ledger'] is num
              ? json['last_modified_ledger'].toString()
              : json.valueAsString<String>('last_modified_ledger')),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
      claimants:
          json.hasValue('claimants')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('claimants')
                  .map((e) => HorizonClaimableBalanceClaimantsItem.fromJson(e))
                  .toList()
              : null,
      flags: json.valueTo<HorizonClaimableBalanceFlags?, Map<String, dynamic>>(
        key: 'flags',
        parse: (v) => HorizonClaimableBalanceFlags.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'asset': asset,
    'amount': amount,
    'sponsor': sponsor,
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
    'claimants': claimants?.map((e) => e.toJson(config: config)).toList(),
    'flags': flags?.toJson(config: config),
  });
}

class HorizonEffectEmbedded {
  final List<HorizonEffectEmbeddedRecordsItem>? records;

  const HorizonEffectEmbedded({this.records});

  factory HorizonEffectEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonEffectEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonEffectEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonEffectEmbeddedRecordsItem {
  final HorizonEffectEmbeddedRecordsItemLinks? links;
  final String? id;
  final String? pagingToken;
  final String? account;
  final HorizonEffectEmbeddedRecordsItemType? type;
  final num? typeI;
  final String? createdAt;

  const HorizonEffectEmbeddedRecordsItem({
    this.links,
    this.id,
    this.pagingToken,
    this.account,
    this.type,
    this.typeI,
    this.createdAt,
  });

  factory HorizonEffectEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonEffectEmbeddedRecordsItem(
      links: json.valueTo<
        HorizonEffectEmbeddedRecordsItemLinks?,
        Map<String, dynamic>
      >(
        key: '_links',
        parse: (v) => HorizonEffectEmbeddedRecordsItemLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      account:
          (json['account'] is num
              ? json['account'].toString()
              : json.valueAsString<String?>('account')),
      type: json.valueTo<HorizonEffectEmbeddedRecordsItemType?, Object>(
        key: 'type',
        parse:
            (e) => HorizonEffectEmbeddedRecordsItemType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      typeI: json.valueAsNum<num?>('type_i'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String?>('created_at')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'account': account,
    'type': type?.toJson(config: config),
    'type_i': typeI,
    'created_at': createdAt,
  });
}

class HorizonEffectEmbeddedRecordsItemLinks {
  final HorizonLink? operation;
  final HorizonLink? succeeds;
  final HorizonLink? precedes;

  const HorizonEffectEmbeddedRecordsItemLinks({
    this.operation,
    this.succeeds,
    this.precedes,
  });

  factory HorizonEffectEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonEffectEmbeddedRecordsItemLinks(
      operation: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'operation',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      succeeds: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'succeeds',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      precedes: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'precedes',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'operation': operation?.toJson(config: config),
    'succeeds': succeeds?.toJson(config: config),
    'precedes': precedes?.toJson(config: config),
  });
}

/// Information about the fee charged for transactions in the last 5 ledgers.
class HorizonFeeStatsFeeCharged {
  /// Maximum (highest) fee charged over the last 5 ledgers.
  final dynamic max;

  /// Minimum (lowest) fee charged over the last 5 ledgers.
  final dynamic min;

  /// Mode (middle) fee charged over the last 5 ledgers.
  final dynamic mode;

  /// 10th percentile fee charged over the last 5 ledgers.
  final dynamic p10;

  /// 20th percentile fee charged over the last 5 ledgers.
  final dynamic p20;

  /// 30th percentile fee charged over the last 5 ledgers.
  final dynamic p30;

  /// 40th percentile fee charged over the last 5 ledgers.
  final dynamic p40;

  /// 50th percentile fee charged over the last 5 ledgers.
  final dynamic p50;

  /// 60th percentile fee charged over the last 5 ledgers.
  final dynamic p60;

  /// 70th percentile fee charged over the last 5 ledgers.
  final dynamic p70;

  /// 80th percentile fee charged over the last 5 ledgers.
  final dynamic p80;

  /// 90th percentile fee charged over the last 5 ledgers.
  final dynamic p90;

  /// 95th percentile fee charged over the last 5 ledgers.
  final dynamic p95;

  /// 99th percentile fee charged over the last 5 ledgers.
  final dynamic p99;

  const HorizonFeeStatsFeeCharged({
    this.max,
    this.min,
    this.mode,
    this.p10,
    this.p20,
    this.p30,
    this.p40,
    this.p50,
    this.p60,
    this.p70,
    this.p80,
    this.p90,
    this.p95,
    this.p99,
  });

  factory HorizonFeeStatsFeeCharged.fromJson(Map<String, dynamic> json) {
    return HorizonFeeStatsFeeCharged(
      max: json['max'],
      min: json['min'],
      mode: json['mode'],
      p10: json['p10'],
      p20: json['p20'],
      p30: json['p30'],
      p40: json['p40'],
      p50: json['p50'],
      p60: json['p60'],
      p70: json['p70'],
      p80: json['p80'],
      p90: json['p90'],
      p95: json['p95'],
      p99: json['p99'],
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'max': max,
    'min': min,
    'mode': mode,
    'p10': p10,
    'p20': p20,
    'p30': p30,
    'p40': p40,
    'p50': p50,
    'p60': p60,
    'p70': p70,
    'p80': p80,
    'p90': p90,
    'p95': p95,
    'p99': p99,
  });
}

class HorizonLedgerEmbedded {
  final List<HorizonLedgerEmbeddedRecordsItem>? records;

  const HorizonLedgerEmbedded({this.records});

  factory HorizonLedgerEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonLedgerEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonLedgerEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonLedgerEmbeddedRecordsItem {
  final HorizonLedgerEmbeddedRecordsItemLinks? links;
  final String? id;
  final String? pagingToken;
  final String? hash;
  final String? preHash;
  final int? sequence;
  final int? successfulTransactionCount;
  final int? failedTransactionCount;
  final int? operationCount;
  final int? txSetOperationCount;
  final String? closedAt;
  final String? totalCoins;
  final String? feePool;
  final int? baseFeeInStroops;
  final int? baseReserveInStroops;
  final int? maxTxSetSize;
  final int? protocolVersion;
  final String? headerXdr;

  const HorizonLedgerEmbeddedRecordsItem({
    this.links,
    this.id,
    this.pagingToken,
    this.hash,
    this.preHash,
    this.sequence,
    this.successfulTransactionCount,
    this.failedTransactionCount,
    this.operationCount,
    this.txSetOperationCount,
    this.closedAt,
    this.totalCoins,
    this.feePool,
    this.baseFeeInStroops,
    this.baseReserveInStroops,
    this.maxTxSetSize,
    this.protocolVersion,
    this.headerXdr,
  });

  factory HorizonLedgerEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonLedgerEmbeddedRecordsItem(
      links: json.valueTo<
        HorizonLedgerEmbeddedRecordsItemLinks?,
        Map<String, dynamic>
      >(
        key: '_links',
        parse: (v) => HorizonLedgerEmbeddedRecordsItemLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String?>('hash')),
      preHash:
          (json['pre_hash'] is num
              ? json['pre_hash'].toString()
              : json.valueAsString<String?>('pre_hash')),
      sequence: json.valueAsInt<int?>('sequence'),
      successfulTransactionCount: json.valueAsInt<int?>(
        'successful_transaction_count',
      ),
      failedTransactionCount: json.valueAsInt<int?>('failed_transaction_count'),
      operationCount: json.valueAsInt<int?>('operation_count'),
      txSetOperationCount: json.valueAsInt<int?>('tx_set_operation_count'),
      closedAt:
          (json['closed_at'] is num
              ? json['closed_at'].toString()
              : json.valueAsString<String?>('closed_at')),
      totalCoins:
          (json['total_coins'] is num
              ? json['total_coins'].toString()
              : json.valueAsString<String?>('total_coins')),
      feePool:
          (json['fee_pool'] is num
              ? json['fee_pool'].toString()
              : json.valueAsString<String?>('fee_pool')),
      baseFeeInStroops: json.valueAsInt<int?>('base_fee_in_stroops'),
      baseReserveInStroops: json.valueAsInt<int?>('base_reserve_in_stroops'),
      maxTxSetSize: json.valueAsInt<int?>('max_tx_set_size'),
      protocolVersion: json.valueAsInt<int?>('protocol_version'),
      headerXdr:
          (json['header_xdr'] is num
              ? json['header_xdr'].toString()
              : json.valueAsString<String?>('header_xdr')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'hash': hash,
    'pre_hash': preHash,
    'sequence': sequence,
    'successful_transaction_count': successfulTransactionCount,
    'failed_transaction_count': failedTransactionCount,
    'operation_count': operationCount,
    'tx_set_operation_count': txSetOperationCount,
    'closed_at': closedAt,
    'total_coins': totalCoins,
    'fee_pool': feePool,
    'base_fee_in_stroops': baseFeeInStroops,
    'base_reserve_in_stroops': baseReserveInStroops,
    'max_tx_set_size': maxTxSetSize,
    'protocol_version': protocolVersion,
    'header_xdr': headerXdr,
  });
}

class HorizonLedgerEmbeddedRecordsItemLinks {
  final HorizonLink self;
  final HorizonLink transactions;
  final HorizonLink operations;
  final HorizonLink? payments;
  final HorizonLink effects;

  const HorizonLedgerEmbeddedRecordsItemLinks({
    required this.self,
    required this.transactions,
    required this.operations,
    this.payments,
    required this.effects,
  });

  factory HorizonLedgerEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonLedgerEmbeddedRecordsItemLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transactions: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'transactions',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operations: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operations',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      payments: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'payments',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      effects: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'transactions': transactions.toJson(config: config),
    'operations': operations.toJson(config: config),
    'payments': payments?.toJson(config: config),
    'effects': effects.toJson(config: config),
  });
}

class HorizonLinksLinks {
  final HorizonLink? self;
  final HorizonLink? next;
  final HorizonLink? prev;

  const HorizonLinksLinks({this.self, this.next, this.prev});

  factory HorizonLinksLinks.fromJson(Map<String, dynamic> json) {
    return HorizonLinksLinks(
      self: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      next: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'next',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      prev: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'prev',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self?.toJson(config: config),
    'next': next?.toJson(config: config),
    'prev': prev?.toJson(config: config),
  });
}

class HorizonLiquidityPoolReserves {
  final String? asset;
  final String? amount;

  const HorizonLiquidityPoolReserves({this.asset, this.amount});

  factory HorizonLiquidityPoolReserves.fromJson(Map<String, dynamic> json) {
    return HorizonLiquidityPoolReserves(
      asset:
          (json['asset'] is num
              ? json['asset'].toString()
              : json.valueAsString<String?>('asset')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String?>('amount')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'asset': asset, 'amount': amount});
}

class HorizonLiquidityPoolsEmbedded {
  final List<HorizonLiquidityPoolsEmbeddedRecordsItem>? records;

  const HorizonLiquidityPoolsEmbedded({this.records});

  factory HorizonLiquidityPoolsEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonLiquidityPoolsEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map(
                    (e) => HorizonLiquidityPoolsEmbeddedRecordsItem.fromJson(e),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonLiquidityPoolsEmbeddedRecordsItem {
  final String id;
  final String pagingToken;
  final int feeBp;
  final String type;
  final String totalTrustlines;
  final String totalShares;
  final HorizonLiquidityPoolReserves reserves;
  final String lastModifiedLedger;
  final String lastModifiedTime;

  const HorizonLiquidityPoolsEmbeddedRecordsItem({
    required this.id,
    required this.pagingToken,
    required this.feeBp,
    required this.type,
    required this.totalTrustlines,
    required this.totalShares,
    required this.reserves,
    required this.lastModifiedLedger,
    required this.lastModifiedTime,
  });

  factory HorizonLiquidityPoolsEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonLiquidityPoolsEmbeddedRecordsItem(
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      feeBp: json.valueAsInt<int>('fee_bp'),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      totalTrustlines:
          (json['total_trustlines'] is num
              ? json['total_trustlines'].toString()
              : json.valueAsString<String>('total_trustlines')),
      totalShares:
          (json['total_shares'] is num
              ? json['total_shares'].toString()
              : json.valueAsString<String>('total_shares')),
      reserves: json
          .valueTo<HorizonLiquidityPoolReserves, Map<String, dynamic>>(
            key: 'reserves',
            parse: (v) => HorizonLiquidityPoolReserves.fromJson(v),
          ),
      lastModifiedLedger:
          (json['last_modified_ledger'] is num
              ? json['last_modified_ledger'].toString()
              : json.valueAsString<String>('last_modified_ledger')),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'id': id,
    'paging_token': pagingToken,
    'fee_bp': feeBp,
    'type': type,
    'total_trustlines': totalTrustlines,
    'total_shares': totalShares,
    'reserves': reserves.toJson(config: config),
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
  });
}

class HorizonOfferEmbedded {
  final List<HorizonOfferEmbeddedRecordsItem>? records;

  const HorizonOfferEmbedded({this.records});

  factory HorizonOfferEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonOfferEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonOfferEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonOfferEmbeddedRecordsItem {
  final HorizonOfferEmbeddedRecordsItemLinks? links;
  final String id;
  final String pagingToken;
  final String seller;
  final HorizonBaseAsset selling;
  final HorizonBaseAsset buying;
  final String amount;
  final HorizonPrice priceR;
  final String price;
  final int lastModifiedLedger;
  final String lastModifiedTime;
  final String? sponsor;

  const HorizonOfferEmbeddedRecordsItem({
    this.links,
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
    this.sponsor,
  });

  factory HorizonOfferEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonOfferEmbeddedRecordsItem(
      links: json
          .valueTo<HorizonOfferEmbeddedRecordsItemLinks?, Map<String, dynamic>>(
            key: '_links',
            parse: (v) => HorizonOfferEmbeddedRecordsItemLinks.fromJson(v),
          ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      seller:
          (json['seller'] is num
              ? json['seller'].toString()
              : json.valueAsString<String>('seller')),
      selling: json.valueTo<HorizonBaseAsset, Map<String, dynamic>>(
        key: 'selling',
        parse: (v) => HorizonBaseAsset.fromJson(v),
      ),
      buying: json.valueTo<HorizonBaseAsset, Map<String, dynamic>>(
        key: 'buying',
        parse: (v) => HorizonBaseAsset.fromJson(v),
      ),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
      priceR: json.valueTo<HorizonPrice, Map<String, dynamic>>(
        key: 'price_r',
        parse: (v) => HorizonPrice.fromJson(v),
      ),
      price:
          (json['price'] is num
              ? json['price'].toString()
              : json.valueAsString<String>('price')),
      lastModifiedLedger: json.valueAsInt<int>('last_modified_ledger'),
      lastModifiedTime:
          (json['last_modified_time'] is num
              ? json['last_modified_time'].toString()
              : json.valueAsString<String>('last_modified_time')),
      sponsor:
          (json['sponsor'] is num
              ? json['sponsor'].toString()
              : json.valueAsString<String?>('sponsor')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'seller': seller,
    'selling': selling.toJson(config: config),
    'buying': buying.toJson(config: config),
    'amount': amount,
    'price_r': priceR.toJson(config: config),
    'price': price,
    'last_modified_ledger': lastModifiedLedger,
    'last_modified_time': lastModifiedTime,
    'sponsor': sponsor,
  });
}

class HorizonOfferEmbeddedRecordsItemLinks {
  final HorizonLink self;
  final HorizonLink offerMaker;

  const HorizonOfferEmbeddedRecordsItemLinks({
    required this.self,
    required this.offerMaker,
  });

  factory HorizonOfferEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonOfferEmbeddedRecordsItemLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      offerMaker: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'offer_maker',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'offer_maker': offerMaker.toJson(config: config),
  });
}

class HorizonOperationLinks {
  final HorizonLink? effects;
  final HorizonLink? precedes;
  final HorizonLink? self;
  final HorizonLink? succeds;
  final HorizonLink? transaction;

  const HorizonOperationLinks({
    this.effects,
    this.precedes,
    this.self,
    this.succeds,
    this.transaction,
  });

  factory HorizonOperationLinks.fromJson(Map<String, dynamic> json) {
    return HorizonOperationLinks(
      effects: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      precedes: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'precedes',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      self: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      succeds: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'succeds',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transaction: json.valueTo<HorizonLink?, Map<String, dynamic>>(
        key: 'transaction',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'effects': effects?.toJson(config: config),
    'precedes': precedes?.toJson(config: config),
    'self': self?.toJson(config: config),
    'succeds': succeds?.toJson(config: config),
    'transaction': transaction?.toJson(config: config),
  });
}

class HorizonOrderBookBase {
  final String? assetType;

  const HorizonOrderBookBase({this.assetType});

  factory HorizonOrderBookBase.fromJson(Map<String, dynamic> json) {
    return HorizonOrderBookBase(
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String?>('asset_type')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'asset_type': assetType});
}

class HorizonOrderBookBidsItem {
  final HorizonOrderBookBidsItemPriceR? priceR;
  final String? price;
  final String? amount;

  const HorizonOrderBookBidsItem({this.priceR, this.price, this.amount});

  factory HorizonOrderBookBidsItem.fromJson(Map<String, dynamic> json) {
    return HorizonOrderBookBidsItem(
      priceR: json
          .valueTo<HorizonOrderBookBidsItemPriceR?, Map<String, dynamic>>(
            key: 'price_r',
            parse: (v) => HorizonOrderBookBidsItemPriceR.fromJson(v),
          ),
      price:
          (json['price'] is num
              ? json['price'].toString()
              : json.valueAsString<String?>('price')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String?>('amount')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'price_r': priceR?.toJson(config: config),
    'price': price,
    'amount': amount,
  });
}

class HorizonOrderBookBidsItemPriceR {
  final int? n;
  final int? d;

  const HorizonOrderBookBidsItemPriceR({this.n, this.d});

  factory HorizonOrderBookBidsItemPriceR.fromJson(Map<String, dynamic> json) {
    return HorizonOrderBookBidsItemPriceR(
      n: json.valueAsInt<int?>('n'),
      d: json.valueAsInt<int?>('d'),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'n': n, 'd': d});
}

class HorizonOrderBookCounter {
  final String? assetType;
  final String? assetCode;
  final String? assetIssuer;

  const HorizonOrderBookCounter({
    this.assetType,
    this.assetCode,
    this.assetIssuer,
  });

  factory HorizonOrderBookCounter.fromJson(Map<String, dynamic> json) {
    return HorizonOrderBookCounter(
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String?>('asset_type')),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'asset_type': assetType,
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
  });
}

class HorizonPathEmbedded {
  final List<HorizonPathEmbeddedRecordsItem>? records;

  const HorizonPathEmbedded({this.records});

  factory HorizonPathEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonPathEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonPathEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonPathEmbeddedRecordsItem {
  final String? sourceAssetType;
  final String? sourceAssetCode;
  final String? sourceAssetIssuer;
  final String? sourceAmount;
  final String? destinationAssetType;
  final String? destinationAssetCode;
  final String? destinationAssetIssuer;
  final String? destinationAmount;
  final List<HorizonAsset2>? path;

  const HorizonPathEmbeddedRecordsItem({
    this.sourceAssetType,
    this.sourceAssetCode,
    this.sourceAssetIssuer,
    this.sourceAmount,
    this.destinationAssetType,
    this.destinationAssetCode,
    this.destinationAssetIssuer,
    this.destinationAmount,
    this.path,
  });

  factory HorizonPathEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonPathEmbeddedRecordsItem(
      sourceAssetType:
          (json['source_asset_type'] is num
              ? json['source_asset_type'].toString()
              : json.valueAsString<String?>('source_asset_type')),
      sourceAssetCode:
          (json['source_asset_code'] is num
              ? json['source_asset_code'].toString()
              : json.valueAsString<String?>('source_asset_code')),
      sourceAssetIssuer:
          (json['source_asset_issuer'] is num
              ? json['source_asset_issuer'].toString()
              : json.valueAsString<String?>('source_asset_issuer')),
      sourceAmount:
          (json['source_amount'] is num
              ? json['source_amount'].toString()
              : json.valueAsString<String?>('source_amount')),
      destinationAssetType:
          (json['destination_asset_type'] is num
              ? json['destination_asset_type'].toString()
              : json.valueAsString<String?>('destination_asset_type')),
      destinationAssetCode:
          (json['destination_asset_code'] is num
              ? json['destination_asset_code'].toString()
              : json.valueAsString<String?>('destination_asset_code')),
      destinationAssetIssuer:
          (json['destination_asset_issuer'] is num
              ? json['destination_asset_issuer'].toString()
              : json.valueAsString<String?>('destination_asset_issuer')),
      destinationAmount:
          (json['destination_amount'] is num
              ? json['destination_amount'].toString()
              : json.valueAsString<String?>('destination_amount')),
      path:
          json.hasValue('path')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('path')
                  .map((e) => HorizonAsset2.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'source_asset_type': sourceAssetType,
    'source_asset_code': sourceAssetCode,
    'source_asset_issuer': sourceAssetIssuer,
    'source_amount': sourceAmount,
    'destination_asset_type': destinationAssetType,
    'destination_asset_code': destinationAssetCode,
    'destination_asset_issuer': destinationAssetIssuer,
    'destination_amount': destinationAmount,
    'path': path?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonPathPaymentStrictReceivePathItem {
  final HorizonBalanceLineAssetAssetType? assetType;
  final String? assetCode;
  final String? assetIssuer;

  const HorizonPathPaymentStrictReceivePathItem({
    this.assetType,
    this.assetCode,
    this.assetIssuer,
  });

  factory HorizonPathPaymentStrictReceivePathItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonPathPaymentStrictReceivePathItem(
      assetType: json.valueTo<HorizonBalanceLineAssetAssetType?, Object>(
        key: 'asset_type',
        parse:
            (e) => HorizonBalanceLineAssetAssetType.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetCode:
          (json['asset_code'] is num
              ? json['asset_code'].toString()
              : json.valueAsString<String?>('asset_code')),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'asset_type': assetType?.toJson(config: config),
    'asset_code': assetCode,
    'asset_issuer': assetIssuer,
  });
}

class HorizonPaymentEmbedded {
  final List<HorizonPaymentEmbeddedRecordsItem>? records;

  const HorizonPaymentEmbedded({this.records});

  factory HorizonPaymentEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonPaymentEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonPaymentEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonPaymentEmbeddedRecordsItem {
  final HorizonAccountMergeLinks? links;
  final String id;
  final String pagingToken;
  final bool transactionSuccessful;
  final String sourceAccount;
  final String type;
  final String typeI;
  final String createdAt;
  final String transactionHash;
  final String assetType;
  final HorizonAssetBalanceChangeAssetCode? assetCode;
  final String? assetIssuer;
  final String from;
  final String to;
  final String amount;

  const HorizonPaymentEmbeddedRecordsItem({
    this.links,
    required this.id,
    required this.pagingToken,
    required this.transactionSuccessful,
    required this.sourceAccount,
    required this.type,
    required this.typeI,
    required this.createdAt,
    required this.transactionHash,
    required this.assetType,
    this.assetCode,
    this.assetIssuer,
    required this.from,
    required this.to,
    required this.amount,
  });

  factory HorizonPaymentEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonPaymentEmbeddedRecordsItem(
      links: json.valueTo<HorizonAccountMergeLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonAccountMergeLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      transactionSuccessful: json.valueAsBool<bool>('transaction_successful'),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String>('type')),
      typeI:
          (json['type_i'] is num
              ? json['type_i'].toString()
              : json.valueAsString<String>('type_i')),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      transactionHash:
          (json['transaction_hash'] is num
              ? json['transaction_hash'].toString()
              : json.valueAsString<String>('transaction_hash')),
      assetType:
          (json['asset_type'] is num
              ? json['asset_type'].toString()
              : json.valueAsString<String>('asset_type')),
      assetCode: json.valueTo<HorizonAssetBalanceChangeAssetCode?, Object>(
        key: 'asset_code',
        parse:
            (e) => HorizonAssetBalanceChangeAssetCode.fromJson(
              JsonParser.valueAs(e),
            ),
      ),
      assetIssuer:
          (json['asset_issuer'] is num
              ? json['asset_issuer'].toString()
              : json.valueAsString<String?>('asset_issuer')),
      from:
          (json['from'] is num
              ? json['from'].toString()
              : json.valueAsString<String>('from')),
      to:
          (json['to'] is num
              ? json['to'].toString()
              : json.valueAsString<String>('to')),
      amount:
          (json['amount'] is num
              ? json['amount'].toString()
              : json.valueAsString<String>('amount')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'transaction_successful': transactionSuccessful,
    'source_account': sourceAccount,
    'type': type,
    'type_i': typeI,
    'created_at': createdAt,
    'transaction_hash': transactionHash,
    'asset_type': assetType,
    'asset_code': assetCode?.toJson(config: config),
    'asset_issuer': assetIssuer,
    'from': from,
    'to': to,
    'amount': amount,
  });
}

class HorizonResponseGetDataByAccountId {
  final String? value;

  const HorizonResponseGetDataByAccountId({this.value});

  factory HorizonResponseGetDataByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetDataByAccountId(
      value:
          (json['value'] is num
              ? json['value'].toString()
              : json.valueAsString<String?>('value')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{'value': value});
}

class HorizonResponseGetOffersByAccountId {
  final HorizonLinksLinks? links;
  final HorizonOfferEmbedded? embedded;

  const HorizonResponseGetOffersByAccountId({this.links, this.embedded});

  factory HorizonResponseGetOffersByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetOffersByAccountId(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonOfferEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonOfferEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseGetOperationsByAccountId {
  final HorizonLinksLinks? links;

  const HorizonResponseGetOperationsByAccountId({this.links});

  factory HorizonResponseGetOperationsByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetOperationsByAccountId(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
  });
}

class HorizonResponseGetPaymentsByAccountId {
  final HorizonLinksLinks? links;
  final HorizonPaymentEmbedded? embedded;

  const HorizonResponseGetPaymentsByAccountId({this.links, this.embedded});

  factory HorizonResponseGetPaymentsByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetPaymentsByAccountId(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonPaymentEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonPaymentEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseGetTradesByAccountId {
  final HorizonLinksLinks? links;
  final HorizonTradeEmbedded? embedded;

  const HorizonResponseGetTradesByAccountId({this.links, this.embedded});

  factory HorizonResponseGetTradesByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetTradesByAccountId(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonTradeEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonTradeEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseGetTransactionsByAccountId {
  final HorizonLinksLinks? links;
  final HorizonTransactionEmbedded? embedded;

  const HorizonResponseGetTransactionsByAccountId({this.links, this.embedded});

  factory HorizonResponseGetTransactionsByAccountId.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseGetTransactionsByAccountId(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonTransactionEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonTransactionEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseLPRetrieveRelatedOperations {
  final HorizonOperationLinks? links;
  final String? id;
  final String? pagingToken;
  final num? typeI;
  final String? type;

  const HorizonResponseLPRetrieveRelatedOperations({
    this.links,
    this.id,
    this.pagingToken,
    this.typeI,
    this.type,
  });

  factory HorizonResponseLPRetrieveRelatedOperations.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseLPRetrieveRelatedOperations(
      links: json.valueTo<HorizonOperationLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonOperationLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      typeI: json.valueAsNum<num?>('type_i'),
      type:
          (json['type'] is num
              ? json['type'].toString()
              : json.valueAsString<String?>('type')),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'type_i': typeI,
    'type': type,
  });
}

class HorizonResponseListAllAccounts {
  final HorizonLinksLinks? links;
  final HorizonAccountEmbedded? embedded;

  const HorizonResponseListAllAccounts({this.links, this.embedded});

  factory HorizonResponseListAllAccounts.fromJson(Map<String, dynamic> json) {
    return HorizonResponseListAllAccounts(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonAccountEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonAccountEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseListAllAssets {
  final HorizonLinksLinks? links;
  final HorizonAssetEmbedded? embedded;

  const HorizonResponseListAllAssets({this.links, this.embedded});

  factory HorizonResponseListAllAssets.fromJson(Map<String, dynamic> json) {
    return HorizonResponseListAllAssets(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonAssetEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonAssetEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseListAllClaimableBalances {
  final HorizonLinksLinks? links;
  final HorizonClaimableBalancesEmbedded? embedded;

  const HorizonResponseListAllClaimableBalances({this.links, this.embedded});

  factory HorizonResponseListAllClaimableBalances.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseListAllClaimableBalances(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json
          .valueTo<HorizonClaimableBalancesEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonClaimableBalancesEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseListAllEffects {
  final HorizonLinksLinks? links;
  final HorizonEffectEmbedded? embedded;

  const HorizonResponseListAllEffects({this.links, this.embedded});

  factory HorizonResponseListAllEffects.fromJson(Map<String, dynamic> json) {
    return HorizonResponseListAllEffects(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json.valueTo<HorizonEffectEmbedded?, Map<String, dynamic>>(
        key: '_embedded',
        parse: (v) => HorizonEffectEmbedded.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonResponseListAllPayments {
  final HorizonLinksLinks? links;

  const HorizonResponseListAllPayments({this.links});

  factory HorizonResponseListAllPayments.fromJson(Map<String, dynamic> json) {
    return HorizonResponseListAllPayments(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
  });
}

class HorizonResponseListLiquidityPools {
  final HorizonLinksLinks? links;
  final HorizonLiquidityPoolsEmbedded? embedded;

  const HorizonResponseListLiquidityPools({this.links, this.embedded});

  factory HorizonResponseListLiquidityPools.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonResponseListLiquidityPools(
      links: json.valueTo<HorizonLinksLinks?, Map<String, dynamic>>(
        key: '_links',
        parse: (v) => HorizonLinksLinks.fromJson(v),
      ),
      embedded: json
          .valueTo<HorizonLiquidityPoolsEmbedded?, Map<String, dynamic>>(
            key: '_embedded',
            parse: (v) => HorizonLiquidityPoolsEmbedded.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    '_embedded': embedded?.toJson(config: config),
  });
}

class HorizonSubmitTransactionEmbedded {
  final List<HorizonSubmitTransactionEmbeddedRecordsItem>? records;

  const HorizonSubmitTransactionEmbedded({this.records});

  factory HorizonSubmitTransactionEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonSubmitTransactionEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map(
                    (e) =>
                        HorizonSubmitTransactionEmbeddedRecordsItem.fromJson(e),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonSubmitTransactionEmbeddedRecordsItem {
  final String? memo;
  final String? memoBytes;
  final HorizonSubmitTransactionEmbeddedRecordsItemLinks? links;
  final String id;
  final String pagingToken;
  final bool successful;
  final String hash;
  final int ledger;
  final String createdAt;
  final String sourceAccount;
  final String? accountMuxed;
  final String? accountMuxedId;
  final String sourceAccountSequence;
  final String feeAccount;
  final String? feeAccountMuxed;
  final String? feeAccountMuxedId;
  final String feeCharged;
  final String maxFee;
  final int operationCount;
  final String envelopeXdr;
  final String resultXdr;
  final String? resultMetaXdr;
  final String? feeMetaXdr;
  final String memoType;
  final HorizonSignatures signatures;
  final HorizonTransactionPreconditions? preconditions;
  final HorizonFeeBumpTransaction? feeBumpTransaction;
  final HorizonInnerTransaction? innerTransaction;

  const HorizonSubmitTransactionEmbeddedRecordsItem({
    this.memo,
    this.memoBytes,
    this.links,
    required this.id,
    required this.pagingToken,
    required this.successful,
    required this.hash,
    required this.ledger,
    required this.createdAt,
    required this.sourceAccount,
    this.accountMuxed,
    this.accountMuxedId,
    required this.sourceAccountSequence,
    required this.feeAccount,
    this.feeAccountMuxed,
    this.feeAccountMuxedId,
    required this.feeCharged,
    required this.maxFee,
    required this.operationCount,
    required this.envelopeXdr,
    required this.resultXdr,
    this.resultMetaXdr,
    this.feeMetaXdr,
    required this.memoType,
    required this.signatures,
    this.preconditions,
    this.feeBumpTransaction,
    this.innerTransaction,
  });

  factory HorizonSubmitTransactionEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonSubmitTransactionEmbeddedRecordsItem(
      memo:
          (json['memo'] is num
              ? json['memo'].toString()
              : json.valueAsString<String?>('memo')),
      memoBytes:
          (json['memo_bytes'] is num
              ? json['memo_bytes'].toString()
              : json.valueAsString<String?>('memo_bytes')),
      links: json.valueTo<
        HorizonSubmitTransactionEmbeddedRecordsItemLinks?,
        Map<String, dynamic>
      >(
        key: '_links',
        parse:
            (v) => HorizonSubmitTransactionEmbeddedRecordsItemLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      successful: json.valueAsBool<bool>('successful'),
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String>('hash')),
      ledger: json.valueAsInt<int>('ledger'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      accountMuxed:
          (json['account_muxed'] is num
              ? json['account_muxed'].toString()
              : json.valueAsString<String?>('account_muxed')),
      accountMuxedId:
          (json['account_muxed_id'] is num
              ? json['account_muxed_id'].toString()
              : json.valueAsString<String?>('account_muxed_id')),
      sourceAccountSequence:
          (json['source_account_sequence'] is num
              ? json['source_account_sequence'].toString()
              : json.valueAsString<String>('source_account_sequence')),
      feeAccount:
          (json['fee_account'] is num
              ? json['fee_account'].toString()
              : json.valueAsString<String>('fee_account')),
      feeAccountMuxed:
          (json['fee_account_muxed'] is num
              ? json['fee_account_muxed'].toString()
              : json.valueAsString<String?>('fee_account_muxed')),
      feeAccountMuxedId:
          (json['fee_account_muxed_id'] is num
              ? json['fee_account_muxed_id'].toString()
              : json.valueAsString<String?>('fee_account_muxed_id')),
      feeCharged:
          (json['fee_charged'] is num
              ? json['fee_charged'].toString()
              : json.valueAsString<String>('fee_charged')),
      maxFee:
          (json['max_fee'] is num
              ? json['max_fee'].toString()
              : json.valueAsString<String>('max_fee')),
      operationCount: json.valueAsInt<int>('operation_count'),
      envelopeXdr:
          (json['envelope_xdr'] is num
              ? json['envelope_xdr'].toString()
              : json.valueAsString<String>('envelope_xdr')),
      resultXdr:
          (json['result_xdr'] is num
              ? json['result_xdr'].toString()
              : json.valueAsString<String>('result_xdr')),
      resultMetaXdr:
          (json['result_meta_xdr'] is num
              ? json['result_meta_xdr'].toString()
              : json.valueAsString<String?>('result_meta_xdr')),
      feeMetaXdr:
          (json['fee_meta_xdr'] is num
              ? json['fee_meta_xdr'].toString()
              : json.valueAsString<String?>('fee_meta_xdr')),
      memoType:
          (json['memo_type'] is num
              ? json['memo_type'].toString()
              : json.valueAsString<String>('memo_type')),
      signatures: json.valueAsList<List<String>>('signatures'),
      preconditions: json
          .valueTo<HorizonTransactionPreconditions?, Map<String, dynamic>>(
            key: 'preconditions',
            parse: (v) => HorizonTransactionPreconditions.fromJson(v),
          ),
      feeBumpTransaction: json
          .valueTo<HorizonFeeBumpTransaction?, Map<String, dynamic>>(
            key: 'fee_bump_transaction',
            parse: (v) => HorizonFeeBumpTransaction.fromJson(v),
          ),
      innerTransaction: json
          .valueTo<HorizonInnerTransaction?, Map<String, dynamic>>(
            key: 'inner_transaction',
            parse: (v) => HorizonInnerTransaction.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'memo': memo,
    'memo_bytes': memoBytes,
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'successful': successful,
    'hash': hash,
    'ledger': ledger,
    'created_at': createdAt,
    'source_account': sourceAccount,
    'account_muxed': accountMuxed,
    'account_muxed_id': accountMuxedId,
    'source_account_sequence': sourceAccountSequence,
    'fee_account': feeAccount,
    'fee_account_muxed': feeAccountMuxed,
    'fee_account_muxed_id': feeAccountMuxedId,
    'fee_charged': feeCharged,
    'max_fee': maxFee,
    'operation_count': operationCount,
    'envelope_xdr': envelopeXdr,
    'result_xdr': resultXdr,
    'result_meta_xdr': resultMetaXdr,
    'fee_meta_xdr': feeMetaXdr,
    'memo_type': memoType,
    'signatures': signatures,
    'preconditions': preconditions?.toJson(config: config),
    'fee_bump_transaction': feeBumpTransaction?.toJson(config: config),
    'inner_transaction': innerTransaction?.toJson(config: config),
  });
}

class HorizonSubmitTransactionEmbeddedRecordsItemLinks {
  final HorizonLink self;
  final HorizonLink account;
  final HorizonLink ledger;
  final HorizonLink operations;
  final HorizonLink effects;
  final HorizonLink precedes;
  final HorizonLink succeeds;
  final HorizonLink transaction;

  const HorizonSubmitTransactionEmbeddedRecordsItemLinks({
    required this.self,
    required this.account,
    required this.ledger,
    required this.operations,
    required this.effects,
    required this.precedes,
    required this.succeeds,
    required this.transaction,
  });

  factory HorizonSubmitTransactionEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonSubmitTransactionEmbeddedRecordsItemLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      account: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'account',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      ledger: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'ledger',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operations: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operations',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      effects: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      precedes: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'precedes',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      succeeds: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'succeeds',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      transaction: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'transaction',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'account': account.toJson(config: config),
    'ledger': ledger.toJson(config: config),
    'operations': operations.toJson(config: config),
    'effects': effects.toJson(config: config),
    'precedes': precedes.toJson(config: config),
    'succeeds': succeeds.toJson(config: config),
    'transaction': transaction.toJson(config: config),
  });
}

class HorizonTradeAggregationEmbedded {
  final List<HorizonTradeAggregationEmbeddedRecordsItem>? records;

  const HorizonTradeAggregationEmbedded({this.records});

  factory HorizonTradeAggregationEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonTradeAggregationEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map(
                    (e) =>
                        HorizonTradeAggregationEmbeddedRecordsItem.fromJson(e),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonTradeAggregationEmbeddedRecordsItem {
  final String? timestamp;
  final String? tradeCount;
  final String? baseVolume;
  final String? counterVolume;
  final String? avg;
  final String? high;
  final HorizonTradePrice? highR;
  final String? low;
  final HorizonTradePrice? lowR;
  final String? open;
  final HorizonTradePrice? openR;
  final String? close;
  final HorizonTradePrice? closeR;

  const HorizonTradeAggregationEmbeddedRecordsItem({
    this.timestamp,
    this.tradeCount,
    this.baseVolume,
    this.counterVolume,
    this.avg,
    this.high,
    this.highR,
    this.low,
    this.lowR,
    this.open,
    this.openR,
    this.close,
    this.closeR,
  });

  factory HorizonTradeAggregationEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonTradeAggregationEmbeddedRecordsItem(
      timestamp:
          (json['timestamp'] is num
              ? json['timestamp'].toString()
              : json.valueAsString<String?>('timestamp')),
      tradeCount:
          (json['trade_count'] is num
              ? json['trade_count'].toString()
              : json.valueAsString<String?>('trade_count')),
      baseVolume:
          (json['base_volume'] is num
              ? json['base_volume'].toString()
              : json.valueAsString<String?>('base_volume')),
      counterVolume:
          (json['counter_volume'] is num
              ? json['counter_volume'].toString()
              : json.valueAsString<String?>('counter_volume')),
      avg:
          (json['avg'] is num
              ? json['avg'].toString()
              : json.valueAsString<String?>('avg')),
      high:
          (json['high'] is num
              ? json['high'].toString()
              : json.valueAsString<String?>('high')),
      highR: json.valueTo<HorizonTradePrice?, Map<String, dynamic>>(
        key: 'high_r',
        parse: (v) => HorizonTradePrice.fromJson(v),
      ),
      low:
          (json['low'] is num
              ? json['low'].toString()
              : json.valueAsString<String?>('low')),
      lowR: json.valueTo<HorizonTradePrice?, Map<String, dynamic>>(
        key: 'low_r',
        parse: (v) => HorizonTradePrice.fromJson(v),
      ),
      open:
          (json['open'] is num
              ? json['open'].toString()
              : json.valueAsString<String?>('open')),
      openR: json.valueTo<HorizonTradePrice?, Map<String, dynamic>>(
        key: 'open_r',
        parse: (v) => HorizonTradePrice.fromJson(v),
      ),
      close:
          (json['close'] is num
              ? json['close'].toString()
              : json.valueAsString<String?>('close')),
      closeR: json.valueTo<HorizonTradePrice?, Map<String, dynamic>>(
        key: 'close_r',
        parse: (v) => HorizonTradePrice.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'timestamp': timestamp,
    'trade_count': tradeCount,
    'base_volume': baseVolume,
    'counter_volume': counterVolume,
    'avg': avg,
    'high': high,
    'high_r': highR?.toJson(config: config),
    'low': low,
    'low_r': lowR?.toJson(config: config),
    'open': open,
    'open_r': openR?.toJson(config: config),
    'close': close,
    'close_r': closeR?.toJson(config: config),
  });
}

class HorizonTradeEmbedded {
  final List<HorizonTradeEmbeddedRecordsItem>? records;

  const HorizonTradeEmbedded({this.records});

  factory HorizonTradeEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonTradeEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonTradeEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonTradeEmbeddedRecordsItem {
  final HorizonTradeEmbeddedRecordsItemLinks? links;
  final String? id;
  final String? pagingToken;
  final String? ledgerCloseTime;
  final String? offerId;
  final String? tradeType;
  final num? liquidityPoolFeeBp;
  final String? baseLiquidityPoolId;
  final String? baseOfferId;
  final String? baseAccount;
  final String? baseAmount;
  final String? baseAssetType;
  final String? baseAssetCode;
  final String? baseAssetIssuer;
  final String? counterLiquidityPoolId;
  final String? counterOfferId;
  final String? counterAccount;
  final String? counterAmount;
  final String? counterAssetType;
  final String? counterAssetCode;
  final String? counterAssetIssuer;
  final bool? baseIsSeller;
  final HorizonTradePrice? price;

  const HorizonTradeEmbeddedRecordsItem({
    this.links,
    this.id,
    this.pagingToken,
    this.ledgerCloseTime,
    this.offerId,
    this.tradeType,
    this.liquidityPoolFeeBp,
    this.baseLiquidityPoolId,
    this.baseOfferId,
    this.baseAccount,
    this.baseAmount,
    this.baseAssetType,
    this.baseAssetCode,
    this.baseAssetIssuer,
    this.counterLiquidityPoolId,
    this.counterOfferId,
    this.counterAccount,
    this.counterAmount,
    this.counterAssetType,
    this.counterAssetCode,
    this.counterAssetIssuer,
    this.baseIsSeller,
    this.price,
  });

  factory HorizonTradeEmbeddedRecordsItem.fromJson(Map<String, dynamic> json) {
    return HorizonTradeEmbeddedRecordsItem(
      links: json
          .valueTo<HorizonTradeEmbeddedRecordsItemLinks?, Map<String, dynamic>>(
            key: '_links',
            parse: (v) => HorizonTradeEmbeddedRecordsItemLinks.fromJson(v),
          ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String?>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String?>('paging_token')),
      ledgerCloseTime:
          (json['ledger_close_time'] is num
              ? json['ledger_close_time'].toString()
              : json.valueAsString<String?>('ledger_close_time')),
      offerId:
          (json['offer_id'] is num
              ? json['offer_id'].toString()
              : json.valueAsString<String?>('offer_id')),
      tradeType:
          (json['trade_type'] is num
              ? json['trade_type'].toString()
              : json.valueAsString<String?>('trade_type')),
      liquidityPoolFeeBp: json.valueAsNum<num?>('liquidity_pool_fee_bp'),
      baseLiquidityPoolId:
          (json['base_liquidity_pool_id'] is num
              ? json['base_liquidity_pool_id'].toString()
              : json.valueAsString<String?>('base_liquidity_pool_id')),
      baseOfferId:
          (json['base_offer_id'] is num
              ? json['base_offer_id'].toString()
              : json.valueAsString<String?>('base_offer_id')),
      baseAccount:
          (json['base_account'] is num
              ? json['base_account'].toString()
              : json.valueAsString<String?>('base_account')),
      baseAmount:
          (json['base_amount'] is num
              ? json['base_amount'].toString()
              : json.valueAsString<String?>('base_amount')),
      baseAssetType:
          (json['base_asset_type'] is num
              ? json['base_asset_type'].toString()
              : json.valueAsString<String?>('base_asset_type')),
      baseAssetCode:
          (json['base_asset_code'] is num
              ? json['base_asset_code'].toString()
              : json.valueAsString<String?>('base_asset_code')),
      baseAssetIssuer:
          (json['base_asset_issuer'] is num
              ? json['base_asset_issuer'].toString()
              : json.valueAsString<String?>('base_asset_issuer')),
      counterLiquidityPoolId:
          (json['counter_liquidity_pool_id'] is num
              ? json['counter_liquidity_pool_id'].toString()
              : json.valueAsString<String?>('counter_liquidity_pool_id')),
      counterOfferId:
          (json['counter_offer_id'] is num
              ? json['counter_offer_id'].toString()
              : json.valueAsString<String?>('counter_offer_id')),
      counterAccount:
          (json['counter_account'] is num
              ? json['counter_account'].toString()
              : json.valueAsString<String?>('counter_account')),
      counterAmount:
          (json['counter_amount'] is num
              ? json['counter_amount'].toString()
              : json.valueAsString<String?>('counter_amount')),
      counterAssetType:
          (json['counter_asset_type'] is num
              ? json['counter_asset_type'].toString()
              : json.valueAsString<String?>('counter_asset_type')),
      counterAssetCode:
          (json['counter_asset_code'] is num
              ? json['counter_asset_code'].toString()
              : json.valueAsString<String?>('counter_asset_code')),
      counterAssetIssuer:
          (json['counter_asset_issuer'] is num
              ? json['counter_asset_issuer'].toString()
              : json.valueAsString<String?>('counter_asset_issuer')),
      baseIsSeller: json.valueAsBool<bool?>('base_is_seller'),
      price: json.valueTo<HorizonTradePrice?, Map<String, dynamic>>(
        key: 'price',
        parse: (v) => HorizonTradePrice.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'ledger_close_time': ledgerCloseTime,
    'offer_id': offerId,
    'trade_type': tradeType,
    'liquidity_pool_fee_bp': liquidityPoolFeeBp,
    'base_liquidity_pool_id': baseLiquidityPoolId,
    'base_offer_id': baseOfferId,
    'base_account': baseAccount,
    'base_amount': baseAmount,
    'base_asset_type': baseAssetType,
    'base_asset_code': baseAssetCode,
    'base_asset_issuer': baseAssetIssuer,
    'counter_liquidity_pool_id': counterLiquidityPoolId,
    'counter_offer_id': counterOfferId,
    'counter_account': counterAccount,
    'counter_amount': counterAmount,
    'counter_asset_type': counterAssetType,
    'counter_asset_code': counterAssetCode,
    'counter_asset_issuer': counterAssetIssuer,
    'base_is_seller': baseIsSeller,
    'price': price?.toJson(config: config),
  });
}

class HorizonTradeEmbeddedRecordsItemLinks {
  final HorizonLink self;
  final HorizonLink base_;
  final HorizonLink counter;
  final HorizonLink operation;

  const HorizonTradeEmbeddedRecordsItemLinks({
    required this.self,
    required this.base_,
    required this.counter,
    required this.operation,
  });

  factory HorizonTradeEmbeddedRecordsItemLinks.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonTradeEmbeddedRecordsItemLinks(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      base_: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'base',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      counter: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'counter',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operation: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operation',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'base': base_.toJson(config: config),
    'counter': counter.toJson(config: config),
    'operation': operation.toJson(config: config),
  });
}

class HorizonTransaction2Links {
  final HorizonLink self;
  final HorizonLink account;
  final HorizonLink ledger;
  final HorizonLink operations;
  final HorizonLink effects;
  final HorizonLink precedes;
  final HorizonLink succeeds;

  const HorizonTransaction2Links({
    required this.self,
    required this.account,
    required this.ledger,
    required this.operations,
    required this.effects,
    required this.precedes,
    required this.succeeds,
  });

  factory HorizonTransaction2Links.fromJson(Map<String, dynamic> json) {
    return HorizonTransaction2Links(
      self: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'self',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      account: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'account',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      ledger: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'ledger',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      operations: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'operations',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      effects: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'effects',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      precedes: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'precedes',
        parse: (v) => HorizonLink.fromJson(v),
      ),
      succeeds: json.valueTo<HorizonLink, Map<String, dynamic>>(
        key: 'succeeds',
        parse: (v) => HorizonLink.fromJson(v),
      ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'self': self.toJson(config: config),
    'account': account.toJson(config: config),
    'ledger': ledger.toJson(config: config),
    'operations': operations.toJson(config: config),
    'effects': effects.toJson(config: config),
    'precedes': precedes.toJson(config: config),
    'succeeds': succeeds.toJson(config: config),
  });
}

class HorizonTransactionEmbedded {
  final List<HorizonTransactionEmbeddedRecordsItem>? records;

  const HorizonTransactionEmbedded({this.records});

  factory HorizonTransactionEmbedded.fromJson(Map<String, dynamic> json) {
    return HorizonTransactionEmbedded(
      records:
          json.hasValue('records')
              ? json
                  .valueEnsureAsList<Map<String, dynamic>>('records')
                  .map((e) => HorizonTransactionEmbeddedRecordsItem.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'records': records?.map((e) => e.toJson(config: config)).toList(),
  });
}

class HorizonTransactionEmbeddedRecordsItem {
  final String? memo;
  final HorizonSubmitTransactionEmbeddedRecordsItemLinks? links;
  final String id;
  final String pagingToken;
  final bool successful;
  final String hash;
  final int ledger;
  final String createdAt;
  final String sourceAccount;
  final String? accountMuxed;
  final String? accountMuxedId;
  final String sourceAccountSequence;
  final String feeAccount;
  final String? feeAccountMuxed;
  final String? feeAccountMuxedId;
  final String feeCharged;
  final String maxFee;
  final int operationCount;
  final String envelopeXdr;
  final String resultXdr;
  final String? resultMetaXdr;
  final String? feeMetaXdr;
  final String memoType;
  final HorizonSignatures signatures;
  final HorizonTransactionPreconditions? preconditions;
  final HorizonFeeBumpTransaction? feeBumpTransaction;
  final HorizonInnerTransaction? innerTransaction;

  const HorizonTransactionEmbeddedRecordsItem({
    this.memo,
    this.links,
    required this.id,
    required this.pagingToken,
    required this.successful,
    required this.hash,
    required this.ledger,
    required this.createdAt,
    required this.sourceAccount,
    this.accountMuxed,
    this.accountMuxedId,
    required this.sourceAccountSequence,
    required this.feeAccount,
    this.feeAccountMuxed,
    this.feeAccountMuxedId,
    required this.feeCharged,
    required this.maxFee,
    required this.operationCount,
    required this.envelopeXdr,
    required this.resultXdr,
    this.resultMetaXdr,
    this.feeMetaXdr,
    required this.memoType,
    required this.signatures,
    this.preconditions,
    this.feeBumpTransaction,
    this.innerTransaction,
  });

  factory HorizonTransactionEmbeddedRecordsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return HorizonTransactionEmbeddedRecordsItem(
      memo:
          (json['memo'] is num
              ? json['memo'].toString()
              : json.valueAsString<String?>('memo')),
      links: json.valueTo<
        HorizonSubmitTransactionEmbeddedRecordsItemLinks?,
        Map<String, dynamic>
      >(
        key: '_links',
        parse:
            (v) => HorizonSubmitTransactionEmbeddedRecordsItemLinks.fromJson(v),
      ),
      id:
          (json['id'] is num
              ? json['id'].toString()
              : json.valueAsString<String>('id')),
      pagingToken:
          (json['paging_token'] is num
              ? json['paging_token'].toString()
              : json.valueAsString<String>('paging_token')),
      successful: json.valueAsBool<bool>('successful'),
      hash:
          (json['hash'] is num
              ? json['hash'].toString()
              : json.valueAsString<String>('hash')),
      ledger: json.valueAsInt<int>('ledger'),
      createdAt:
          (json['created_at'] is num
              ? json['created_at'].toString()
              : json.valueAsString<String>('created_at')),
      sourceAccount:
          (json['source_account'] is num
              ? json['source_account'].toString()
              : json.valueAsString<String>('source_account')),
      accountMuxed:
          (json['account_muxed'] is num
              ? json['account_muxed'].toString()
              : json.valueAsString<String?>('account_muxed')),
      accountMuxedId:
          (json['account_muxed_id'] is num
              ? json['account_muxed_id'].toString()
              : json.valueAsString<String?>('account_muxed_id')),
      sourceAccountSequence:
          (json['source_account_sequence'] is num
              ? json['source_account_sequence'].toString()
              : json.valueAsString<String>('source_account_sequence')),
      feeAccount:
          (json['fee_account'] is num
              ? json['fee_account'].toString()
              : json.valueAsString<String>('fee_account')),
      feeAccountMuxed:
          (json['fee_account_muxed'] is num
              ? json['fee_account_muxed'].toString()
              : json.valueAsString<String?>('fee_account_muxed')),
      feeAccountMuxedId:
          (json['fee_account_muxed_id'] is num
              ? json['fee_account_muxed_id'].toString()
              : json.valueAsString<String?>('fee_account_muxed_id')),
      feeCharged:
          (json['fee_charged'] is num
              ? json['fee_charged'].toString()
              : json.valueAsString<String>('fee_charged')),
      maxFee:
          (json['max_fee'] is num
              ? json['max_fee'].toString()
              : json.valueAsString<String>('max_fee')),
      operationCount: json.valueAsInt<int>('operation_count'),
      envelopeXdr:
          (json['envelope_xdr'] is num
              ? json['envelope_xdr'].toString()
              : json.valueAsString<String>('envelope_xdr')),
      resultXdr:
          (json['result_xdr'] is num
              ? json['result_xdr'].toString()
              : json.valueAsString<String>('result_xdr')),
      resultMetaXdr:
          (json['result_meta_xdr'] is num
              ? json['result_meta_xdr'].toString()
              : json.valueAsString<String?>('result_meta_xdr')),
      feeMetaXdr:
          (json['fee_meta_xdr'] is num
              ? json['fee_meta_xdr'].toString()
              : json.valueAsString<String?>('fee_meta_xdr')),
      memoType:
          (json['memo_type'] is num
              ? json['memo_type'].toString()
              : json.valueAsString<String>('memo_type')),
      signatures: json.valueAsList<List<String>>('signatures'),
      preconditions: json
          .valueTo<HorizonTransactionPreconditions?, Map<String, dynamic>>(
            key: 'preconditions',
            parse: (v) => HorizonTransactionPreconditions.fromJson(v),
          ),
      feeBumpTransaction: json
          .valueTo<HorizonFeeBumpTransaction?, Map<String, dynamic>>(
            key: 'fee_bump_transaction',
            parse: (v) => HorizonFeeBumpTransaction.fromJson(v),
          ),
      innerTransaction: json
          .valueTo<HorizonInnerTransaction?, Map<String, dynamic>>(
            key: 'inner_transaction',
            parse: (v) => HorizonInnerTransaction.fromJson(v),
          ),
    );
  }

  Map<String, dynamic> toJson({
    JsonifyConfig config = DefaultJsonifyConfig.defaultConfig,
  }) => config.encodeMap(<String, dynamic>{
    'memo': memo,
    '_links': links?.toJson(config: config),
    'id': id,
    'paging_token': pagingToken,
    'successful': successful,
    'hash': hash,
    'ledger': ledger,
    'created_at': createdAt,
    'source_account': sourceAccount,
    'account_muxed': accountMuxed,
    'account_muxed_id': accountMuxedId,
    'source_account_sequence': sourceAccountSequence,
    'fee_account': feeAccount,
    'fee_account_muxed': feeAccountMuxed,
    'fee_account_muxed_id': feeAccountMuxedId,
    'fee_charged': feeCharged,
    'max_fee': maxFee,
    'operation_count': operationCount,
    'envelope_xdr': envelopeXdr,
    'result_xdr': resultXdr,
    'result_meta_xdr': resultMetaXdr,
    'fee_meta_xdr': feeMetaXdr,
    'memo_type': memoType,
    'signatures': signatures,
    'preconditions': preconditions?.toJson(config: config),
    'fee_bump_transaction': feeBumpTransaction?.toJson(config: config),
    'inner_transaction': innerTransaction?.toJson(config: config),
  });
}
