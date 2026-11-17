/// Dart mirrors of the Stellar XDR ledger definitions (Stellar-ledger-entries.x,
/// Stellar-transaction.x and friends). Each class corresponds to an XDR struct
/// or union of the same name and carries its `layout()` (wire format) plus
/// `fromStruct`/`toLayoutStruct` (de)serialization.
library;

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/error/stellar_error.dart';
import 'package:stellar_dart/src/helper/helper.dart';
import 'package:stellar_dart/src/keypair/keypair.dart';
import 'package:stellar_dart/src/models/models.dart';
import 'package:stellar_dart/src/models/operations/operation.dart';
import 'package:stellar_dart/src/serialization/serialization.dart';
import 'package:stellar_dart/src/utils/validator.dart';

class LedgerEntryType {
  final String name;
  final int value;
  const LedgerEntryType._(this.name, this.value);

  static const LedgerEntryType account = LedgerEntryType._('account', 0);
  static const LedgerEntryType trustline = LedgerEntryType._('trustline', 1);
  static const LedgerEntryType offer = LedgerEntryType._('offer', 2);
  static const LedgerEntryType data = LedgerEntryType._('data', 3);
  static const LedgerEntryType claimableBalance = LedgerEntryType._(
    'claimableBalance',
    4,
  );
  static const LedgerEntryType liquidityPool = LedgerEntryType._(
    'liquidityPool',
    5,
  );
  static const LedgerEntryType contractData = LedgerEntryType._(
    'contractData',
    6,
  );
  static const LedgerEntryType contractCode = LedgerEntryType._(
    'contractCode',
    7,
  );
  static const LedgerEntryType configSetting = LedgerEntryType._(
    'configSetting',
    8,
  );
  static const LedgerEntryType ttl = LedgerEntryType._('ttl', 9);
  static const List<LedgerEntryType> values = [
    account,
    trustline,
    offer,
    data,
    claimableBalance,
    liquidityPool,
    contractData,
    contractCode,
    configSetting,
    ttl,
  ];
  static LedgerEntryType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'LedgerEntry type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'LedgerEntryType.$name';
  }
}

abstract class LedgerEntryData extends XDRVariantSerialization {
  final LedgerEntryType type;
  const LedgerEntryData(this.type);
  factory LedgerEntryData.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = LedgerEntryType.fromName(decode.variantName);
    switch (type) {
      case LedgerEntryType.account:
        return AccountEntry.fromStruct(decode.value);
      case LedgerEntryType.trustline:
        return TrustLineEntry.fromStruct(decode.value);

      case LedgerEntryType.offer:
        return OfferEntry.fromStruct(decode.value);
      case LedgerEntryType.data:
        return DataEntry.fromStruct(decode.value);
      case LedgerEntryType.claimableBalance:
        return ClaimableBalanceEntry.fromStruct(decode.value);

      case LedgerEntryType.liquidityPool:
        return LiquidityPoolEntry.fromStruct(decode.value);

      case LedgerEntryType.contractData:
        return ContractDataEntry.fromStruct(decode.value);

      case LedgerEntryType.contractCode:
        return ContractCodeEntry.fromStruct(decode.value);
      case LedgerEntryType.configSetting:
        return ConfigSettingEntry.fromStruct(decode.value);
      case LedgerEntryType.ttl:
        return TTLEntry.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid LedgerEntry type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(LedgerEntryType.values.length, (index) {
        final type = LedgerEntryType.values.elementAt(index);
        switch (type) {
          case LedgerEntryType.account:
            return LazyVariantModel(
              layout: AccountEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.trustline:
            return LazyVariantModel(
              layout: TrustLineEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.offer:
            return LazyVariantModel(
              layout: OfferEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.data:
            return LazyVariantModel(
              layout: DataEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.claimableBalance:
            return LazyVariantModel(
              layout: ClaimableBalanceEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.liquidityPool:
            return LazyVariantModel(
              layout: LiquidityPoolEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.contractData:
            return LazyVariantModel(
              layout: ContractDataEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.contractCode:
            return LazyVariantModel(
              layout: ContractCodeEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.configSetting:
            return LazyVariantModel(
              layout: ConfigSettingEntry.layout,
              property: type.name,
              index: type.value,
            );
          case LedgerEntryType.ttl:
            return LazyVariantModel(
              layout: TTLEntry.layout,
              property: type.name,
              index: type.value,
            );
          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid LedgerEntry type.',
              details: {'type': type.name},
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class Liabilities extends XDRSerialization {
  final BigInt buying;
  final BigInt selling;
  Liabilities({required BigInt buying, required BigInt selling})
    : buying = buying.asI64,
      selling = selling.asI64;
  factory Liabilities.fromStruct(Map<String, dynamic> json) {
    return Liabilities(
      buying: json.valueAs('buying'),
      selling: json.valueAs('selling'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'buying'),
      LayoutConst.s64be(property: 'selling'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'buying': buying, 'selling': selling};
  }
}

class AccountEntry extends LedgerEntryData {
  /// master public key for this account
  final StellarPublicKey accountId;
  final BigInt balance;
  final BigInt seqNum;
  final int numSubEntries;
  final StellarPublicKey? inflationDest;
  final int flags;

  /// can be used for reverse federation and memo lookup
  final String homeDomain;

  /// fields used for signatures
  /// thresholds stores unsigned bytes: [weight of master|low|medium|high]
  final BuBytes thresholds;
  final List<Signer> signers;
  final AccountEntryExt ext;
  AccountEntry({
    required this.accountId,
    required BigInt balance,
    required BigInt seqNum,
    required int numSubEntries,
    this.inflationDest,
    required int flags,
    required String homeDomain,
    required List<int> thresholds,
    required List<Signer> signers,
    required this.ext,
  }) : homeDomain = StellarValidator.validateString(value: homeDomain, max: 32),
       thresholds =
           thresholds
               .max(
                 length: 4,
                 operation: "AccountEntry",
                 reason: "Invalid thresholds bytes length.",
                 name: 'thresholds',
               )
               .asImmutableBytes,
       signers = signers.immutable,
       balance = balance.asI64,
       seqNum = seqNum.asI64,
       flags = flags.asU32,
       numSubEntries = numSubEntries.asU32,
       super(LedgerEntryType.account);
  factory AccountEntry.fromStruct(Map<String, dynamic> json) {
    return AccountEntry(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      balance: json.valueAs('balance'),
      seqNum: json.valueAs('seqNum'),
      numSubEntries: json.valueAs('numSubEntries'),
      flags: json.valueAs('flags'),
      homeDomain: json.valueAs('homeDomain'),
      signers:
          json
              .valueEnsureAsList<Map<String, dynamic>>('signers')
              .map((e) => Signer.fromStruct(e))
              .toList(),
      thresholds: json.valueAs('thresholds'),
      ext: AccountEntryExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      inflationDest: json.valueTo<StellarPublicKey?, Map<String, dynamic>>(
        key: 'inflationDest',
        parse: (p0) => StellarPublicKey.fromStruct(p0),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      LayoutConst.s64be(property: 'balance'),
      LayoutConst.s64be(property: 'seqNum'),
      LayoutConst.u32be(property: 'numSubEntries'),
      LayoutConst.optionalU32Be(
        StellarPublicKey.layout(),
        property: 'inflationDest',
      ),
      LayoutConst.u32be(property: 'flags'),
      LayoutConst.xdrString(property: 'homeDomain'),
      LayoutConst.fixedBlobN(
        StellarConst.thresHoldsLen,
        property: 'thresholds',
      ),
      LayoutConst.xdrVec(Signer.layout(), property: 'signers'),
      AccountEntryExt.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'signers': signers.map((e) => e.toLayoutStruct()).toList(),
      'thresholds': thresholds,
      'homeDomain': homeDomain,
      'flags': flags,
      'inflationDest': inflationDest?.toLayoutStruct(),
      'numSubEntries': numSubEntries,
      'seqNum': seqNum,
      'balance': balance,
      'accountId': accountId.toLayoutStruct(),
    };
  }
}

class ExtentionPointVoid extends XDRVariantSerialization {
  const ExtentionPointVoid();
  factory ExtentionPointVoid.fromStruct(Map<String, dynamic> json) {
    return const ExtentionPointVoid();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }

  @override
  String get variantName {
    return ExtensionPointType.extVoid.name;
  }
}

class AccountEntryExtensionV3 extends XDRSerialization {
  /// We can use this to add more fields, or because it is first, to
  /// change AccountEntryExtensionV3 into a union.
  final ExtentionPointVoid ext;

  /// Ledger number at which `seqNum` took on its present value.
  final int seqLedger;

  /// Time at which `seqNum` took on its present value.
  final BigInt seqTime;
  AccountEntryExtensionV3({
    required int seqLedger,
    required BigInt seqTime,
    this.ext = const ExtentionPointVoid(),
  }) : seqTime = seqTime.asU64,
       seqLedger = seqLedger.asU32;
  factory AccountEntryExtensionV3.fromStruct(Map<String, dynamic> json) {
    return AccountEntryExtensionV3(
      seqLedger: json.valueAs('seqLedger'),
      seqTime: json.valueAs('seqTime'),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      LayoutConst.u32be(property: 'seqLedger'),
      LayoutConst.u64be(property: 'seqTime'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'seqLedger': seqLedger,
      'seqTime': seqTime,
    };
  }
}

class AccountEntryExtensionV3Ext extends XDRVariantSerialization {
  final AccountEntryExtensionV3? v3;
  const AccountEntryExtensionV3Ext({this.v3});
  factory AccountEntryExtensionV3Ext.fromXdr(
    List<int> bytes, {
    String? property,
  }) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return AccountEntryExtensionV3Ext.fromStruct(decode);
  }
  factory AccountEntryExtensionV3Ext.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const AccountEntryExtensionV3Ext();
      case ExtensionPointType.extArgs3:
        return AccountEntryExtensionV3Ext(
          v3: AccountEntryExtensionV3.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid AccountEntryExtensionV3Ext extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs3.value,
        layout: AccountEntryExtensionV3.layout,
        property: ExtensionPointType.extArgs3.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v3 != null) {
      return AccountEntryExtensionV3.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v3?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v3 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs3.name;
  }
}

class AccountEntryExtensionV2 extends XDRSerialization {
  final int numSponsored;
  final int numSponsoring;
  final List<StellarPublicKey?> signerSponsoringIDs;
  final AccountEntryExtensionV3Ext ext;
  AccountEntryExtensionV2({
    required int numSponsored,
    required int numSponsoring,
    List<StellarPublicKey?> signerSponsoringIDs = const [],
    required this.ext,
  }) : numSponsored = numSponsored.asU32,
       numSponsoring = numSponsoring.asU32,
       signerSponsoringIDs = signerSponsoringIDs.immutable.max(
         length: 20,
         operation: "StellarPublicKey",
         reason: "Invalid signerSponsoringIDs length.",
         name: 'signerSponsoringIDs',
       );
  factory AccountEntryExtensionV2.fromStruct(Map<String, dynamic> json) {
    return AccountEntryExtensionV2(
      numSponsored: json.valueAs('numSponsored'),
      numSponsoring: json.valueAs('numSponsoring'),
      signerSponsoringIDs:
          json.valueAs<List>('signerSponsoringIDs').map((e) {
            if (e == null) return null;
            try {
              final data = Map<String, dynamic>.from(e);
              return StellarPublicKey.fromStruct(data);
            } catch (e, s) {
              throw BuError(DefaultErrorType.invalidArgument, 
                'Incorrect value.',
                details: {
                  'key': 'signerSponsoringIDs',
                  'data': json['signerSponsoringIDs'],
                  'error': e.toString(),
                  'stack': s.toString(),
                },
              );
            }
          }).toList(),
      ext: AccountEntryExtensionV3Ext.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'numSponsored'),
      LayoutConst.u32be(property: 'numSponsoring'),
      LayoutConst.xdrVec(
        LayoutConst.optionalU32Be(StellarPublicKey.layout()),
        property: 'signerSponsoringIDs',
      ),
      AccountEntryExtensionV3Ext.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'numSponsored': numSponsored,
      'numSponsoring': numSponsoring,
      'signerSponsoringIDs':
          signerSponsoringIDs.map((e) => e?.toLayoutStruct()).toList(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class AccountEntryExtensionV2Ext extends XDRVariantSerialization {
  final AccountEntryExtensionV2? v2;
  const AccountEntryExtensionV2Ext({this.v2});
  factory AccountEntryExtensionV2Ext.fromXdr(
    List<int> bytes, {
    String? property,
  }) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return AccountEntryExtensionV2Ext.fromStruct(decode);
  }
  factory AccountEntryExtensionV2Ext.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const AccountEntryExtensionV2Ext();
      case ExtensionPointType.extArgs2:
        return AccountEntryExtensionV2Ext(
          v2: AccountEntryExtensionV2.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid AccountEntryExtensionV2 extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs2.value,
        layout: AccountEntryExtensionV2.layout,
        property: ExtensionPointType.extArgs2.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v2 != null) {
      return AccountEntryExtensionV2.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v2?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v2 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs2.name;
  }
}

class AccountEntryExtensionV1 extends XDRSerialization {
  final Liabilities liabilities;
  final AccountEntryExtensionV2Ext ext;
  const AccountEntryExtensionV1({required this.liabilities, required this.ext});
  factory AccountEntryExtensionV1.fromStruct(Map<String, dynamic> json) {
    return AccountEntryExtensionV1(
      liabilities: Liabilities.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('liabilities'),
      ),
      ext: AccountEntryExtensionV2Ext.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Liabilities.layout(property: 'liabilities'),
      AccountEntryExtensionV2Ext.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'liabilities': liabilities.toLayoutStruct(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class AccountEntryExt extends XDRVariantSerialization {
  final AccountEntryExtensionV1? v1;
  const AccountEntryExt({this.v1});
  factory AccountEntryExt.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return AccountEntryExt.fromStruct(decode);
  }
  factory AccountEntryExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const AccountEntryExt();
      case ExtensionPointType.extArgs1:
        return AccountEntryExt(
          v1: AccountEntryExtensionV1.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid AccountEntry extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: AccountEntryExtensionV1.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v1 != null) {
      return AccountEntryExtensionV1.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v1?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v1 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }
}

class TrustLineEntryExtensionV2 extends XDRSerialization {
  final int liquidityPoolUseCount;
  final ExtentionPointVoid ext;
  TrustLineEntryExtensionV2({
    required int liquidityPoolUseCount,
    this.ext = const ExtentionPointVoid(),
  }) : liquidityPoolUseCount = liquidityPoolUseCount.asI32;
  factory TrustLineEntryExtensionV2.fromStruct(Map<String, dynamic> json) {
    return TrustLineEntryExtensionV2(
      liquidityPoolUseCount: json.valueAs('liquidityPoolUseCount'),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: 'liquidityPoolUseCount'),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'liquidityPoolUseCount': liquidityPoolUseCount,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class TrustLineEntryV2Ext extends XDRVariantSerialization {
  final TrustLineEntryExtensionV2? v2;
  const TrustLineEntryV2Ext({this.v2});
  factory TrustLineEntryV2Ext.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const TrustLineEntryV2Ext();
      case ExtensionPointType.extArgs2:
        return TrustLineEntryV2Ext(
          v2: TrustLineEntryExtensionV2.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid TrustLineEntryExtensionV2 extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs2.value,
        layout: TrustLineEntryExtensionV2.layout,
        property: ExtensionPointType.extArgs2.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v2 != null) {
      return TrustLineEntryExtensionV2.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v2?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v2 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs2.name;
  }
}

class TrustLineEntryV1 extends XDRSerialization {
  final Liabilities liabilities;
  final TrustLineEntryV2Ext ext;
  const TrustLineEntryV1({required this.liabilities, required this.ext});
  factory TrustLineEntryV1.fromStruct(Map<String, dynamic> json) {
    return TrustLineEntryV1(
      liabilities: Liabilities.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('liabilities'),
      ),
      ext: TrustLineEntryV2Ext.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Liabilities.layout(property: 'liabilities'),
      TrustLineEntryV2Ext.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'liabilities': liabilities.toLayoutStruct(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class TrustLineEntryExt extends XDRVariantSerialization {
  final TrustLineEntryV1? v1;
  const TrustLineEntryExt({this.v1});
  factory TrustLineEntryExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const TrustLineEntryExt();
      case ExtensionPointType.extArgs1:
        return TrustLineEntryExt(v1: TrustLineEntryV1.fromStruct(decode.value));
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid TrustLineEntryV1 extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: TrustLineEntryExtensionV2.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v1 != null) {
      return TrustLineEntryV1.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v1?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v1 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }
}

/// accept poolId
typedef TrustLineAsset = StellarAsset;

class TrustLineEntry extends LedgerEntryData {
  /// account this trustline belongs to
  final StellarPublicKey accountId;

  /// type of asset (with issuer)
  final TrustLineAsset asset;

  /// how much of this asset the user has.
  final BigInt balance;

  /// balance cannot be above this
  final BigInt limit;

  /// see TrustLineFlags
  final int flags;

  /// reserved for future use
  final TrustLineEntryExt ext;
  TrustLineEntry({
    required this.accountId,
    required this.asset,
    required BigInt balance,
    required BigInt limit,
    required int flags,
    required this.ext,
  }) : balance = balance.asI64,
       limit = limit.asI64,
       flags = flags.asU32,
       super(LedgerEntryType.trustline);
  factory TrustLineEntry.fromStruct(Map<String, dynamic> json) {
    return TrustLineEntry(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      asset: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('asset'),
      ),
      balance: json.valueAs('balance'),
      limit: json.valueAs('limit'),
      flags: json.valueAs('flags'),
      ext: TrustLineEntryExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      StellarAsset.layout(property: 'asset'),
      LayoutConst.s64be(property: 'balance'),
      LayoutConst.s64be(property: 'limit'),
      LayoutConst.u32be(property: 'flags'),
      TrustLineEntryExt.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'accountId': accountId.toLayoutStruct(),
      'asset': asset.toVariantLayoutStruct(),
      'balance': balance,
      'limit': limit,
      'flags': flags,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class StellarPrice extends XDRSerialization {
  final int numerator;
  final int denominator;
  StellarPrice({required int numerator, required int denominator})
    : numerator = numerator.asI32,
      denominator = denominator.asI32;
  factory StellarPrice.fromDecimal(String price) {
    return StellarHelper.approximatePriceUsingContinuedFraction(price);
  }
  factory StellarPrice.fromStruct(Map<String, dynamic> json) {
    return StellarPrice(
      numerator: json.valueAs('numerator'),
      denominator: json.valueAs('denominator'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: 'numerator'),
      LayoutConst.s32be(property: 'denominator'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'numerator': numerator, 'denominator': denominator};
  }

  BigRational toBigRational() {
    return BigRational(
      BigInt.from(numerator),
      denominator: BigInt.from(denominator),
    );
  }

  String toPrice([int? scale]) {
    final rational = BigRational(
      BigInt.from(numerator),
      denominator: BigInt.from(denominator),
    );
    return rational.toDecimal(digits: scale);
  }
}

class OfferEntry extends LedgerEntryData {
  final StellarPublicKey sellerId;
  final BigInt offerId;
  final StellarAsset selling;
  final StellarAsset buying;
  final BigInt amount;

  /// price for this offer:
  /// price of A in terms of B
  /// price=AmountB/AmountA=priceNumerator/priceDenominator
  /// price is after fees
  final StellarPrice price;
  final int flags;
  final ExtentionPointVoid ext;

  OfferEntry({
    required this.sellerId,
    required BigInt offerId,
    required this.selling,
    required this.buying,
    required BigInt amount,
    required this.price,
    required int flags,
    required this.ext,
  }) : offerId = offerId.asI64,
       amount = amount.asI64,
       flags = flags.asU32,
       super(LedgerEntryType.offer);
  factory OfferEntry.fromStruct(Map<String, dynamic> json) {
    return OfferEntry(
      amount: json.valueAs('amount'),
      buying: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('buying'),
      ),
      selling: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('selling'),
      ),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      flags: json.valueAs('flags'),
      offerId: json.valueAs('offerId'),
      price: StellarPrice.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('price'),
      ),
      sellerId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('sellerId'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'sellerId'),
      LayoutConst.s64be(property: 'offerId'),
      StellarAsset.layout(property: 'selling'),
      StellarAsset.layout(property: 'buying'),
      LayoutConst.s64be(property: 'amount'),
      StellarPrice.layout(property: 'price'),
      LayoutConst.u32be(property: 'flags'),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'sellerId': sellerId.toLayoutStruct(),
      'offerId': offerId,
      'selling': selling.toVariantLayoutStruct(),
      'buying': buying.toVariantLayoutStruct(),
      'amount': amount,
      'price': price.toLayoutStruct(),
      'flags': flags,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class DataEntry extends LedgerEntryData {
  final StellarPublicKey accountId;
  final String dataName;
  final BuBytes dataValue;
  final ExtentionPointVoid ext;
  DataEntry({
    required this.accountId,
    required String dataName,
    required List<int> dataValue,
    this.ext = const ExtentionPointVoid(),
  }) : dataName = StellarValidator.validateString(
         value: dataName,
         max: StellarConst.str64,
       ),
       dataValue =
           dataValue
               .max(
                 name: 'dataValue',
                 length: StellarConst.dataValueLength,
                 operation: "DataEntry",
                 reason: "Invalid dataValue length.",
               )
               .asImmutableBytes,
       super(LedgerEntryType.data);
  factory DataEntry.fromStruct(Map<String, dynamic> json) {
    return DataEntry(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      dataName: json.valueAs('dataName'),
      dataValue: json.valueAs('dataValue'),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      LayoutConst.xdrString(property: 'dataName'),
      LayoutConst.xdrVecBytes(property: 'dataValue'),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'accountId': accountId.createLayout(),
      'dataName': dataName,
      'dataValue': dataValue,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class ClaimableBalanceEntryExtensionV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final int flags;
  ClaimableBalanceEntryExtensionV1({
    this.ext = const ExtentionPointVoid(),
    required int flags,
  }) : flags = flags.asU32;
  factory ClaimableBalanceEntryExtensionV1.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ClaimableBalanceEntryExtensionV1(
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      flags: json.valueAs('flags'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      LayoutConst.u32be(property: 'flags'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ext': ext.toVariantLayoutStruct(), 'flags': flags};
  }
}

class ClaimableBalanceEntryExt extends XDRVariantSerialization {
  final ClaimableBalanceEntryExtensionV1? v1;
  const ClaimableBalanceEntryExt({this.v1});
  factory ClaimableBalanceEntryExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const ClaimableBalanceEntryExt();
      case ExtensionPointType.extArgs1:
        return ClaimableBalanceEntryExt(
          v1: ClaimableBalanceEntryExtensionV1.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid TrustLineEntryV1 extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: ClaimableBalanceEntryExtensionV1.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v1 != null) {
      return ClaimableBalanceEntryExtensionV1.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v1?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v1 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }
}

class ClaimableBalanceIdType {
  final String name;
  final int value;
  const ClaimableBalanceIdType._({required this.name, required this.value});
  static const ClaimableBalanceIdType v0 = ClaimableBalanceIdType._(
    name: 'V0',
    value: 0,
  );
  static const List<ClaimableBalanceIdType> values = [v0];
  static ClaimableBalanceIdType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ClaimableBalanceId not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ClaimableBalanceIdType.$name';
  }
}

abstract class ClaimableBalanceId extends XDRVariantSerialization {
  final ClaimableBalanceIdType type;
  const ClaimableBalanceId(this.type);

  factory ClaimableBalanceId.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ClaimableBalanceIdType.fromName(decode.variantName);
    switch (type) {
      case ClaimableBalanceIdType.v0:
        return ClaimableBalanceIdV0.fromStruct(decode.value);
      default:
        throw BuError(StellarErrorType.address, 
          'Invalid ClaimableBalanceId type.',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ClaimableBalanceIdV0.layout(property: ClaimableBalanceIdType.v0.name),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ClaimableBalanceIdV0 extends ClaimableBalanceId {
  final BuBytes hash;
  ClaimableBalanceIdV0(List<int> hash)
    : hash =
          hash
              .exc(
                name: 'hash',
                length: StellarConst.hash256Length,
                operation: "ClaimableBalanceIdV0",
                reason: "Invalid hash bytes length.",
              )
              .asImmutableBytes,
      super(ClaimableBalanceIdType.v0);
  factory ClaimableBalanceIdV0.fromStruct(Map<String, dynamic> json) {
    return ClaimableBalanceIdV0(json.valueAs('hash'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash};
  }
}

class ClaimantType {
  final String name;
  final int value;
  const ClaimantType._({required this.name, required this.value});
  static const ClaimantType v0 = ClaimantType._(name: 'V0', value: 0);
  static const List<ClaimantType> values = [v0];
  static ClaimantType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Claimant type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ClaimantType.$name';
  }
}

abstract class Claimant extends XDRVariantSerialization {
  final ClaimantType type;
  const Claimant(this.type);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ClaimantV0.layout(property: ClaimantType.v0.name),
    ], property: property);
  }

  factory Claimant.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ClaimantType.fromName(decode.variantName);
    switch (type) {
      case ClaimantType.v0:
        return ClaimantV0.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid Claimant type.',
          details: {'type': type.name},
        );
    }
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ClaimantV0 extends Claimant {
  final StellarPublicKey destination;
  final ClaimPredicate predicate;
  const ClaimantV0({required this.predicate, required this.destination})
    : super(ClaimantType.v0);
  factory ClaimantV0.fromStruct(Map<String, dynamic> json) {
    return ClaimantV0(
      destination: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('destination'),
      ),
      predicate: ClaimPredicate.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('predicate'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'destination'),
      ClaimPredicate.layout(property: 'predicate'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'destination': destination.toLayoutStruct(),
      'predicate': predicate.toVariantLayoutStruct(),
    };
  }
}

class ClaimPredicateType {
  final String name;
  final int value;
  const ClaimPredicateType._({required this.name, required this.value});
  static const ClaimPredicateType unconditional = ClaimPredicateType._(
    name: 'Unconditional',
    value: 0,
  );
  static const ClaimPredicateType and = ClaimPredicateType._(
    name: 'And',
    value: 1,
  );
  static const ClaimPredicateType or = ClaimPredicateType._(
    name: 'Or',
    value: 2,
  );
  static const ClaimPredicateType not = ClaimPredicateType._(
    name: 'Not',
    value: 3,
  );
  static const ClaimPredicateType beforeAbsoluteTime = ClaimPredicateType._(
    name: 'BeforeAbsoluteTime',
    value: 4,
  );
  static const ClaimPredicateType beforeRelativeTime = ClaimPredicateType._(
    name: 'BeforeRelativeTime',
    value: 5,
  );
  static const List<ClaimPredicateType> values = [
    unconditional,
    and,
    or,
    not,
    beforeAbsoluteTime,
    beforeRelativeTime,
  ];
  static ClaimPredicateType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ClaimPredicate type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ClaimPredicateType.$name';
  }
}

abstract class ClaimPredicate extends XDRVariantSerialization {
  final ClaimPredicateType type;
  const ClaimPredicate(this.type);
  factory ClaimPredicate.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ClaimPredicateType.fromName(decode.variantName);
    switch (type) {
      case ClaimPredicateType.unconditional:
        return ClaimPredicateUnconditional.fromStruct(decode.value);
      case ClaimPredicateType.and:
        return ClaimPredicateAnd.fromStruct(decode.value);
      case ClaimPredicateType.or:
        return ClaimPredicateOr.fromStruct(decode.value);
      case ClaimPredicateType.not:
        return ClaimPredicateNot.fromStruct(decode.value);
      case ClaimPredicateType.beforeAbsoluteTime:
        return ClaimPredicateBeforeAbsoluteTime.fromStruct(decode.value);
      case ClaimPredicateType.beforeRelativeTime:
        return ClaimPredicateBeforeRelativeTime.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid ClaimPredicate type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(ClaimPredicateType.values.length, (index) {
        final type = ClaimPredicateType.values.elementAt(index);
        switch (type) {
          case ClaimPredicateType.unconditional:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateUnconditional.layout,
              property: type.name,
            );
          case ClaimPredicateType.and:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateAnd.layout,
              property: type.name,
            );
          case ClaimPredicateType.or:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateOr.layout,
              property: type.name,
            );
          case ClaimPredicateType.not:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateNot.layout,
              property: type.name,
            );
          case ClaimPredicateType.beforeAbsoluteTime:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateBeforeAbsoluteTime.layout,
              property: type.name,
            );
          case ClaimPredicateType.beforeRelativeTime:
            return LazyVariantModel(
              index: type.value,
              layout: ClaimPredicateBeforeRelativeTime.layout,
              property: type.name,
            );

          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid ClaimPredicate type.',
              details: {'type': type.name},
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ClaimPredicateUnconditional extends ClaimPredicate {
  const ClaimPredicateUnconditional() : super(ClaimPredicateType.unconditional);
  factory ClaimPredicateUnconditional.fromStruct(Map<String, dynamic> json) {
    return const ClaimPredicateUnconditional();
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class ClaimPredicateAnd extends ClaimPredicate {
  final List<ClaimPredicate> andPredicates;
  ClaimPredicateAnd(List<ClaimPredicate> value)
    : andPredicates = value.immutable.max(
        name: 'ClaimPredicate',
        length: 2,
        operation: "ClaimPredicateAnd",
        reason: "Invalid andPredicates length.",
      ),
      super(ClaimPredicateType.and);
  factory ClaimPredicateAnd.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateAnd(
      json
          .valueEnsureAsList<Map<String, dynamic>>('andPredicates')
          .map((e) => ClaimPredicate.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ClaimPredicate.layout(), property: 'andPredicates'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'andPredicates':
          andPredicates.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

class ClaimPredicateOr extends ClaimPredicate {
  final List<ClaimPredicate> orPredicates;
  ClaimPredicateOr(List<ClaimPredicate> orPredicates)
    : orPredicates = orPredicates.immutable.max(
        name: 'orPredicates',
        length: 2,
        operation: "ClaimPredicateOr",
        reason: "Invalid orPredicates length.",
      ),
      super(ClaimPredicateType.or);
  factory ClaimPredicateOr.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateOr(
      json
          .valueEnsureAsList<Map<String, dynamic>>('orPredicates')
          .map((e) => ClaimPredicate.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ClaimPredicate.layout(), property: 'orPredicates'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'orPredicates':
          orPredicates.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

class ClaimPredicateNot extends ClaimPredicate {
  final ClaimPredicate? notPredicate;
  ClaimPredicateNot(this.notPredicate) : super(ClaimPredicateType.not);
  factory ClaimPredicateNot.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateNot(
      json.valueTo<ClaimPredicate?, Map<String, dynamic>>(
        key: 'notPredicate',
        parse: (e) => ClaimPredicate.fromStruct(e),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(
        ClaimPredicate.layout(),
        property: 'notPredicate',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'notPredicate': notPredicate?.toVariantLayoutStruct()};
  }
}

class ClaimPredicateBeforeAbsoluteTime extends ClaimPredicate {
  final BigInt absBefore;
  ClaimPredicateBeforeAbsoluteTime(BigInt absBefore)
    : absBefore = absBefore.asI64,
      super(ClaimPredicateType.beforeAbsoluteTime);
  factory ClaimPredicateBeforeAbsoluteTime.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ClaimPredicateBeforeAbsoluteTime(json.valueAs('absBefore'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'absBefore'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'absBefore': absBefore};
  }
}

class ClaimPredicateBeforeRelativeTime extends ClaimPredicate {
  final BigInt relBefore;
  ClaimPredicateBeforeRelativeTime(BigInt relBefore)
    : relBefore = relBefore.asI64,
      super(ClaimPredicateType.beforeRelativeTime);
  factory ClaimPredicateBeforeRelativeTime.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ClaimPredicateBeforeRelativeTime(json.valueAs('relBefore'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'relBefore'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'relBefore': relBefore};
  }
}

class ClaimableBalanceEntry extends LedgerEntryData {
  final ClaimableBalanceId balanceId;
  final List<Claimant> claimants;
  final StellarAsset asset;
  final BigInt amount;
  final ClaimableBalanceEntryExt ext;
  ClaimableBalanceEntry({
    required this.balanceId,
    required List<Claimant> claimants,
    required this.asset,
    required BigInt amount,
    required this.ext,
  }) : claimants = claimants.immutable.max(
         name: 'claimants',
         length: 10,
         operation: "ClaimableBalanceEntry",
         reason: "Invalid claimants length.",
       ),
       amount = amount.asI64,
       super(LedgerEntryType.claimableBalance);
  factory ClaimableBalanceEntry.fromStruct(Map<String, dynamic> json) {
    return ClaimableBalanceEntry(
      amount: json.valueAs('amount'),
      balanceId: ClaimableBalanceId.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('balanceId'),
      ),
      asset: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('asset'),
      ),
      claimants:
          json
              .valueEnsureAsList<Map<String, dynamic>>('claimants')
              .map((e) => Claimant.fromStruct(e))
              .toList(),
      ext: ClaimableBalanceEntryExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ClaimableBalanceId.layout(property: 'balanceId'),
      LayoutConst.xdrVec(Claimant.layout(), property: 'claimants'),
      StellarAsset.layout(property: 'asset'),
      LayoutConst.u64(property: 'amount'),
      ClaimableBalanceEntryExt.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'balanceId': balanceId.toVariantLayoutStruct(),
      'claimants': claimants.map((e) => e.toVariantLayoutStruct()).toList(),
      'asset': asset.toVariantLayoutStruct(),
      'amount': amount,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class LiquidityPoolType {
  final int value;
  final String name;
  const LiquidityPoolType._({required this.value, required this.name});
  static const LiquidityPoolType liquidityPoolConstantProduct =
      LiquidityPoolType._(name: 'liquidityPoolConstantProduct', value: 0);
  static const List<LiquidityPoolType> values = [liquidityPoolConstantProduct];
  static LiquidityPoolType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'LiquidityPool type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'LiquidityPoolType.$name';
  }
}

abstract class LiquidityPoolEntryBody extends XDRVariantSerialization {
  final LiquidityPoolType type;
  const LiquidityPoolEntryBody(this.type);
  factory LiquidityPoolEntryBody.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = LiquidityPoolType.fromName(decode.variantName);
    switch (type) {
      case LiquidityPoolType.liquidityPoolConstantProduct:
        return LiquidityPoolEntryConstantProduct.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid LiquidityPool type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        layout: LiquidityPoolEntryConstantProduct.layout,
        property: LiquidityPoolType.liquidityPoolConstantProduct.name,
        index: LiquidityPoolType.liquidityPoolConstantProduct.value,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class LiquidityPoolConstantProductParameters extends XDRSerialization {
  final StellarAsset assetA;
  final StellarAsset assetB;

  /// Fee is in basis points, so the actual rate is (fee/100)%
  final int fee;
  LiquidityPoolConstantProductParameters({
    required this.assetA,
    required this.assetB,
    required int fee,
  }) : fee = fee.asI32;
  factory LiquidityPoolConstantProductParameters.fromStruct(
    Map<String, dynamic> json,
  ) {
    return LiquidityPoolConstantProductParameters(
      assetA: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('assetA'),
      ),
      assetB: StellarAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('assetB'),
      ),
      fee: json.valueAs('fee'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: 'assetA'),
      StellarAsset.layout(property: 'assetB'),
      LayoutConst.s32be(property: 'fee'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'assetA': assetA.toVariantLayoutStruct(),
      'assetB': assetB.toVariantLayoutStruct(),
      'fee': fee,
    };
  }
}

class LiquidityPoolEntryConstantProduct extends LiquidityPoolEntryBody {
  final LiquidityPoolConstantProductParameters param;

  /// amount of A in the pool
  final BigInt reserveA;

  /// amount of B in the pool
  final BigInt reserveB;

  /// total number of pool shares issued
  final BigInt totalPoolShares;

  /// number of trust lines
  final BigInt poolSharesTrustLineCount;
  LiquidityPoolEntryConstantProduct({
    required this.param,
    required BigInt reserveA,
    required BigInt reserveB,
    required BigInt totalPoolShares,
    required BigInt poolSharesTrustLineCount,
  }) : reserveA = reserveA.asI64,
       reserveB = reserveB.asI64,
       totalPoolShares = totalPoolShares.asI64,
       poolSharesTrustLineCount = poolSharesTrustLineCount.asI64,
       super(LiquidityPoolType.liquidityPoolConstantProduct);
  factory LiquidityPoolEntryConstantProduct.fromStruct(
    Map<String, dynamic> json,
  ) {
    return LiquidityPoolEntryConstantProduct(
      param: LiquidityPoolConstantProductParameters.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('param'),
      ),
      poolSharesTrustLineCount: json.valueAs('poolSharesTrustLineCount'),
      reserveA: json.valueAs('reserveA'),
      reserveB: json.valueAs('reserveB'),
      totalPoolShares: json.valueAs('totalPoolShares'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LiquidityPoolConstantProductParameters.layout(property: 'param'),
      LayoutConst.s64be(property: 'reserveA'),
      LayoutConst.s64be(property: 'reserveB'),
      LayoutConst.s64be(property: 'totalPoolShares'),
      LayoutConst.s64be(property: 'poolSharesTrustLineCount'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'param': param.toLayoutStruct(),
      'reserveA': reserveA,
      'reserveB': reserveB,
      'totalPoolShares': totalPoolShares,
      'poolSharesTrustLineCount': poolSharesTrustLineCount,
    };
  }
}

class LiquidityPoolEntry extends LedgerEntryData {
  final BuBytes liquidityPoolId;
  final LiquidityPoolEntryBody body;
  LiquidityPoolEntry({required List<int> liquidityPoolId, required this.body})
    : liquidityPoolId =
          liquidityPoolId
              .exc(
                name: 'liquidityPoolId',
                length: StellarConst.hash256Length,
                operation: "LiquidityPoolEntry",
                reason: "Invalid liquidityPoolId bytes length.",
              )
              .asImmutableBytes,
      super(LedgerEntryType.liquidityPool);
  factory LiquidityPoolEntry.fromStruct(Map<String, dynamic> json) {
    return LiquidityPoolEntry(
      liquidityPoolId: json.valueAs('liquidityPoolId'),
      body: LiquidityPoolEntryBody.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('body'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'liquidityPoolId',
      ),
      LiquidityPoolEntryBody.layout(property: 'body'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'liquidityPoolId': liquidityPoolId,
      'body': body.toVariantLayoutStruct(),
    };
  }
}

class ScAddressType {
  final String name;
  final int value;
  const ScAddressType._({required this.name, required this.value});
  static const ScAddressType account = ScAddressType._(
    name: 'account',
    value: 0,
  );
  static const ScAddressType contract = ScAddressType._(
    name: 'contract',
    value: 1,
  );
  static const ScAddressType muxedAccount = ScAddressType._(
    name: 'muxedAccount',
    value: 2,
  );
  static const ScAddressType claimableBalance = ScAddressType._(
    name: 'claimableBalance',
    value: 3,
  );
  static const ScAddressType liquidityPool = ScAddressType._(
    name: 'liquidityPool',
    value: 4,
  );
  static const ScAddressType muxedContract = ScAddressType._(
    name: 'muxedContract',
    value: 5,
  );
  static const List<ScAddressType> values = [
    account,
    contract,
    muxedAccount,
    claimableBalance,
    liquidityPool,
    muxedContract,
  ];
  static ScAddressType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ScAddress type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ScAddressType.$name';
  }
}

abstract class ScAddress extends XDRVariantSerialization {
  final ScAddressType type;
  const ScAddress(this.type);
  StellarAddress get address;
  factory ScAddress.fromAddress(StellarAddress address) {
    switch (address.type) {
      case XlmAddrTypes.contract:
        return ScAddressContract(address.cast());
      case XlmAddrTypes.pubKey:
        return ScAddressAccountId(address.toPublicKey());
      case XlmAddrTypes.muxed:
        return ScAddressMuxedAccount.fromAddress(address.cast());
      case XlmAddrTypes.muxedContract:
        return ScAddressMuxedContract.fromAddress(address.cast());
      default:
        throw BuError(StellarErrorType.address, 
          'Invalid address type.',
          details: {'type': address.type.name},
        );
    }
  }
  factory ScAddress.fromBase32Address(String address) {
    return ScAddress.fromAddress(StellarAddress.fromBase32Addr(address));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ScAddressAccountId.layout(property: ScAddressType.account.name),
      ScAddressContract.layout(property: ScAddressType.contract.name),
      ScAddressMuxedAccount.layout(property: ScAddressType.muxedAccount.name),
      ScAddressClaimableBalance.layout(
        property: ScAddressType.claimableBalance.name,
      ),
      ScAddressLiquidityPool.layout(property: ScAddressType.liquidityPool.name),
      ScAddressMuxedContract.layout(property: ScAddressType.muxedContract.name),
    ], property: property);
  }

  factory ScAddress.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ScAddressType.fromName(decode.variantName);
    switch (type) {
      case ScAddressType.account:
        return ScAddressAccountId.fromStruct(decode.value);
      case ScAddressType.contract:
        return ScAddressContract.fromStruct(decode.value);
      case ScAddressType.muxedAccount:
        return ScAddressMuxedAccount.fromStruct(decode.value);
      case ScAddressType.claimableBalance:
        return ScAddressClaimableBalance.fromStruct(decode.value);
      case ScAddressType.liquidityPool:
        return ScAddressLiquidityPool.fromStruct(decode.value);
      case ScAddressType.muxedContract:
        return ScAddressMuxedContract.fromStruct(decode.value);
      default:
        throw BuError(StellarErrorType.address, 
          'Invalid ScAddress type.',
          details: {'type': type.name},
        );
    }
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ScAddressAccountId extends ScAddress {
  final StellarPublicKey accountId;
  const ScAddressAccountId(this.accountId) : super(ScAddressType.account);
  factory ScAddressAccountId.fromStruct(Map<String, dynamic> json) {
    return ScAddressAccountId(
      StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
    );
  }
  factory ScAddressAccountId.fromAddress(StellarAddress address) {
    return ScAddressAccountId(address.toPublicKey());
  }
  factory ScAddressAccountId.fromBase32Address(String address) {
    return ScAddressAccountId.fromAddress(
      StellarAddress.fromBase32Addr(address),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'accountId': accountId.toLayoutStruct()};
  }

  @override
  StellarAddress get address => accountId.toAddress();
}

class ScAddressContract extends ScAddress {
  final StellarContractAddress contractId;
  ScAddressContract(this.contractId) : super(ScAddressType.contract);
  factory ScAddressContract.fromBytes(List<int> contractId) {
    return ScAddressContract(StellarContractAddress.fromBytes(contractId));
  }
  factory ScAddressContract.fromBase32Address(String address) {
    return ScAddressContract(StellarContractAddress(address));
  }
  factory ScAddressContract.fromStruct(Map<String, dynamic> json) {
    return ScAddressContract(
      StellarContractAddress.fromBytes(json.valueAs('contractId')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'contractId',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'contractId': contractId.keyBytes()};
  }

  @override
  StellarAddress get address => contractId;

  @override
  Map<String, dynamic> toJson() {
    return {'contractId': contractId.toString()};
  }
}

/// XDR `MuxedEd25519Account`: an account key plus a 64-bit multiplexing id.
class MuxedEd25519Account extends XDRSerialization {
  final BigInt id;
  final StellarPublicKey ed25519;
  MuxedEd25519Account({required BigInt id, required this.ed25519})
    : id = id.asU64;
  factory MuxedEd25519Account.fromStruct(Map<String, dynamic> json) {
    return MuxedEd25519Account(
      id: json.valueAs('id'),
      ed25519: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ed25519'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'id'),
      StellarPublicKey.layout(property: 'ed25519'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'id': id, 'ed25519': ed25519.toLayoutStruct()};
  }
}

class ScAddressMuxedAccount extends ScAddress {
  final MuxedEd25519Account muxedAccount;
  ScAddressMuxedAccount(this.muxedAccount) : super(ScAddressType.muxedAccount);
  factory ScAddressMuxedAccount.fromAddress(StellarMuxedAddress address) {
    return ScAddressMuxedAccount(
      MuxedEd25519Account(
        id: address.accountId,
        ed25519: address.toAccountAddress().toPublicKey(),
      ),
    );
  }
  factory ScAddressMuxedAccount.fromStruct(Map<String, dynamic> json) {
    return ScAddressMuxedAccount(
      MuxedEd25519Account.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('muxedAccount'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedEd25519Account.layout(property: 'muxedAccount'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'muxedAccount': muxedAccount.toLayoutStruct()};
  }

  @override
  StellarAddress get address => StellarMuxedAddress.fromPublicKey(
    publicKey: muxedAccount.ed25519.toBytes(),
    accountId: muxedAccount.id,
  );
}

class ScAddressClaimableBalance extends ScAddress {
  final ClaimableBalanceId balanceId;
  ScAddressClaimableBalance(this.balanceId)
    : super(ScAddressType.claimableBalance);
  factory ScAddressClaimableBalance.fromStruct(Map<String, dynamic> json) {
    return ScAddressClaimableBalance(
      ClaimableBalanceId.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('balanceId'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ClaimableBalanceId.layout(property: 'balanceId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'balanceId': balanceId.toVariantLayoutStruct()};
  }

  @override
  StellarAddress get address {
    throw const BuError(DefaultErrorType.notFound, 
      'Claimable balance ScAddress has no classic address mapping.',
    );
  }
}

class ScAddressLiquidityPool extends ScAddress {
  final BuBytes liquidityPoolId;
  ScAddressLiquidityPool(List<int> liquidityPoolId)
    : liquidityPoolId =
          liquidityPoolId
              .exc(
                length: StellarConst.hash256Length,
                name: 'liquidityPoolId',
                operation: 'ScAddressLiquidityPool',
                reason: 'Invalid liquidityPoolId bytes length.',
              )
              .asImmutableBytes,
      super(ScAddressType.liquidityPool);
  factory ScAddressLiquidityPool.fromStruct(Map<String, dynamic> json) {
    return ScAddressLiquidityPool(json.valueAs('liquidityPoolId'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'liquidityPoolId',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'liquidityPoolId': liquidityPoolId};
  }

  @override
  StellarAddress get address {
    throw const BuError(DefaultErrorType.notFound, 
      'Liquidity pool ScAddress has no classic address mapping.',
    );
  }
}

/// XDR `MuxedContract` (CAP-84): a contract id plus a 64-bit multiplexing id.
/// Field order is `id`, then `contractId`.
class ScAddressMuxedContract extends ScAddress {
  final BigInt id;
  final StellarContractAddress contractId;
  ScAddressMuxedContract({required BigInt id, required this.contractId})
    : id = id.asU64,
      super(ScAddressType.muxedContract);
  factory ScAddressMuxedContract.fromAddress(
    StellarMuxedContractAddress address,
  ) {
    return ScAddressMuxedContract(
      id: address.id,
      contractId: address.toContractAddress(),
    );
  }
  factory ScAddressMuxedContract.fromContractId({
    required List<int> contractId,
    required BigInt id,
  }) {
    return ScAddressMuxedContract(
      id: id,
      contractId: StellarContractAddress.fromBytes(contractId),
    );
  }
  factory ScAddressMuxedContract.fromBase32Address(String address) {
    return ScAddressMuxedContract.fromAddress(
      StellarMuxedContractAddress(address),
    );
  }
  factory ScAddressMuxedContract.fromStruct(Map<String, dynamic> json) {
    return ScAddressMuxedContract(
      id: json.valueAs('id'),
      contractId: StellarContractAddress.fromBytes(json.valueAs('contractId')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'id'),
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'contractId',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'id': id, 'contractId': contractId.keyBytes()};
  }

  @override
  StellarAddress get address => StellarMuxedContractAddress.fromContractId(
    contractId: contractId.keyBytes(),
    id: id,
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'contractId': contractId.address,
      'muxedAddress': address.baseAddress,
    };
  }
}

class ScValueType {
  final String name;
  final int value;

  const ScValueType._({required this.name, required this.value});
  static const boolType = ScValueType._(name: 'Bool', value: 0);
  static const voidType = ScValueType._(name: 'Void', value: 1);
  static const error = ScValueType._(name: 'Error', value: 2);
  static const u32 = ScValueType._(name: 'U32', value: 3);
  static const i32 = ScValueType._(name: 'I32', value: 4);
  static const u64 = ScValueType._(name: 'U64', value: 5);
  static const i64 = ScValueType._(name: 'I64', value: 6);
  static const timepoint = ScValueType._(name: 'Timepoint', value: 7);
  static const duration = ScValueType._(name: 'Duration', value: 8);
  static const u128 = ScValueType._(name: 'U128', value: 9);
  static const i128 = ScValueType._(name: 'I128', value: 10);
  static const u256 = ScValueType._(name: 'U256', value: 11);
  static const i256 = ScValueType._(name: 'I256', value: 12);
  static const bytes = ScValueType._(name: 'Bytes', value: 13);
  static const string = ScValueType._(name: 'String', value: 14);
  static const symbol = ScValueType._(name: 'Symbol', value: 15);
  static const vec = ScValueType._(name: 'Vec', value: 16);
  static const map = ScValueType._(name: 'Map', value: 17);
  static const address = ScValueType._(name: 'Address', value: 18);
  static const contractInstance = ScValueType._(
    name: 'ContractInstance',
    value: 19,
  );
  static const ledgerKeyContractInstance = ScValueType._(
    name: 'LedgerKeyContractInstance',
    value: 20,
  );
  static const ledgerKeyNonce = ScValueType._(
    name: 'LedgerKeyNonce',
    value: 21,
  );
  static const List<ScValueType> values = [
    boolType,
    voidType,
    error,
    u32,
    i32,
    u64,
    i64,
    timepoint,
    duration,
    u128,
    i128,
    u256,
    i256,
    bytes,
    string,
    symbol,
    vec,
    map,
    address,
    contractInstance,
    ledgerKeyContractInstance,
    ledgerKeyNonce,
  ];
  static ScValueType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ScValue type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ScValueType.$name';
  }
}

abstract class ScVal<T> extends XDRVariantSerialization {
  final ScValueType type;
  final T value;
  const ScVal({required this.type, required this.value});
  factory ScVal.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return ScVal.fromStruct(decode);
  }
  factory ScVal.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ScValueType.fromName(decode.variantName);
    final ScVal val;
    switch (type) {
      case ScValueType.boolType:
        val = ScValBoolean.fromStruct(decode.value);
        break;
      case ScValueType.voidType:
        val = ScValVoid.fromStruct(decode.value);
        break;
      case ScValueType.error:
        val = ScValError.fromStruct(decode.value);
        break;
      case ScValueType.u32:
        val = ScValU32.fromStruct(decode.value);
        break;
      case ScValueType.i32:
        val = ScValI32.fromStruct(decode.value);
        break;
      case ScValueType.u64:
        val = ScValU64.fromStruct(decode.value);
        break;
      case ScValueType.i64:
        val = ScValI64.fromStruct(decode.value);
        break;
      case ScValueType.timepoint:
        val = ScValTimePoint.fromStruct(decode.value);
        break;
      case ScValueType.duration:
        val = ScValDuration.fromStruct(decode.value);
        break;
      case ScValueType.u128:
        val = ScValU128.fromStruct(decode.value);
        break;
      case ScValueType.i128:
        val = ScValI128.fromStruct(decode.value);
        break;
      case ScValueType.u256:
        val = ScValU256.fromStruct(decode.value);
        break;
      case ScValueType.i256:
        val = ScValI256.fromStruct(decode.value);
        break;
      case ScValueType.bytes:
        val = ScValBytes.fromStruct(decode.value);
        break;
      case ScValueType.string:
        val = ScValString.fromStruct(decode.value);
        break;
      case ScValueType.symbol:
        val = ScValSymbol.fromStruct(decode.value);
        break;
      case ScValueType.vec:
        val = ScValVec.fromStruct(decode.value);
        break;
      case ScValueType.map:
        val = ScValMap.fromStruct(decode.value);
        break;
      case ScValueType.address:
        val = ScValAddress.fromStruct(decode.value);
        break;
      case ScValueType.contractInstance:
        val = ScValInstance.fromStruct(decode.value);
        break;
      case ScValueType.ledgerKeyContractInstance:
        val = ScValKeyContractInstance.fromStruct(decode.value);
        break;
      case ScValueType.ledgerKeyNonce:
        val = ScValNonceKey.fromStruct(decode.value);
        break;
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid ScVal type.',
          details: {'type': type.name},
        );
    }
    if (val is! ScVal<T>) {
      throw BuError(DefaultErrorType.castFailed, 
        'Incorrect ScVal type casting.',
        details: {'expected': '$T', 'ScVal': val.runtimeType.toString()},
      );
    }
    return val;
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(ScValueType.values.length, (index) {
        final type = ScValueType.values.elementAt(index);
        switch (type) {
          case ScValueType.boolType:
            return LazyVariantModel(
              index: type.value,
              layout: ScValBoolean.layout,
              property: type.name,
            );
          case ScValueType.voidType:
            return LazyVariantModel(
              index: type.value,
              layout: ScValVoid.layout,
              property: type.name,
            );
          case ScValueType.error:
            return LazyVariantModel(
              index: type.value,
              layout: ScValError.layout,
              property: type.name,
            );
          case ScValueType.u32:
            return LazyVariantModel(
              index: type.value,
              layout: ScValU32.layout,
              property: type.name,
            );
          case ScValueType.i32:
            return LazyVariantModel(
              index: type.value,
              layout: ScValI32.layout,
              property: type.name,
            );
          case ScValueType.u64:
            return LazyVariantModel(
              index: type.value,
              layout: ScValU64.layout,
              property: type.name,
            );
          case ScValueType.i64:
            return LazyVariantModel(
              index: type.value,
              layout: ScValI64.layout,
              property: type.name,
            );
          case ScValueType.timepoint:
            return LazyVariantModel(
              index: type.value,
              layout: ScValTimePoint.layout,
              property: type.name,
            );
          case ScValueType.duration:
            return LazyVariantModel(
              index: type.value,
              layout: ScValDuration.layout,
              property: type.name,
            );
          case ScValueType.u128:
            return LazyVariantModel(
              index: type.value,
              layout: ScValU128.layout,
              property: type.name,
            );
          case ScValueType.i128:
            return LazyVariantModel(
              index: type.value,
              layout: ScValI128.layout,
              property: type.name,
            );
          case ScValueType.u256:
            return LazyVariantModel(
              index: type.value,
              layout: ScValU256.layout,
              property: type.name,
            );
          case ScValueType.i256:
            return LazyVariantModel(
              index: type.value,
              layout: ScValI256.layout,
              property: type.name,
            );
          case ScValueType.bytes:
            return LazyVariantModel(
              index: type.value,
              layout: ScValBytes.layout,
              property: type.name,
            );
          case ScValueType.string:
            return LazyVariantModel(
              index: type.value,
              layout: ScValString.layout,
              property: type.name,
            );
          case ScValueType.symbol:
            return LazyVariantModel(
              index: type.value,
              layout: ScValSymbol.layout,
              property: type.name,
            );
          case ScValueType.vec:
            return LazyVariantModel(
              index: type.value,
              layout: ScValVec.layout,
              property: type.name,
            );
          case ScValueType.map:
            return LazyVariantModel(
              index: type.value,
              layout: ScValMap.layout,
              property: type.name,
            );
          case ScValueType.address:
            return LazyVariantModel(
              index: type.value,
              layout: ScValAddress.layout,
              property: type.name,
            );
          case ScValueType.contractInstance:
            return LazyVariantModel(
              index: type.value,
              layout: ScValInstance.layout,
              property: type.name,
            );
          case ScValueType.ledgerKeyContractInstance:
            return LazyVariantModel(
              index: type.value,
              layout: ScValKeyContractInstance.layout,
              property: type.name,
            );
          case ScValueType.ledgerKeyNonce:
            return LazyVariantModel(
              index: type.value,
              layout: ScValNonceKey.layout,
              property: type.name,
            );
          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid ScVal type.',
              details: {'type': type.name},
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  E cast<E extends ScVal>() {
    if (this is! E) {
      throw BuError(DefaultErrorType.castFailed, 
        'ScVal casting failed.',
        details: {'expected': '$E', 'type': '$runtimeType'},
      );
    }
    return this as E;
  }
}

class ScErrorType {
  final String name;
  final int value;

  const ScErrorType._({required this.name, required this.value});

  static const contract = ScErrorType._(name: 'Contract', value: 0);
  static const wasmVm = ScErrorType._(name: 'WasmVm', value: 1);
  static const context = ScErrorType._(name: 'Context', value: 2);
  static const storage = ScErrorType._(name: 'Storage', value: 3);
  static const object = ScErrorType._(name: 'Object', value: 4);
  static const crypto = ScErrorType._(name: 'Crypto', value: 5);
  static const events = ScErrorType._(name: 'Events', value: 6);
  static const budget = ScErrorType._(name: 'Budget', value: 7);
  static const valueType = ScErrorType._(name: 'Value', value: 8);
  static const auth = ScErrorType._(name: 'Auth', value: 9);
  static const List<ScErrorType> values = [
    contract,
    wasmVm,
    context,
    storage,
    object,
    crypto,
    events,
    budget,
    valueType,
    auth,
  ];
  static ScErrorType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ScError type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ScErrorType.$name';
  }
}

abstract class ScError extends XDRVariantSerialization {
  final ScErrorType type;
  const ScError(this.type);
  factory ScError.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ScErrorType.fromName(decode.variantName);
    switch (type) {
      case ScErrorType.contract:
        return ScErrorContract.fromStruct(decode.value);
      default:
        return ScErrorCode(type);
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be(
      List.generate(ScErrorType.values.length, (index) {
        final type = ScErrorType.values.elementAt(index);
        switch (type) {
          case ScErrorType.contract:
            return ScErrorContract.layout(property: type.name);
          default:
            return ScErrorCode.layout(property: type.name);
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  // @override
  // Layout<T> createLayout({String? property}) {
  //   return LayoutConst.none(property: property) valueAs Layout<T>;
  // }

  @override
  String get variantName => type.name;
}

class ScErrorContract extends ScError {
  final int contractCode;
  ScErrorContract(int contractCode)
    : contractCode = contractCode.asU32,
      super(ScErrorType.contract);
  factory ScErrorContract.fromStruct(Map<String, dynamic> json) {
    return ScErrorContract(json.valueAs('contractCode'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'contractCode'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'contractCode': contractCode};
  }
}

class ScErrorCode extends ScError {
  ScErrorCode._(super.code);
  factory ScErrorCode(ScErrorType code) {
    if (code == ScErrorType.contract) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Use `ScErrorContract` instead `ScErrorCode` for user-defined error code.',
      );
    }
    return ScErrorCode._(code);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class ScValBoolean extends ScVal<bool> {
  ScValBoolean(bool bool) : super(type: ScValueType.boolType, value: bool);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.boolean32Be(property: 'value'),
    ], property: property);
  }

  factory ScValBoolean.fromStruct(Map<String, dynamic> json) {
    return ScValBoolean(json.valueAs('value'));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValError extends ScVal<ScError> {
  ScValError(ScError value) : super(type: ScValueType.error, value: value);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScError.layout(property: 'value'),
    ], property: property);
  }

  factory ScValError.fromStruct(Map<String, dynamic> json) {
    return ScValError(
      ScError.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toVariantLayoutStruct()};
  }
}

class ScValU32 extends ScVal<int> {
  ScValU32(int value) : super(type: ScValueType.u32, value: value.asU32);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'value'),
    ], property: property);
  }

  factory ScValU32.fromStruct(Map<String, dynamic> json) {
    return ScValU32(json.valueAs('value'));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValI32 extends ScVal<int> {
  ScValI32(int value) : super(type: ScValueType.i32, value: value.asI32);
  factory ScValI32.fromStruct(Map<String, dynamic> json) {
    return ScValI32(json.valueAs('value'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValU64 extends ScVal<BigInt> {
  ScValU64(BigInt value) : super(type: ScValueType.u64, value: value.asU64);
  factory ScValU64.fromStruct(Map<String, dynamic> json) {
    return ScValU64(json.valueAs('value'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValI64 extends ScVal<BigInt> {
  ScValI64(BigInt value) : super(type: ScValueType.i64, value: value.asI64);
  factory ScValI64.fromStruct(Map<String, dynamic> json) {
    return ScValI64(json.valueAs('value'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValTimePoint extends ScVal<BigInt> {
  ScValTimePoint(BigInt value)
    : super(type: ScValueType.timepoint, value: value.asU64);
  factory ScValTimePoint.fromStruct(Map<String, dynamic> json) {
    return ScValTimePoint(json.valueAs('value'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class UInt128Parts extends XDRSerialization {
  final BigInt hi;
  final BigInt lo;
  UInt128Parts({required BigInt hi, required BigInt lo})
    : hi = hi.asU64,
      lo = lo.asU64;

  factory UInt128Parts.fromStruct(Map<String, dynamic> json) {
    return UInt128Parts(hi: json.valueAs('hi'), lo: json.valueAs('lo'));
  }
  factory UInt128Parts.fromNumber(BigInt number) {
    if (number.isNegative || number.bitLength > 128) {
      if (number.isNegative) {
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid Unsigned int.',
          details: {'number': number.toString()},
        );
      }
      throw BuError(DefaultErrorType.invalidArgument, 
        'Number is to large for `Int256Parts`',
        details: {'number': number.toString()},
      );
    }
    final BigInt hi = (number >> 64).toUnsigned(64);
    final BigInt lo = number.toUnsigned(64);
    return UInt128Parts(hi: hi, lo: lo);
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'hi'),
      LayoutConst.u64be(property: 'lo'),
    ], property: property);
  }

  BigInt toBigInt() {
    final BigInt part = (hi << 64);
    final BigInt int256 = part | lo;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hi': hi, 'lo': lo};
  }

  @override
  String toString() {
    return toBigInt().toString();
  }
}

class Int128Parts extends XDRSerialization {
  final BigInt hi;
  final BigInt lo;
  Int128Parts({required BigInt hi, required BigInt lo})
    : hi = hi.asI64,
      lo = lo.asU64;
  factory Int128Parts.fromNumber(BigInt number) {
    if (number.bitLength > 128) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Number is to large for `Int256Parts`',
        details: {'number': number.toString()},
      );
    }
    final BigInt hi = (number >> 64).toSigned(64);
    final BigInt lo = number.toUnsigned(64);
    return Int128Parts(hi: hi, lo: lo);
  }
  factory Int128Parts.fromStruct(Map<String, dynamic> json) {
    return Int128Parts(hi: json.valueAs('hi'), lo: json.valueAs('lo'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'hi'),
      LayoutConst.u64be(property: 'lo'),
    ], property: property);
  }

  BigInt toBigInt() {
    final BigInt part = (hi << 64);
    final BigInt int256 = part | lo;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hi': hi, 'lo': lo};
  }

  @override
  String toString() {
    return toBigInt().toString();
  }
}

class UInt256Parts extends XDRSerialization {
  final BigInt hiHi;
  final BigInt hiLo;
  final BigInt loHi;
  final BigInt loLo;
  UInt256Parts({
    required BigInt hiHi,
    required BigInt hiLo,
    required BigInt loHi,
    required BigInt loLo,
  }) : hiHi = hiHi.asU64,
       hiLo = hiLo.asU64,
       loHi = loHi.asU64,
       loLo = loLo.asU64;
  factory UInt256Parts.fromStruct(Map<String, dynamic> json) {
    return UInt256Parts(
      hiHi: json.valueAs('hiHi'),
      hiLo: json.valueAs('hiLo'),
      loHi: json.valueAs('loHi'),
      loLo: json.valueAs('loLo'),
    );
  }
  factory UInt256Parts.fromNumber(BigInt number) {
    if (number.isNegative || number.bitLength > 256) {
      if (number.isNegative) {
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid Unsigned int.',
          details: {'number': number.toString()},
        );
      }
      throw BuError(DefaultErrorType.invalidArgument, 
        'Number is to large for `Int256Parts`',
        details: {'number': number.toString()},
      );
    }
    final BigInt hiHi = (number >> 192).toUnsigned(64);
    final BigInt hiLo = (number >> 128).toUnsigned(64);
    final BigInt loHi = (number >> 64).toUnsigned(64);
    final BigInt loLo = number.toUnsigned(64);
    return UInt256Parts(hiHi: hiHi, hiLo: hiLo, loHi: loHi, loLo: loLo);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'hiHi'),
      LayoutConst.u64be(property: 'hiLo'),
      LayoutConst.u64be(property: 'loHi'),
      LayoutConst.u64be(property: 'loLo'),
    ], property: property);
  }

  BigInt toBigInt() {
    final BigInt part1 = (hiHi << 192);
    final BigInt part2 = (hiLo << 128);
    final BigInt part3 = (loHi << 64);
    final BigInt part4 = loLo;
    final BigInt int256 = part1 | part2 | part3 | part4;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hiHi': hiHi, 'hiLo': hiLo, 'loHi': loHi, 'loLo': loLo};
  }

  @override
  String toString() {
    return toBigInt().toString();
  }
}

class Int256Parts extends XDRSerialization {
  final BigInt hiHi;
  final BigInt hiLo;
  final BigInt loHi;
  final BigInt loLo;
  Int256Parts({
    required BigInt hiHi,
    required BigInt hiLo,
    required BigInt loHi,
    required BigInt loLo,
  }) : hiHi = hiHi.asI64,
       hiLo = hiLo.asU64,
       loHi = loHi.asU64,
       loLo = loLo.asU64;
  factory Int256Parts.fromStruct(Map<String, dynamic> json) {
    return Int256Parts(
      hiHi: json.valueAs('hiHi'),
      hiLo: json.valueAs('hiLo'),
      loHi: json.valueAs('loHi'),
      loLo: json.valueAs('loLo'),
    );
  }
  factory Int256Parts.fromNumber(BigInt number) {
    if (number.bitLength > 256) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Number is to large for `Int256Parts`',
      );
    }
    final BigInt hiHi = (number >> 192).toSigned(64);
    final BigInt hiLo = (number >> 128).toUnsigned(64);
    final BigInt loHi = (number >> 64).toUnsigned(64);
    final BigInt loLo = number.toUnsigned(64);
    return Int256Parts(hiHi: hiHi, hiLo: hiLo, loHi: loHi, loLo: loLo);
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'hiHi'),
      LayoutConst.u64be(property: 'hiLo'),
      LayoutConst.u64be(property: 'loHi'),
      LayoutConst.u64be(property: 'loLo'),
    ], property: property);
  }

  BigInt toBigInt() {
    final BigInt part1 = (hiHi << 192);
    final BigInt part2 = (hiLo << 128);
    final BigInt part3 = (loHi << 64);
    final BigInt part4 = loLo;
    final BigInt int256 = part1 | part2 | part3 | part4;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hiHi': hiHi, 'hiLo': hiLo, 'loHi': loHi, 'loLo': loLo};
  }

  @override
  String toString() {
    return toBigInt().toString();
  }
}

class ScValDuration extends ScVal<BigInt> {
  ScValDuration(BigInt value)
    : super(type: ScValueType.duration, value: value.asU64);
  factory ScValDuration.fromStruct(Map<String, dynamic> json) {
    return ScValDuration(json.valueAs('value'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValU128 extends ScVal<UInt128Parts> {
  ScValU128(UInt128Parts value) : super(type: ScValueType.u128, value: value);
  factory ScValU128.fromNumber(BigInt num) {
    return ScValU128(UInt128Parts.fromNumber(num));
  }
  factory ScValU128.fromStruct(Map<String, dynamic> json) {
    return ScValU128(
      UInt128Parts.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      UInt128Parts.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValI128 extends ScVal<Int128Parts> {
  ScValI128(Int128Parts value) : super(type: ScValueType.i128, value: value);
  factory ScValI128.fromStruct(Map<String, dynamic> json) {
    return ScValI128(
      Int128Parts.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  factory ScValI128.fromNumber(BigInt num) {
    return ScValI128(Int128Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Int128Parts.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValU256 extends ScVal<UInt256Parts> {
  ScValU256(UInt256Parts value) : super(type: ScValueType.u256, value: value);
  factory ScValU256.fromStruct(Map<String, dynamic> json) {
    return ScValU256(
      UInt256Parts.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  factory ScValU256.fromNumber(BigInt num) {
    return ScValU256(UInt256Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      UInt256Parts.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValI256 extends ScVal<Int256Parts> {
  ScValI256(Int256Parts value) : super(type: ScValueType.i256, value: value);
  factory ScValI256.fromStruct(Map<String, dynamic> json) {
    return ScValI256(
      Int256Parts.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  factory ScValI256.fromNumber(BigInt num) {
    return ScValI256(Int256Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Int256Parts.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValBytes extends ScVal<BuBytes> {
  ScValBytes(List<int> bytes)
    : super(type: ScValueType.bytes, value: bytes.asImmutableBytes);
  factory ScValBytes.fromHex(String hexBytes) {
    return ScValBytes(BytesUtils.fromHexString(hexBytes));
  }
  factory ScValBytes.fromStruct(Map<String, dynamic> json) {
    return ScValBytes(json.valueAs('value'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVecBytes(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValString extends ScVal<String> {
  ScValString(String str) : super(type: ScValueType.string, value: str);
  factory ScValString.fromStruct(Map<String, dynamic> json) {
    return ScValString(json.valueAs('value'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScValSymbol extends ScVal<String> {
  ScValSymbol(String sym)
    : super(
        type: ScValueType.symbol,
        value: StellarValidator.validateString(value: sym, max: 32),
      );
  factory ScValSymbol.fromStruct(Map<String, dynamic> json) {
    return ScValSymbol(json.valueAs('value'));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value};
  }
}

class ScMapEntry<K extends ScVal, V extends ScVal> extends XDRSerialization {
  final K key;
  final V value;
  const ScMapEntry(this.key, this.value);
  factory ScMapEntry.fromStruct(Map<String, dynamic> json) {
    return ScMapEntry(
      ScVal.fromStruct(json.valueEnsureAsMap<String, dynamic>('key')) as K,
      ScVal.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')) as V,
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScVal.layout(property: 'key'),
      ScVal.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'key': key.toVariantLayoutStruct(),
      'value': value.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {'key': key.toJson(), 'value': value.toJson()};
  }
}

class ScNonceKey extends XDRSerialization {
  final BigInt nonce;
  ScNonceKey(BigInt nonce) : nonce = nonce.asI64;
  factory ScNonceKey.fromStruct(Map<String, dynamic> json) {
    return ScNonceKey(json.valueAs('nonce'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'nonce'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'nonce': nonce};
  }
}

class ScValVec extends ScVal<List<ScVal>?> {
  ScValVec({List<ScVal>? value})
    : super(type: ScValueType.vec, value: value?.immutable);
  factory ScValVec.fromStruct(Map<String, dynamic> json) {
    return ScValVec(
      value:
          json
              .valueAsList<List<Map<String, dynamic>>?>('value')
              ?.map((e) => ScVal.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(
        LayoutConst.xdrVec(ScVal.layout()),
        property: 'value',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'value':
          value?.map((e) => e.toVariantLayoutStruct()).toList() ?? const [],
    };
  }
}

class ScValMap extends ScVal<List<ScMapEntry>?> {
  ScValMap({List<ScMapEntry>? value})
    : super(type: ScValueType.map, value: value?.immutable);
  factory ScValMap.fromStruct(Map<String, dynamic> json) {
    return ScValMap(
      value:
          json
              .valueAsList<List<Map<String, dynamic>>?>('value')
              ?.map((e) => ScMapEntry.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(
        LayoutConst.xdrVec(ScMapEntry.layout()),
        property: 'value',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'value': value?.map((e) => e.toLayoutStruct()).toList() ?? const [],
    };
  }
}

class ScValAddress extends ScVal<ScAddress> {
  ScValAddress(ScAddress value)
    : super(type: ScValueType.address, value: value);
  factory ScValAddress.fromBase32(String address) {
    return ScValAddress(ScAddress.fromBase32Address(address));
  }
  factory ScValAddress.fromStruct(Map<String, dynamic> json) {
    return ScValAddress(
      ScAddress.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toVariantLayoutStruct()};
  }
}

class ScValNonceKey extends ScVal<ScNonceKey> {
  ScValNonceKey(ScNonceKey value)
    : super(type: ScValueType.ledgerKeyNonce, value: value);
  factory ScValNonceKey.fromStruct(Map<String, dynamic> json) {
    return ScValNonceKey(
      ScNonceKey.fromStruct(json.valueEnsureAsMap<String, dynamic>('value')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScNonceKey.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValInstance extends ScVal<ScContractInstance> {
  ScValInstance(ScContractInstance value)
    : super(type: ScValueType.contractInstance, value: value);

  factory ScValInstance.fromStruct(Map<String, dynamic> json) {
    return ScValInstance(
      ScContractInstance.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('value'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScContractInstance.layout(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'value': value.toLayoutStruct()};
  }
}

class ScValVoid extends ScVal<Null> {
  ScValVoid() : super(type: ScValueType.voidType, value: null);
  factory ScValVoid.fromStruct(Map<String, dynamic> json) {
    return ScValVoid();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class ScValKeyContractInstance extends ScVal<Null> {
  ScValKeyContractInstance()
    : super(type: ScValueType.ledgerKeyContractInstance, value: null);
  factory ScValKeyContractInstance.fromStruct(Map<String, dynamic> json) {
    return ScValKeyContractInstance();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class ContractExecutableType {
  final String name;
  final int value;
  const ContractExecutableType._({required this.name, required this.value});
  static const ContractExecutableType executableWasm = ContractExecutableType._(
    name: 'ExecutableWasm',
    value: 0,
  );
  static const ContractExecutableType executableStellarAsset =
      ContractExecutableType._(name: 'ExecutableStellarAsset', value: 1);
  static const ContractExecutableType executableExternalRef =
      ContractExecutableType._(name: 'ExecutableExternalRef', value: 2);
  static const List<ContractExecutableType> values = [
    executableWasm,
    executableStellarAsset,
    executableExternalRef,
  ];
  static ContractExecutableType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ContractExecutable type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ContractExecutableType.$name';
  }
}

abstract class ContractExecutable extends XDRVariantSerialization {
  final ContractExecutableType type;
  const ContractExecutable(this.type);
  factory ContractExecutable.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ContractExecutableType.fromName(decode.variantName);
    switch (type) {
      case ContractExecutableType.executableStellarAsset:
        return ContractExecutableStellarAsset.fromStruct(decode.value);
      case ContractExecutableType.executableWasm:
        return ContractExecutableWasmHash.fromStruct(decode.value);
      case ContractExecutableType.executableExternalRef:
        return ContractExecutableExternalRef.fromStruct(decode.value);
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid ContractExecutable type.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ContractExecutableWasmHash.layout(
        property: ContractExecutableType.executableWasm.name,
      ),
      ContractExecutableStellarAsset.layout(
        property: ContractExecutableType.executableStellarAsset.name,
      ),
      ContractExecutableExternalRef.layout(
        property: ContractExecutableType.executableExternalRef.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ContractExecutableWasmHash extends ContractExecutable {
  final BuBytes hash;
  ContractExecutableWasmHash(List<int> hash)
    : hash =
          hash
              .exc(
                name: 'hash',
                length: StellarConst.hash256Length,
                operation: "ContractExecutableWasmHash",
                reason: "Invalid hash bytes length.",
              )
              .asImmutableBytes,
      super(ContractExecutableType.executableWasm);
  factory ContractExecutableWasmHash.fromStruct(Map<String, dynamic> json) {
    return ContractExecutableWasmHash(json.valueAs('hash'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'hash': BytesUtils.toHexString(hash, prefix: '0x')};
  }
}

class ContractExecutableStellarAsset extends ContractExecutable {
  ContractExecutableStellarAsset()
    : super(ContractExecutableType.executableStellarAsset);
  factory ContractExecutableStellarAsset.fromStruct(Map<String, dynamic> json) {
    return ContractExecutableStellarAsset();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

/// XDR `ContractExecutableExternalRef` (CAP-85): an executable managed by
/// another contract (`executableOwner`) and referenced by a `tag`.
class ContractExecutableExternalRef extends ContractExecutable {
  final ScAddress executableOwner;
  final String tag;
  ContractExecutableExternalRef({
    required this.executableOwner,
    required this.tag,
  }) : super(ContractExecutableType.executableExternalRef);
  factory ContractExecutableExternalRef.fromStruct(Map<String, dynamic> json) {
    return ContractExecutableExternalRef(
      executableOwner: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('executableOwner'),
      ),
      tag: json.valueAs('tag'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'executableOwner'),
      LayoutConst.xdrString(property: 'tag'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'executableOwner': executableOwner.toVariantLayoutStruct(),
      'tag': tag,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {'executableOwner': executableOwner.address, 'tag': tag};
  }
}

class ScContractInstance extends XDRSerialization {
  final ContractExecutable executable;
  final List<ScMapEntry>? storage;
  ScContractInstance({required this.executable, List<ScMapEntry>? storage})
    : storage = storage?.immutable;
  factory ScContractInstance.fromStruct(Map<String, dynamic> json) {
    return ScContractInstance(
      executable: ContractExecutable.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('executable'),
      ),
      storage:
          json
              .valueAsList<List<Map<String, dynamic>>?>('storage')
              ?.map((e) => ScMapEntry.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractExecutable.layout(property: 'executable'),
      LayoutConst.optionalU32Be(
        LayoutConst.xdrVec(ScMapEntry.layout()),
        property: 'storage',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'executable': executable.toVariantLayoutStruct(),
      'storage': storage?.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'executable': executable.toJson(),
      'storage': storage?.map((e) => e.toJson()).toList(),
    };
  }
}

class ContractDataDurability {
  final String name;
  final int value;
  const ContractDataDurability._({required this.name, required this.value});
  static const ContractDataDurability temporary = ContractDataDurability._(
    name: 'temporary',
    value: 0,
  );
  static const ContractDataDurability persistent = ContractDataDurability._(
    name: 'persistent',
    value: 1,
  );
  static const List<ContractDataDurability> values = [temporary, persistent];
  static ContractDataDurability fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ContractDataDurability not found.',
                details: {
                  'value': value?.toString(),
                  'values': values.map((e) => e.value).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ContractDataDurability.$name';
  }
}

class ContractDataEntry extends LedgerEntryData {
  final ExtentionPointVoid ext;
  final ScAddress contract;
  final ScVal key;
  final ContractDataDurability durability;
  final ScVal val;
  const ContractDataEntry({
    required this.contract,
    required this.key,
    required this.durability,
    required this.val,
    this.ext = const ExtentionPointVoid(),
  }) : super(LedgerEntryType.contractData);
  factory ContractDataEntry.fromStruct(Map<String, dynamic> json) {
    return ContractDataEntry(
      contract: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('contract'),
      ),
      durability: ContractDataDurability.fromValue(json.valueAs('durability')),
      key: ScVal.fromStruct(json.valueEnsureAsMap<String, dynamic>('key')),
      val: ScVal.fromStruct(json.valueEnsureAsMap<String, dynamic>('val')),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      ScAddress.layout(property: 'contract'),
      ScVal.layout(property: 'key'),
      LayoutConst.u32be(property: 'durability'),
      ScVal.layout(property: 'val'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'contract': contract.toVariantLayoutStruct(),
      'key': key.toVariantLayoutStruct(),
      'durability': durability.value,
      'val': val.toVariantLayoutStruct(),
    };
  }
}

class ContractCodeCostInputs extends XDRSerialization {
  final ExtentionPointVoid ext;
  final int nInstructions;
  final int nFunctions;
  final int nGlobals;
  final int nTableEntries;
  final int nTypes;
  final int nDataSegments;
  final int nElemSegments;
  final int nImports;
  final int nExports;
  final int nDataSegmentBytes;
  ContractCodeCostInputs({
    required int nInstructions,
    required int nFunctions,
    required int nGlobals,
    required int nTableEntries,
    required int nTypes,
    required int nDataSegments,
    required int nElemSegments,
    required int nImports,
    required int nExports,
    required int nDataSegmentBytes,
    this.ext = const ExtentionPointVoid(),
  }) : nInstructions = nInstructions.asU32,
       nFunctions = nFunctions.asU32,
       nGlobals = nGlobals.asU32,
       nTableEntries = nTableEntries.asU32,
       nTypes = nTypes.asU32,
       nDataSegments = nDataSegments.asU32,
       nElemSegments = nElemSegments.asU32,
       nImports = nImports.asU32,
       nExports = nExports.asU32,
       nDataSegmentBytes = nDataSegmentBytes.asU32;
  factory ContractCodeCostInputs.fromStruct(Map<String, dynamic> json) {
    return ContractCodeCostInputs(
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      nDataSegmentBytes: json.valueAs('nDataSegmentBytes'),
      nDataSegments: json.valueAs('nDataSegments'),
      nElemSegments: json.valueAs('nElemSegments'),
      nExports: json.valueAs('nExports'),
      nFunctions: json.valueAs('nFunctions'),
      nGlobals: json.valueAs('nGlobals'),
      nImports: json.valueAs('nImports'),
      nInstructions: json.valueAs('nInstructions'),
      nTableEntries: json.valueAs('nTableEntries'),
      nTypes: json.valueAs('nTypes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      LayoutConst.u32be(property: 'nInstructions'),
      LayoutConst.u32be(property: 'nFunctions'),
      LayoutConst.u32be(property: 'nGlobals'),
      LayoutConst.u32be(property: 'nTableEntries'),
      LayoutConst.u32be(property: 'nTypes'),
      LayoutConst.u32be(property: 'nDataSegments'),
      LayoutConst.u32be(property: 'nElemSegments'),
      LayoutConst.u32be(property: 'nImports'),
      LayoutConst.u32be(property: 'nExports'),
      LayoutConst.u32be(property: 'nDataSegmentBytes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'nInstructions': nInstructions,
      'nFunctions': nFunctions,
      'nGlobals': nGlobals,
      'nTableEntries': nTableEntries,
      'nTypes': nTypes,
      'nElemSegments': nElemSegments,
      'nDataSegments': nDataSegments,
      'nImports': nImports,
      'nDataSegmentBytes': nDataSegmentBytes,
      'nExports': nExports,
    };
  }
}

class ContractCodeEntryV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final ContractCodeCostInputs costInputs;
  const ContractCodeEntryV1({
    required this.costInputs,
    this.ext = const ExtentionPointVoid(),
  });
  factory ContractCodeEntryV1.fromStruct(Map<String, dynamic> json) {
    return ContractCodeEntryV1(
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      costInputs: ContractCodeCostInputs.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('costInputs'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      ContractCodeCostInputs.layout(property: 'costInputs'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'costInputs': costInputs.toLayoutStruct(),
    };
  }
}

class ContractCodeEntryExt extends XDRVariantSerialization {
  final ContractCodeEntryV1? v1;
  const ContractCodeEntryExt({this.v1});
  factory ContractCodeEntryExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const ContractCodeEntryExt();
      case ExtensionPointType.extArgs1:
        return ContractCodeEntryExt(
          v1: ContractCodeEntryV1.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid ContractCodeEntry extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: ContractCodeEntryV1.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v1 != null) {
      return ContractCodeEntryV1.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v1?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v1 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }
}

class ContractCodeEntry extends LedgerEntryData {
  final ContractCodeEntryExt ext;
  final BuBytes hash;
  final BuBytes code;
  ContractCodeEntry({
    required this.ext,
    required List<int> hash,
    required List<int> code,
  }) : code = code.asImmutableBytes,
       hash =
           hash
               .exc(
                 name: 'hash',
                 length: StellarConst.hash256Length,
                 operation: "ContractCodeEntry",
                 reason: "Invalid hash bytes length.",
               )
               .asImmutableBytes,
       super(LedgerEntryType.contractCode);
  factory ContractCodeEntry.fromStruct(Map<String, dynamic> json) {
    return ContractCodeEntry(
      code: json.valueAs('code'),
      ext: ContractCodeEntryExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      hash: json.valueAs('hash'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractCodeEntryExt.layout(property: 'ext'),
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
      LayoutConst.xdrVecBytes(property: 'code'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash, 'code': code, 'ext': ext.toVariantLayoutStruct()};
  }
}

class ConfigSettingId {
  final String name;
  final int value;

  const ConfigSettingId._({required this.name, required this.value});

  static const contractMaxSizeBytes = ConfigSettingId._(
    name: 'ContractMaxSizeBytes',
    value: 0,
  );
  static const contractComputeV0 = ConfigSettingId._(
    name: 'ContractComputeV0',
    value: 1,
  );
  static const contractLedgerCostV0 = ConfigSettingId._(
    name: 'ContractLedgerCostV0',
    value: 2,
  );
  static const contractHistoricalDataV0 = ConfigSettingId._(
    name: 'ContractHistoricalDataV0',
    value: 3,
  );
  static const contractEventsV0 = ConfigSettingId._(
    name: 'ContractEventsV0',
    value: 4,
  );
  static const contractBandwidthV0 = ConfigSettingId._(
    name: 'ContractBandwidthV0',
    value: 5,
  );
  static const contractCostParamsCpuInstructions = ConfigSettingId._(
    name: 'ContractCostParamsCpuInstructions',
    value: 6,
  );
  static const contractCostParamsMemoryBytes = ConfigSettingId._(
    name: 'ContractCostParamsMemoryBytes',
    value: 7,
  );
  static const contractDataKeySizeBytes = ConfigSettingId._(
    name: 'ContractDataKeySizeBytes',
    value: 8,
  );
  static const contractDataEntrySizeBytes = ConfigSettingId._(
    name: 'ContractDataEntrySizeBytes',
    value: 9,
  );
  static const stateArchival = ConfigSettingId._(
    name: 'StateArchival',
    value: 10,
  );
  static const contractExecutionLanes = ConfigSettingId._(
    name: 'ContractExecutionLanes',
    value: 11,
  );
  static const bucketlistSizeWindow = ConfigSettingId._(
    name: 'BucketlistSizeWindow',
    value: 12,
  );
  static const evictionIterator = ConfigSettingId._(
    name: 'EvictionIterator',
    value: 13,
  );
  static const List<ConfigSettingId> values = [
    contractMaxSizeBytes,
    contractComputeV0,
    contractLedgerCostV0,
    contractHistoricalDataV0,
    contractEventsV0,
    contractBandwidthV0,
    contractCostParamsCpuInstructions,
    contractCostParamsMemoryBytes,
    contractDataKeySizeBytes,
    contractDataEntrySizeBytes,
    stateArchival,
    contractExecutionLanes,
    bucketlistSizeWindow,
    evictionIterator,
  ];
  static ConfigSettingId fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ConfigSettingId not found.',
                details: {
                  'value': value?.toString(),
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  static ConfigSettingId fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ConfigSettingId not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ConfigSettingId.$name';
  }
}

class ConfigSettingEntry extends LedgerEntryData {
  final ConfigSetting configSetting;
  ConfigSettingEntry(this.configSetting) : super(LedgerEntryType.configSetting);
  factory ConfigSettingEntry.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingEntry(
      ConfigSetting.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('configSetting'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ConfigSetting.layout(property: 'configSetting'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'configSetting': configSetting.toVariantLayoutStruct()};
  }
}

abstract class ConfigSetting extends XDRVariantSerialization {
  final ConfigSettingId settingId;
  const ConfigSetting(this.settingId);

  factory ConfigSetting.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ConfigSettingId.fromName(decode.variantName);
    switch (type) {
      case ConfigSettingId.contractMaxSizeBytes:
        return ConfigSettingContractMaxSizeBytes.fromStruct(decode.value);
      case ConfigSettingId.contractComputeV0:
        return ConfigSettingContractComputeV0.fromStruct(decode.value);
      case ConfigSettingId.contractLedgerCostV0:
        return ConfigSettingContractLedgerCostV0.fromStruct(decode.value);
      case ConfigSettingId.contractHistoricalDataV0:
        return ConfigSettingContractHistoricalDataV0.fromStruct(decode.value);

      case ConfigSettingId.contractEventsV0:
        return ConfigSettingContractEventsV0.fromStruct(decode.value);
      case ConfigSettingId.contractBandwidthV0:
        return ConfigSettingContractBandwidthV0.fromStruct(decode.value);

      case ConfigSettingId.contractCostParamsCpuInstructions:
        return ConfigSettingContractCostParamsCpuInstructions.fromStruct(
          decode.value,
        );

      case ConfigSettingId.contractCostParamsMemoryBytes:
        return ConfigSettingContractCostParamsMemoryBytes.fromStruct(
          decode.value,
        );

      case ConfigSettingId.contractDataKeySizeBytes:
        return ConfigSettingContractDataKeySizeBytes.fromStruct(decode.value);
      case ConfigSettingId.contractDataEntrySizeBytes:
        return ConfigSettingContractDataEntrySizeBytes.fromStruct(decode.value);
      case ConfigSettingId.stateArchival:
        return ConfigSettingContractStateArchivalSettings.fromStruct(
          decode.value,
        );

      case ConfigSettingId.contractExecutionLanes:
        return ConfigSettingContractExecutionLanesV0.fromStruct(decode.value);
      case ConfigSettingId.bucketlistSizeWindow:
        return ConfigSettingBucketlistSizeWindow.fromStruct(decode.value);

      case ConfigSettingId.evictionIterator:
        return ConfigSettingEvictionIterator.fromStruct(decode.value);

      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid ConfigSettingId.',
          details: {'ConfigSettingId': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(ConfigSettingId.values.length, (index) {
        final type = ConfigSettingId.values.elementAt(index);
        switch (type) {
          case ConfigSettingId.contractMaxSizeBytes:
            return LazyVariantModel(
              layout: ConfigSettingContractMaxSizeBytes.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractComputeV0:
            return LazyVariantModel(
              layout: ConfigSettingContractComputeV0.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractLedgerCostV0:
            return LazyVariantModel(
              layout: ConfigSettingContractLedgerCostV0.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractHistoricalDataV0:
            return LazyVariantModel(
              layout: ConfigSettingContractHistoricalDataV0.layout,
              property: type.name,
              index: type.value,
            );

          case ConfigSettingId.contractEventsV0:
            return LazyVariantModel(
              layout: ConfigSettingContractEventsV0.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractBandwidthV0:
            return LazyVariantModel(
              layout: ConfigSettingContractBandwidthV0.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractCostParamsCpuInstructions:
            return LazyVariantModel(
              layout: ConfigSettingContractCostParamsCpuInstructions.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractCostParamsMemoryBytes:
            return LazyVariantModel(
              layout: ConfigSettingContractCostParamsMemoryBytes.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractDataKeySizeBytes:
            return LazyVariantModel(
              layout: ConfigSettingContractDataKeySizeBytes.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractDataEntrySizeBytes:
            return LazyVariantModel(
              layout: ConfigSettingContractDataEntrySizeBytes.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.stateArchival:
            return LazyVariantModel(
              layout: ConfigSettingContractStateArchivalSettings.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.contractExecutionLanes:
            return LazyVariantModel(
              layout: ConfigSettingContractExecutionLanesV0.layout,
              property: type.name,
              index: type.value,
            );
          case ConfigSettingId.bucketlistSizeWindow:
            return LazyVariantModel(
              layout: ConfigSettingBucketlistSizeWindow.layout,
              property: type.name,
              index: type.value,
            );

          case ConfigSettingId.evictionIterator:
            return LazyVariantModel(
              layout: ConfigSettingEvictionIterator.layout,
              property: type.name,
              index: type.value,
            );
          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid ConfigSettingId.',
              details: {'ConfigSettingId': type.name},
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => settingId.name;
}

class ConfigSettingContractMaxSizeBytes extends ConfigSetting {
  final int contractMaxSizeBytes;
  ConfigSettingContractMaxSizeBytes(int contractMaxSizeBytes)
    : contractMaxSizeBytes = contractMaxSizeBytes.asU32,
      super(ConfigSettingId.contractMaxSizeBytes);
  factory ConfigSettingContractMaxSizeBytes.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractMaxSizeBytes(
      json.valueAs('contractMaxSizeBytes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'contractMaxSizeBytes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'contractMaxSizeBytes': contractMaxSizeBytes};
  }
}

class ConfigSettingContractComputeV0 extends ConfigSetting {
  /// Maximum instructions per ledger
  final BigInt ledgerMaxInstructions;

  /// Maximum instructions per transactio
  final BigInt txMaxInstructions;

  /// Cost of 10000 instructions
  final BigInt feeRatePerInstructionsIncrement;

  /// Memory limit per transaction. Unlike instructions, there is no fee
  /// for memory, just the limit.
  final int txMemoryLimit;
  ConfigSettingContractComputeV0({
    required BigInt ledgerMaxInstructions,
    required BigInt txMaxInstructions,
    required BigInt feeRatePerInstructionsIncrement,
    required int txMemoryLimit,
  }) : ledgerMaxInstructions = ledgerMaxInstructions.asI64,
       txMaxInstructions = txMaxInstructions.asI64,
       feeRatePerInstructionsIncrement = feeRatePerInstructionsIncrement.asI64,
       txMemoryLimit = txMemoryLimit.asU32,
       super(ConfigSettingId.contractComputeV0);
  factory ConfigSettingContractComputeV0.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingContractComputeV0(
      feeRatePerInstructionsIncrement: json.valueAs(
        'feeRatePerInstructionsIncrement',
      ),
      ledgerMaxInstructions: json.valueAs('ledgerMaxInstructions'),
      txMaxInstructions: json.valueAs('txMaxInstructions'),
      txMemoryLimit: json.valueAs('txMemoryLimit'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'ledgerMaxInstructions'),
      LayoutConst.s64be(property: 'txMaxInstructions'),
      LayoutConst.s64be(property: 'feeRatePerInstructionsIncrement'),
      LayoutConst.u32be(property: 'txMemoryLimit'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'txMaxInstructions': txMaxInstructions,
      'ledgerMaxInstructions': ledgerMaxInstructions,
      'feeRatePerInstructionsIncrement': feeRatePerInstructionsIncrement,
      'txMemoryLimit': txMemoryLimit,
    };
  }
}

/// Ledger access settings for contracts.
class ConfigSettingContractLedgerCostV0 extends ConfigSetting {
  /// Maximum number of ledger entry read operations per ledger
  final int ledgerMaxReadLedgerEntries;

  /// Maximum number of bytes that can be read per ledger
  final int ledgerMaxReadBytes;

  /// Maximum number of ledger entry write operations per ledger
  final int ledgerMaxWriteLedgerEntries;

  /// Maximum number of bytes that can be written per ledger
  final int ledgerMaxWriteBytes;

  /// Maximum number of ledger entry read operations per transaction
  final int txMaxReadLedgerEntries;

  /// Maximum number of bytes that can be read per transaction
  final int txMaxReadBytes;

  /// Maximum number of ledger entry write operations per transaction
  final int txMaxWriteLedgerEntries;

  /// Maximum number of bytes that can be written per transaction
  final int txMaxWriteBytes;

  /// Fee per ledger entry read
  final BigInt feeReadLedgerEntry;

  /// Fee per ledger entry write
  final BigInt feeWriteLedgerEntry;

  /// Fee for reading 1KB
  final BigInt feeRead1Kb;

  /// The following parameters determine the write fee per 1KB.
  /// Write fee grows linearly until bucket list reaches this size
  final BigInt bucketListTargetSizeBytes;

  /// Fee per 1KB write when the bucket list is empty
  final BigInt writeFee1KbBucketListLow;

  /// Fee per 1KB write when the bucket list has reached [bucketListTargetSizeBytes]
  final BigInt writeFee1KbBucketListHigh;

  /// Write fee multiplier for any additional data past the first `bucketListTargetSizeBytes`
  final int bucketListWriteFeeGrowthFactor;
  ConfigSettingContractLedgerCostV0({
    required int ledgerMaxReadLedgerEntries,
    required int ledgerMaxReadBytes,
    required int ledgerMaxWriteLedgerEntries,
    required int ledgerMaxWriteBytes,
    required int txMaxReadLedgerEntries,
    required int txMaxReadBytes,
    required int txMaxWriteLedgerEntries,
    required int txMaxWriteBytes,
    required BigInt feeReadLedgerEntry,
    required BigInt feeWriteLedgerEntry,
    required BigInt feeRead1Kb,
    required BigInt bucketListTargetSizeBytes,
    required BigInt writeFee1KbBucketListLow,
    required BigInt writeFee1KbBucketListHigh,
    required int bucketListWriteFeeGrowthFactor,
  }) : ledgerMaxReadLedgerEntries = ledgerMaxReadLedgerEntries.asU32,
       ledgerMaxReadBytes = ledgerMaxReadBytes.asU32,
       ledgerMaxWriteLedgerEntries = ledgerMaxWriteLedgerEntries.asU32,
       ledgerMaxWriteBytes = ledgerMaxWriteBytes.asU32,
       txMaxReadLedgerEntries = txMaxReadLedgerEntries.asU32,
       txMaxReadBytes = txMaxReadBytes.asU32,
       txMaxWriteLedgerEntries = txMaxWriteLedgerEntries.asU32,
       txMaxWriteBytes = txMaxWriteBytes.asU32,
       feeReadLedgerEntry = feeReadLedgerEntry.asI64,
       feeWriteLedgerEntry = feeWriteLedgerEntry.asI64,
       feeRead1Kb = feeRead1Kb.asI64,
       bucketListTargetSizeBytes = bucketListTargetSizeBytes.asI64,
       writeFee1KbBucketListLow = writeFee1KbBucketListLow.asI64,
       writeFee1KbBucketListHigh = writeFee1KbBucketListHigh.asI64,
       bucketListWriteFeeGrowthFactor = bucketListWriteFeeGrowthFactor.asU32,
       super(ConfigSettingId.contractLedgerCostV0);
  factory ConfigSettingContractLedgerCostV0.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractLedgerCostV0(
      bucketListTargetSizeBytes: json.valueAs('bucketListTargetSizeBytes'),
      bucketListWriteFeeGrowthFactor: json.valueAs(
        'bucketListWriteFeeGrowthFactor',
      ),
      feeRead1Kb: json.valueAs('feeRead1Kb'),
      feeReadLedgerEntry: json.valueAs('feeReadLedgerEntry'),
      feeWriteLedgerEntry: json.valueAs('feeWriteLedgerEntry'),
      ledgerMaxReadBytes: json.valueAs('ledgerMaxReadBytes'),
      ledgerMaxReadLedgerEntries: json.valueAs('ledgerMaxReadLedgerEntries'),
      ledgerMaxWriteBytes: json.valueAs('ledgerMaxWriteBytes'),
      ledgerMaxWriteLedgerEntries: json.valueAs('ledgerMaxWriteLedgerEntries'),
      txMaxReadBytes: json.valueAs('txMaxReadBytes'),
      txMaxReadLedgerEntries: json.valueAs('txMaxReadLedgerEntries'),
      txMaxWriteBytes: json.valueAs('txMaxWriteBytes'),
      txMaxWriteLedgerEntries: json.valueAs('txMaxWriteLedgerEntries'),
      writeFee1KbBucketListHigh: json.valueAs('writeFee1KbBucketListHigh'),
      writeFee1KbBucketListLow: json.valueAs('writeFee1KbBucketListLow'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'ledgerMaxReadLedgerEntries'),
      LayoutConst.u32be(property: 'ledgerMaxReadBytes'),
      LayoutConst.u32be(property: 'ledgerMaxWriteLedgerEntries'),
      LayoutConst.u32be(property: 'ledgerMaxWriteBytes'),
      LayoutConst.u32be(property: 'txMaxReadLedgerEntries'),
      LayoutConst.u32be(property: 'txMaxReadBytes'),
      LayoutConst.u32be(property: 'txMaxWriteLedgerEntries'),
      LayoutConst.u32be(property: 'txMaxWriteBytes'),
      LayoutConst.s64be(property: 'feeReadLedgerEntry'),
      LayoutConst.s64be(property: 'feeWriteLedgerEntry'),
      LayoutConst.s64be(property: 'feeRead1Kb'),
      LayoutConst.s64be(property: 'bucketListTargetSizeBytes'),
      LayoutConst.s64be(property: 'writeFee1KbBucketListLow'),
      LayoutConst.s64be(property: 'writeFee1KbBucketListHigh'),
      LayoutConst.u32be(property: 'bucketListWriteFeeGrowthFactor'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ledgerMaxReadLedgerEntries': ledgerMaxReadLedgerEntries,
      'ledgerMaxReadBytes': ledgerMaxReadBytes,
      'ledgerMaxWriteLedgerEntries': ledgerMaxWriteLedgerEntries,
      'ledgerMaxWriteBytes': ledgerMaxWriteBytes,
      'txMaxReadLedgerEntries': txMaxReadLedgerEntries,
      'txMaxReadBytes': txMaxReadBytes,
      'txMaxWriteLedgerEntries': txMaxWriteLedgerEntries,
      'txMaxWriteBytes': txMaxWriteBytes,
      'feeReadLedgerEntry': feeReadLedgerEntry,
      'feeWriteLedgerEntry': feeWriteLedgerEntry,
      'feeRead1Kb': feeRead1Kb,
      'bucketListTargetSizeBytes': bucketListTargetSizeBytes,
      'writeFee1KbBucketListLow': writeFee1KbBucketListLow,
      'writeFee1KbBucketListHigh': writeFee1KbBucketListHigh,
      'bucketListWriteFeeGrowthFactor': bucketListWriteFeeGrowthFactor,
    };
  }
}

/// Historical data (pushed to core archives) settings for contracts.
class ConfigSettingContractHistoricalDataV0 extends ConfigSetting {
  /// Fee for storing 1KB in archives
  final BigInt feeHistorical1Kb;
  ConfigSettingContractHistoricalDataV0(BigInt feeHistorical1Kb)
    : feeHistorical1Kb = feeHistorical1Kb.asI64,
      super(ConfigSettingId.contractHistoricalDataV0);
  factory ConfigSettingContractHistoricalDataV0.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractHistoricalDataV0(
      json.valueAs('feeHistorical1Kb'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: 'feeHistorical1Kb'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'feeHistorical1Kb': feeHistorical1Kb};
  }
}

/// Contract event-related settings.
class ConfigSettingContractEventsV0 extends ConfigSetting {
  ///  Maximum size of events that a contract call can emit.
  final int txMaxContractEventsSizeBytes;

  /// Fee for generating 1KB of contract events.
  final BigInt feeContractEvents1Kb;
  ConfigSettingContractEventsV0({
    required int txMaxContractEventsSizeBytes,
    required BigInt feeContractEvents1Kb,
  }) : txMaxContractEventsSizeBytes = txMaxContractEventsSizeBytes.asU32,
       feeContractEvents1Kb = feeContractEvents1Kb.asI64,
       super(ConfigSettingId.contractEventsV0);
  factory ConfigSettingContractEventsV0.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingContractEventsV0(
      feeContractEvents1Kb: json.valueAs('feeContractEvents1Kb'),
      txMaxContractEventsSizeBytes: json.valueAs(
        'txMaxContractEventsSizeBytes',
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'txMaxContractEventsSizeBytes'),
      LayoutConst.s64be(property: 'feeContractEvents1Kb'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'txMaxContractEventsSizeBytes': txMaxContractEventsSizeBytes,
      'feeContractEvents1Kb': feeContractEvents1Kb,
    };
  }
}

/// Bandwidth related data settings for contracts.
/// We consider bandwidth to only be consumed by the transaction envelopes, hence
/// this concerns only transaction sizes.
class ConfigSettingContractBandwidthV0 extends ConfigSetting {
  /// Maximum sum of all transaction sizes in the ledger in bytes
  final int ledgerMaxTxsSizeBytes;

  /// Maximum size in bytes for a transaction
  final int txMaxSizeBytes;

  /// Fee for 1 KB of transaction size
  final BigInt feeTxSize1Kb;
  ConfigSettingContractBandwidthV0({
    required int ledgerMaxTxsSizeBytes,
    required int txMaxSizeBytes,
    required BigInt feeTxSize1Kb,
  }) : ledgerMaxTxsSizeBytes = ledgerMaxTxsSizeBytes.asU32,
       txMaxSizeBytes = txMaxSizeBytes.asU32,
       feeTxSize1Kb = feeTxSize1Kb.asI64,
       super(ConfigSettingId.contractBandwidthV0);
  factory ConfigSettingContractBandwidthV0.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractBandwidthV0(
      feeTxSize1Kb: json.valueAs('feeTxSize1Kb'),
      ledgerMaxTxsSizeBytes: json.valueAs('ledgerMaxTxsSizeBytes'),
      txMaxSizeBytes: json.valueAs('txMaxSizeBytes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'ledgerMaxTxsSizeBytes'),
      LayoutConst.u32be(property: 'txMaxSizeBytes'),
      LayoutConst.s64be(property: 'feeTxSize1Kb'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ledgerMaxTxsSizeBytes': ledgerMaxTxsSizeBytes,
      'txMaxSizeBytes': txMaxSizeBytes,
      'feeTxSize1Kb': feeTxSize1Kb,
    };
  }
}

/// XDR `ContractCostType` (stellar-xdr v30.0, 95 entries).
/// Indexes the per-cost-type calibration rows in
/// `ConfigSettingContractCostParams*` entries.
class ContractCostType {
  final String name;
  final int value;
  const ContractCostType._({required this.name, required this.value});

  static const wasmInsnExec = ContractCostType._(
    name: 'WasmInsnExec',
    value: 0,
  );
  static const memAlloc = ContractCostType._(name: 'MemAlloc', value: 1);
  static const memCpy = ContractCostType._(name: 'MemCpy', value: 2);
  static const memCmp = ContractCostType._(name: 'MemCmp', value: 3);
  static const dispatchHostFunction = ContractCostType._(
    name: 'DispatchHostFunction',
    value: 4,
  );
  static const visitObject = ContractCostType._(name: 'VisitObject', value: 5);
  static const valSer = ContractCostType._(name: 'ValSer', value: 6);
  static const valDeser = ContractCostType._(name: 'ValDeser', value: 7);
  static const computeSha256Hash = ContractCostType._(
    name: 'ComputeSha256Hash',
    value: 8,
  );
  static const computeEd25519PubKey = ContractCostType._(
    name: 'ComputeEd25519PubKey',
    value: 9,
  );
  static const verifyEd25519Sig = ContractCostType._(
    name: 'VerifyEd25519Sig',
    value: 10,
  );
  static const vmInstantiation = ContractCostType._(
    name: 'VmInstantiation',
    value: 11,
  );
  static const vmCachedInstantiation = ContractCostType._(
    name: 'VmCachedInstantiation',
    value: 12,
  );
  static const invokeVmFunction = ContractCostType._(
    name: 'InvokeVmFunction',
    value: 13,
  );
  static const computeKeccak256Hash = ContractCostType._(
    name: 'ComputeKeccak256Hash',
    value: 14,
  );
  static const decodeEcdsaCurve256Sig = ContractCostType._(
    name: 'DecodeEcdsaCurve256Sig',
    value: 15,
  );
  static const recoverEcdsaSecp256k1Key = ContractCostType._(
    name: 'RecoverEcdsaSecp256k1Key',
    value: 16,
  );
  static const int256AddSub = ContractCostType._(
    name: 'Int256AddSub',
    value: 17,
  );
  static const int256Mul = ContractCostType._(name: 'Int256Mul', value: 18);
  static const int256Div = ContractCostType._(name: 'Int256Div', value: 19);
  static const int256Pow = ContractCostType._(name: 'Int256Pow', value: 20);
  static const int256Shift = ContractCostType._(name: 'Int256Shift', value: 21);
  static const chaCha20DrawBytes = ContractCostType._(
    name: 'ChaCha20DrawBytes',
    value: 22,
  );
  static const parseWasmInstructions = ContractCostType._(
    name: 'ParseWasmInstructions',
    value: 23,
  );
  static const parseWasmFunctions = ContractCostType._(
    name: 'ParseWasmFunctions',
    value: 24,
  );
  static const parseWasmGlobals = ContractCostType._(
    name: 'ParseWasmGlobals',
    value: 25,
  );
  static const parseWasmTableEntries = ContractCostType._(
    name: 'ParseWasmTableEntries',
    value: 26,
  );
  static const parseWasmTypes = ContractCostType._(
    name: 'ParseWasmTypes',
    value: 27,
  );
  static const parseWasmDataSegments = ContractCostType._(
    name: 'ParseWasmDataSegments',
    value: 28,
  );
  static const parseWasmElemSegments = ContractCostType._(
    name: 'ParseWasmElemSegments',
    value: 29,
  );
  static const parseWasmImports = ContractCostType._(
    name: 'ParseWasmImports',
    value: 30,
  );
  static const parseWasmExports = ContractCostType._(
    name: 'ParseWasmExports',
    value: 31,
  );
  static const parseWasmDataSegmentBytes = ContractCostType._(
    name: 'ParseWasmDataSegmentBytes',
    value: 32,
  );
  static const instantiateWasmInstructions = ContractCostType._(
    name: 'InstantiateWasmInstructions',
    value: 33,
  );
  static const instantiateWasmFunctions = ContractCostType._(
    name: 'InstantiateWasmFunctions',
    value: 34,
  );
  static const instantiateWasmGlobals = ContractCostType._(
    name: 'InstantiateWasmGlobals',
    value: 35,
  );
  static const instantiateWasmTableEntries = ContractCostType._(
    name: 'InstantiateWasmTableEntries',
    value: 36,
  );
  static const instantiateWasmTypes = ContractCostType._(
    name: 'InstantiateWasmTypes',
    value: 37,
  );
  static const instantiateWasmDataSegments = ContractCostType._(
    name: 'InstantiateWasmDataSegments',
    value: 38,
  );
  static const instantiateWasmElemSegments = ContractCostType._(
    name: 'InstantiateWasmElemSegments',
    value: 39,
  );
  static const instantiateWasmImports = ContractCostType._(
    name: 'InstantiateWasmImports',
    value: 40,
  );
  static const instantiateWasmExports = ContractCostType._(
    name: 'InstantiateWasmExports',
    value: 41,
  );
  static const instantiateWasmDataSegmentBytes = ContractCostType._(
    name: 'InstantiateWasmDataSegmentBytes',
    value: 42,
  );
  static const sec1DecodePointUncompressed = ContractCostType._(
    name: 'Sec1DecodePointUncompressed',
    value: 43,
  );
  static const verifyEcdsaSecp256r1Sig = ContractCostType._(
    name: 'VerifyEcdsaSecp256r1Sig',
    value: 44,
  );
  static const bls12381EncodeFp = ContractCostType._(
    name: 'Bls12381EncodeFp',
    value: 45,
  );
  static const bls12381DecodeFp = ContractCostType._(
    name: 'Bls12381DecodeFp',
    value: 46,
  );
  static const bls12381G1CheckPointOnCurve = ContractCostType._(
    name: 'Bls12381G1CheckPointOnCurve',
    value: 47,
  );
  static const bls12381G1CheckPointInSubgroup = ContractCostType._(
    name: 'Bls12381G1CheckPointInSubgroup',
    value: 48,
  );
  static const bls12381G2CheckPointOnCurve = ContractCostType._(
    name: 'Bls12381G2CheckPointOnCurve',
    value: 49,
  );
  static const bls12381G2CheckPointInSubgroup = ContractCostType._(
    name: 'Bls12381G2CheckPointInSubgroup',
    value: 50,
  );
  static const bls12381G1ProjectiveToAffine = ContractCostType._(
    name: 'Bls12381G1ProjectiveToAffine',
    value: 51,
  );
  static const bls12381G2ProjectiveToAffine = ContractCostType._(
    name: 'Bls12381G2ProjectiveToAffine',
    value: 52,
  );
  static const bls12381G1Add = ContractCostType._(
    name: 'Bls12381G1Add',
    value: 53,
  );
  static const bls12381G1Mul = ContractCostType._(
    name: 'Bls12381G1Mul',
    value: 54,
  );
  static const bls12381G1Msm = ContractCostType._(
    name: 'Bls12381G1Msm',
    value: 55,
  );
  static const bls12381MapFpToG1 = ContractCostType._(
    name: 'Bls12381MapFpToG1',
    value: 56,
  );
  static const bls12381HashToG1 = ContractCostType._(
    name: 'Bls12381HashToG1',
    value: 57,
  );
  static const bls12381G2Add = ContractCostType._(
    name: 'Bls12381G2Add',
    value: 58,
  );
  static const bls12381G2Mul = ContractCostType._(
    name: 'Bls12381G2Mul',
    value: 59,
  );
  static const bls12381G2Msm = ContractCostType._(
    name: 'Bls12381G2Msm',
    value: 60,
  );
  static const bls12381MapFp2ToG2 = ContractCostType._(
    name: 'Bls12381MapFp2ToG2',
    value: 61,
  );
  static const bls12381HashToG2 = ContractCostType._(
    name: 'Bls12381HashToG2',
    value: 62,
  );
  static const bls12381Pairing = ContractCostType._(
    name: 'Bls12381Pairing',
    value: 63,
  );
  static const bls12381FrFromU256 = ContractCostType._(
    name: 'Bls12381FrFromU256',
    value: 64,
  );
  static const bls12381FrToU256 = ContractCostType._(
    name: 'Bls12381FrToU256',
    value: 65,
  );
  static const bls12381FrAddSub = ContractCostType._(
    name: 'Bls12381FrAddSub',
    value: 66,
  );
  static const bls12381FrMul = ContractCostType._(
    name: 'Bls12381FrMul',
    value: 67,
  );
  static const bls12381FrPow = ContractCostType._(
    name: 'Bls12381FrPow',
    value: 68,
  );
  static const bls12381FrInv = ContractCostType._(
    name: 'Bls12381FrInv',
    value: 69,
  );
  static const bn254EncodeFp = ContractCostType._(
    name: 'Bn254EncodeFp',
    value: 70,
  );
  static const bn254DecodeFp = ContractCostType._(
    name: 'Bn254DecodeFp',
    value: 71,
  );
  static const bn254G1CheckPointOnCurve = ContractCostType._(
    name: 'Bn254G1CheckPointOnCurve',
    value: 72,
  );
  static const bn254G2CheckPointOnCurve = ContractCostType._(
    name: 'Bn254G2CheckPointOnCurve',
    value: 73,
  );
  static const bn254G2CheckPointInSubgroup = ContractCostType._(
    name: 'Bn254G2CheckPointInSubgroup',
    value: 74,
  );
  static const bn254G1ProjectiveToAffine = ContractCostType._(
    name: 'Bn254G1ProjectiveToAffine',
    value: 75,
  );
  static const bn254G1Add = ContractCostType._(name: 'Bn254G1Add', value: 76);
  static const bn254G1Mul = ContractCostType._(name: 'Bn254G1Mul', value: 77);
  static const bn254Pairing = ContractCostType._(
    name: 'Bn254Pairing',
    value: 78,
  );
  static const bn254FrFromU256 = ContractCostType._(
    name: 'Bn254FrFromU256',
    value: 79,
  );
  static const bn254FrToU256 = ContractCostType._(
    name: 'Bn254FrToU256',
    value: 80,
  );
  static const bn254FrAddSub = ContractCostType._(
    name: 'Bn254FrAddSub',
    value: 81,
  );
  static const bn254FrMul = ContractCostType._(name: 'Bn254FrMul', value: 82);
  static const bn254FrPow = ContractCostType._(name: 'Bn254FrPow', value: 83);
  static const bn254FrInv = ContractCostType._(name: 'Bn254FrInv', value: 84);
  static const bn254G1Msm = ContractCostType._(name: 'Bn254G1Msm', value: 85);
  static const mlDsa44DecodeVerifyingKey = ContractCostType._(
    name: 'MlDsa44DecodeVerifyingKey',
    value: 86,
  );
  static const mlDsa65DecodeVerifyingKey = ContractCostType._(
    name: 'MlDsa65DecodeVerifyingKey',
    value: 87,
  );
  static const mlDsa87DecodeVerifyingKey = ContractCostType._(
    name: 'MlDsa87DecodeVerifyingKey',
    value: 88,
  );
  static const mlDsa44DecodeSignature = ContractCostType._(
    name: 'MlDsa44DecodeSignature',
    value: 89,
  );
  static const mlDsa65DecodeSignature = ContractCostType._(
    name: 'MlDsa65DecodeSignature',
    value: 90,
  );
  static const mlDsa87DecodeSignature = ContractCostType._(
    name: 'MlDsa87DecodeSignature',
    value: 91,
  );
  static const verifyMlDsa44Sig = ContractCostType._(
    name: 'VerifyMlDsa44Sig',
    value: 92,
  );
  static const verifyMlDsa65Sig = ContractCostType._(
    name: 'VerifyMlDsa65Sig',
    value: 93,
  );
  static const verifyMlDsa87Sig = ContractCostType._(
    name: 'VerifyMlDsa87Sig',
    value: 94,
  );
  static const List<ContractCostType> values = [
    wasmInsnExec,
    memAlloc,
    memCpy,
    memCmp,
    dispatchHostFunction,
    visitObject,
    valSer,
    valDeser,
    computeSha256Hash,
    computeEd25519PubKey,
    verifyEd25519Sig,
    vmInstantiation,
    vmCachedInstantiation,
    invokeVmFunction,
    computeKeccak256Hash,
    decodeEcdsaCurve256Sig,
    recoverEcdsaSecp256k1Key,
    int256AddSub,
    int256Mul,
    int256Div,
    int256Pow,
    int256Shift,
    chaCha20DrawBytes,
    parseWasmInstructions,
    parseWasmFunctions,
    parseWasmGlobals,
    parseWasmTableEntries,
    parseWasmTypes,
    parseWasmDataSegments,
    parseWasmElemSegments,
    parseWasmImports,
    parseWasmExports,
    parseWasmDataSegmentBytes,
    instantiateWasmInstructions,
    instantiateWasmFunctions,
    instantiateWasmGlobals,
    instantiateWasmTableEntries,
    instantiateWasmTypes,
    instantiateWasmDataSegments,
    instantiateWasmElemSegments,
    instantiateWasmImports,
    instantiateWasmExports,
    instantiateWasmDataSegmentBytes,
    sec1DecodePointUncompressed,
    verifyEcdsaSecp256r1Sig,
    bls12381EncodeFp,
    bls12381DecodeFp,
    bls12381G1CheckPointOnCurve,
    bls12381G1CheckPointInSubgroup,
    bls12381G2CheckPointOnCurve,
    bls12381G2CheckPointInSubgroup,
    bls12381G1ProjectiveToAffine,
    bls12381G2ProjectiveToAffine,
    bls12381G1Add,
    bls12381G1Mul,
    bls12381G1Msm,
    bls12381MapFpToG1,
    bls12381HashToG1,
    bls12381G2Add,
    bls12381G2Mul,
    bls12381G2Msm,
    bls12381MapFp2ToG2,
    bls12381HashToG2,
    bls12381Pairing,
    bls12381FrFromU256,
    bls12381FrToU256,
    bls12381FrAddSub,
    bls12381FrMul,
    bls12381FrPow,
    bls12381FrInv,
    bn254EncodeFp,
    bn254DecodeFp,
    bn254G1CheckPointOnCurve,
    bn254G2CheckPointOnCurve,
    bn254G2CheckPointInSubgroup,
    bn254G1ProjectiveToAffine,
    bn254G1Add,
    bn254G1Mul,
    bn254Pairing,
    bn254FrFromU256,
    bn254FrToU256,
    bn254FrAddSub,
    bn254FrMul,
    bn254FrPow,
    bn254FrInv,
    bn254G1Msm,
    mlDsa44DecodeVerifyingKey,
    mlDsa65DecodeVerifyingKey,
    mlDsa87DecodeVerifyingKey,
    mlDsa44DecodeSignature,
    mlDsa65DecodeSignature,
    mlDsa87DecodeSignature,
    verifyMlDsa44Sig,
    verifyMlDsa65Sig,
    verifyMlDsa87Sig,
  ];
  static ContractCostType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ContractCostType not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  static ContractCostType fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ContractCostType not found.',
                details: {'value': value?.toString()},
              ),
    );
  }

  @override
  String toString() {
    return 'ContractCostType.$name';
  }
}

class ContractCostParamEntry extends XDRSerialization {
  /// use [ext] to add more terms (e.g. higher order polynomials) in the future
  final ExtentionPointVoid ext;
  final BigInt constTerm;
  final BigInt linearTerm;
  ContractCostParamEntry({
    required BigInt constTerm,
    required BigInt linearTerm,
    this.ext = const ExtentionPointVoid(),
  }) : constTerm = constTerm.asI64,
       linearTerm = linearTerm.asI64;
  factory ContractCostParamEntry.fromStruct(Map<String, dynamic> json) {
    return ContractCostParamEntry(
      constTerm: json.valueAs('constTerm'),
      linearTerm: json.valueAs('linearTerm'),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      LayoutConst.s64be(property: 'constTerm'),
      LayoutConst.s64be(property: 'linearTerm'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'constTerm': constTerm,
      'linearTerm': linearTerm,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class ConfigSettingContractCostParamsCpuInstructions extends ConfigSetting {
  final List<ContractCostParamEntry> params;
  ConfigSettingContractCostParamsCpuInstructions(
    List<ContractCostParamEntry> params,
  ) : params = params.immutable,
      super(ConfigSettingId.contractCostParamsCpuInstructions);
  factory ConfigSettingContractCostParamsCpuInstructions.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractCostParamsCpuInstructions(
      json
          .valueEnsureAsList<Map<String, dynamic>>('params')
          .map((e) => ContractCostParamEntry.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ContractCostParamEntry.layout(property: 'params')),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'params': params.map((e) => e.toLayoutStruct()).toList()};
  }
}

class ConfigSettingContractCostParamsMemoryBytes extends ConfigSetting {
  final List<ContractCostParamEntry> params;
  ConfigSettingContractCostParamsMemoryBytes(
    List<ContractCostParamEntry> params,
  ) : params = params.immutable.max(
        name: 'params',
        length: 1024,
        operation: "ConfigSettingContractCostParamsMemoryBytes",
        reason: "Invalid params length.",
      ),
      super(ConfigSettingId.contractCostParamsMemoryBytes);
  factory ConfigSettingContractCostParamsMemoryBytes.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractCostParamsMemoryBytes(
      json
          .valueEnsureAsList<Map<String, dynamic>>('params')
          .map((e) => ContractCostParamEntry.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ContractCostParamEntry.layout(property: 'params')),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'params': params.map((e) => e.toLayoutStruct()).toList()};
  }
}

class ConfigSettingContractDataKeySizeBytes extends ConfigSetting {
  final int contractDataKeySizeBytes;
  ConfigSettingContractDataKeySizeBytes(int contractDataKeySizeBytes)
    : contractDataKeySizeBytes = contractDataKeySizeBytes.asU32,
      super(ConfigSettingId.contractDataKeySizeBytes);
  factory ConfigSettingContractDataKeySizeBytes.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractDataKeySizeBytes(
      json.valueAs('contractDataKeySizeBytes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'contractDataKeySizeBytes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'contractDataKeySizeBytes': contractDataKeySizeBytes};
  }
}

class ConfigSettingContractDataEntrySizeBytes extends ConfigSetting {
  final int contractDataEntrySizeBytes;
  ConfigSettingContractDataEntrySizeBytes(int contractDataEntrySizeBytes)
    : contractDataEntrySizeBytes = contractDataEntrySizeBytes.asU32,
      super(ConfigSettingId.contractDataEntrySizeBytes);
  factory ConfigSettingContractDataEntrySizeBytes.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractDataEntrySizeBytes(
      json.valueAs('contractDataEntrySizeBytes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'contractDataEntrySizeBytes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'contractDataEntrySizeBytes': contractDataEntrySizeBytes};
  }
}

class StateArchivalSettings extends XDRSerialization {
  final int maxEntryTtl;
  final int minTemporaryTtl;
  final int minPersistentTtl;

  /// rent_fee = wfee_rate_average / rent_rate_denominator_for_type
  final BigInt persistentRentRateDenominator;
  final BigInt tempRentRateDenominator;

  /// max number of entries that emit archival meta in a single ledger
  final int maxEntriesToArchive;

  /// Number of snapshots to use when calculating average BucketList size
  final int bucketListSizeWindowSampleSize;

  /// How often to sample the BucketList size for the average, in ledgers
  final int bucketListWindowSamplePeriod;

  /// Maximum number of bytes that we scan for eviction per ledger
  final int evictionScanSize;

  /// Lowest BucketList level to be scanned to evict entries
  final int startingEvictionScanLevel;
  factory StateArchivalSettings.fromStruct(Map<String, dynamic> json) {
    return StateArchivalSettings(
      bucketListSizeWindowSampleSize: json.valueAs(
        'bucketListSizeWindowSampleSize',
      ),
      bucketListWindowSamplePeriod: json.valueAs(
        'bucketListWindowSamplePeriod',
      ),
      evictionScanSize: json.valueAs('evictionScanSize'),
      maxEntriesToArchive: json.valueAs('maxEntriesToArchive'),
      maxEntryTtl: json.valueAs('maxEntryTtl'),
      minPersistentTtl: json.valueAs('minPersistentTtl'),
      minTemporaryTtl: json.valueAs('minTemporaryTtl'),
      persistentRentRateDenominator: json.valueAs(
        'persistentRentRateDenominator',
      ),
      startingEvictionScanLevel: json.valueAs('startingEvictionScanLevel'),
      tempRentRateDenominator: json.valueAs('tempRentRateDenominator'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'maxEntryTtl'),
      LayoutConst.u32be(property: 'minTemporaryTtl'),
      LayoutConst.u32be(property: 'minPersistentTtl'),
      LayoutConst.s64be(property: 'persistentRentRateDenominator'),
      LayoutConst.s64be(property: 'tempRentRateDenominator'),
      LayoutConst.u32be(property: 'maxEntriesToArchive'),
      LayoutConst.u32be(property: 'bucketListSizeWindowSampleSize'),
      LayoutConst.u32be(property: 'bucketListWindowSamplePeriod'),
      LayoutConst.u32be(property: 'evictionScanSize'),
      LayoutConst.u32be(property: 'startingEvictionScanLevel'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'maxEntryTtl': maxEntryTtl,
      'minTemporaryTtl': minTemporaryTtl,
      'minPersistentTtl': minPersistentTtl,
      'persistentRentRateDenominator': persistentRentRateDenominator,
      'tempRentRateDenominator': tempRentRateDenominator,
      'maxEntriesToArchive': maxEntriesToArchive,
      'bucketListSizeWindowSampleSize': bucketListSizeWindowSampleSize,
      'bucketListWindowSamplePeriod': bucketListWindowSamplePeriod,
      'evictionScanSize': evictionScanSize,
      'startingEvictionScanLevel': startingEvictionScanLevel,
    };
  }

  StateArchivalSettings({
    required int maxEntryTtl,
    required int minTemporaryTtl,
    required int minPersistentTtl,
    required BigInt persistentRentRateDenominator,
    required BigInt tempRentRateDenominator,
    required int maxEntriesToArchive,
    required int bucketListSizeWindowSampleSize,
    required int bucketListWindowSamplePeriod,
    required int evictionScanSize,
    required int startingEvictionScanLevel,
  }) : maxEntryTtl = maxEntryTtl.asU32,
       minTemporaryTtl = minTemporaryTtl.asU32,
       minPersistentTtl = minPersistentTtl.asU32,
       persistentRentRateDenominator = persistentRentRateDenominator.asI64,
       tempRentRateDenominator = tempRentRateDenominator.asI64,
       maxEntriesToArchive = maxEntriesToArchive.asU32,
       bucketListSizeWindowSampleSize = bucketListSizeWindowSampleSize.asU32,
       bucketListWindowSamplePeriod = bucketListWindowSamplePeriod.asU32,
       evictionScanSize = evictionScanSize.asU32,
       startingEvictionScanLevel = startingEvictionScanLevel.asU32;
}

class ConfigSettingContractStateArchivalSettings extends ConfigSetting {
  final StateArchivalSettings settings;
  ConfigSettingContractStateArchivalSettings(this.settings)
    : super(ConfigSettingId.stateArchival);
  factory ConfigSettingContractStateArchivalSettings.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractStateArchivalSettings(
      StateArchivalSettings.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('settings'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StateArchivalSettings.layout(property: 'settings'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'settings': settings.toLayoutStruct()};
  }
}

/// General “Soroban execution lane” settings
class ConfigSettingContractExecutionLanesV0 extends ConfigSetting {
  /// maximum number of Soroban transactions per ledger
  final int ledgerMaxTxCount;
  ConfigSettingContractExecutionLanesV0(int ledgerMaxTxCount)
    : ledgerMaxTxCount = ledgerMaxTxCount.asU32,
      super(ConfigSettingId.contractExecutionLanes);
  factory ConfigSettingContractExecutionLanesV0.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingContractExecutionLanesV0(
      json.valueAs('ledgerMaxTxCount'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'ledgerMaxTxCount'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ledgerMaxTxCount': ledgerMaxTxCount};
  }
}

class ConfigSettingBucketlistSizeWindow extends ConfigSetting {
  ConfigSettingBucketlistSizeWindow(List<BigInt> bucketlistSizeWindow)
    : bucketlistSizeWindow =
          bucketlistSizeWindow.map((e) => e.asU64).toList().immutable,
      super(ConfigSettingId.bucketlistSizeWindow);
  final List<BigInt> bucketlistSizeWindow;
  factory ConfigSettingBucketlistSizeWindow.fromStruct(
    Map<String, dynamic> json,
  ) {
    return ConfigSettingBucketlistSizeWindow(
      json.valueAs<List>('ledgerMaxTxCount').map((e) {
        if (e is! BigInt) {
          throw BuError(DefaultErrorType.invalidArgument, 
            'Incorrect value.',
            details: {
              'key': 'ledgerMaxTxCount',
              'expected': 'BigInt',
              'value': e.runtimeType.toString(),
              'data': json['ledgerMaxTxCount'],
            },
          );
        }
        return e;
      }).toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(LayoutConst.u64be(), property: 'bucketlistSizeWindow'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'bucketlistSizeWindow': bucketlistSizeWindow};
  }
}

class EvictionIterator extends XDRSerialization {
  final int bucketListLevel;
  final bool isCurrBucket;
  final BigInt bucketFileOffset;
  EvictionIterator({
    required int bucketListLevel,
    required this.isCurrBucket,
    required BigInt bucketFileOffset,
  }) : bucketListLevel = bucketListLevel.asU32,
       bucketFileOffset = bucketFileOffset.asU64;
  factory EvictionIterator.fromStruct(Map<String, dynamic> json) {
    return EvictionIterator(
      bucketFileOffset: json.valueAs('bucketFileOffset'),
      bucketListLevel: json.valueAs('bucketListLevel'),
      isCurrBucket: json.valueAs('isCurrBucket'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'bucketListLevel'),
      LayoutConst.boolean32Be(property: 'isCurrBucket'),
      LayoutConst.u64be(property: 'bucketFileOffset'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'bucketFileOffset': bucketFileOffset,
      'isCurrBucket': isCurrBucket,
      'bucketListLevel': bucketListLevel,
    };
  }
}

class ConfigSettingEvictionIterator extends ConfigSetting {
  final EvictionIterator evictionIterator;
  ConfigSettingEvictionIterator(this.evictionIterator)
    : super(ConfigSettingId.evictionIterator);
  factory ConfigSettingEvictionIterator.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingEvictionIterator(
      EvictionIterator.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('evictionIterator'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ConfigSettingEvictionIterator.layout(property: 'evictionIterator'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'evictionIterator': evictionIterator.toLayoutStruct()};
  }
}

class TTLEntry extends LedgerEntryData {
  /// Hash of the LedgerKey that is associated with this TTLEntry
  final BuBytes keyHash;
  final int liveUntilLedgerSeq;
  TTLEntry({required List<int> keyHash, required int liveUntilLedgerSeq})
    : liveUntilLedgerSeq = liveUntilLedgerSeq.asU32,
      keyHash =
          keyHash
              .exc(
                name: 'keyHash',
                length: StellarConst.hash256Length,
                operation: "TTLEntry",
                reason: "Invalid keyHash bytes length.",
              )
              .asImmutableBytes,
      super(LedgerEntryType.ttl);
  factory TTLEntry.fromStruct(Map<String, dynamic> json) {
    return TTLEntry(
      keyHash: json.valueAs('keyHash'),
      liveUntilLedgerSeq: json.valueAs('liveUntilLedgerSeq'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'keyHash'),
      LayoutConst.u32be(property: 'liveUntilLedgerSeq'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'keyHash': keyHash, 'liveUntilLedgerSeq': liveUntilLedgerSeq};
  }
}

class LedgerEntryExtensionV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final StellarPublicKey? sponsoringId;
  LedgerEntryExtensionV1({
    this.ext = const ExtentionPointVoid(),
    this.sponsoringId,
  });
  factory LedgerEntryExtensionV1.fromStruct(Map<String, dynamic> json) {
    return LedgerEntryExtensionV1(
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      sponsoringId: json.valueTo<StellarPublicKey?, Map<String, dynamic>>(
        key: 'sponsoringId',
        parse: (e) => StellarPublicKey.fromStruct(e),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(
        StellarPublicKey.layout(),
        property: 'sponsoringId',
      ),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'sponsoringId': sponsoringId?.toLayoutStruct(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class LedgerEntryExt extends XDRVariantSerialization {
  final LedgerEntryExtensionV1? v1;
  LedgerEntryExt({this.v1});

  factory LedgerEntryExt.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return LedgerEntryExt.fromStruct(decode);
  }
  factory LedgerEntryExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return LedgerEntryExt();
      case ExtensionPointType.extArgs1:
        return LedgerEntryExt(
          v1: LedgerEntryExtensionV1.fromStruct(decode.value),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid LedgerEntry extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: LedgerEntryExtensionV1.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (v1 != null) {
      return LedgerEntryExtensionV1.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return v1?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (v1 == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }
}

class LedgerEntry extends XDRSerialization {
  final int lastModifiedLedgerSeq;
  final LedgerEntryData data;
  final LedgerEntryExt ext;
  LedgerEntry({
    required int lastModifiedLedgerSeq,
    required this.data,
    required this.ext,
  }) : lastModifiedLedgerSeq = lastModifiedLedgerSeq.asU32;
  factory LedgerEntry.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return LedgerEntry.fromStruct(decode);
  }
  factory LedgerEntry.fromStruct(Map<String, dynamic> json) {
    return LedgerEntry(
      data: LedgerEntryData.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('data'),
      ),
      ext: LedgerEntryExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
      lastModifiedLedgerSeq: json.valueAs('lastModifiedLedgerSeq'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'lastModifiedLedgerSeq'),
      LedgerEntryData.layout(property: 'data'),
      LedgerEntryExt.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'lastModifiedLedgerSeq': lastModifiedLedgerSeq,
      'data': data.toVariantLayoutStruct(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

abstract class LedgerKey extends XDRVariantSerialization {
  final LedgerEntryType type;
  const LedgerKey(this.type);
  factory LedgerKey.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = LedgerEntryType.fromName(decode.variantName);
    switch (type) {
      case LedgerEntryType.account:
        return LedgerKeyAccount.fromStruct(decode.value);
      case LedgerEntryType.trustline:
        return LedgerKeyTrustLine.fromStruct(decode.value);

      case LedgerEntryType.offer:
        return LedgerKeyOffer.fromStruct(decode.value);
      case LedgerEntryType.data:
        return LedgerKeyData.fromStruct(decode.value);
      case LedgerEntryType.claimableBalance:
        return LedgerKeyClaimableBalance.fromStruct(decode.value);

      case LedgerEntryType.liquidityPool:
        return LedgerKeyLiquidityPool.fromStruct(decode.value);

      case LedgerEntryType.contractData:
        return LedgerKeyContractData.fromStruct(decode.value);

      case LedgerEntryType.contractCode:
        return LedgerKeyContractCode.fromStruct(decode.value);

      case LedgerEntryType.configSetting:
        return LedgerKeyConfigSetting.fromStruct(decode.value);
      case LedgerEntryType.ttl:
        return LedgerKeyTTL.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid LedgerEntry type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(LedgerEntryType.values.length, (index) {
        final type = LedgerEntryType.values.elementAt(index);
        switch (type) {
          case LedgerEntryType.account:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyAccount.layout,
              property: type.name,
            );
          case LedgerEntryType.trustline:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyTrustLine.layout,
              property: type.name,
            );
          case LedgerEntryType.offer:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyOffer.layout,
              property: type.name,
            );
          case LedgerEntryType.data:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyData.layout,
              property: type.name,
            );
          case LedgerEntryType.claimableBalance:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyClaimableBalance.layout,
              property: type.name,
            );
          case LedgerEntryType.liquidityPool:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyLiquidityPool.layout,
              property: type.name,
            );
          case LedgerEntryType.contractData:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyContractData.layout,
              property: type.name,
            );
          case LedgerEntryType.contractCode:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyContractCode.layout,
              property: type.name,
            );
          case LedgerEntryType.configSetting:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyConfigSetting.layout,
              property: type.name,
            );
          case LedgerEntryType.ttl:
            return LazyVariantModel(
              index: type.value,
              layout: LedgerKeyTTL.layout,
              property: type.name,
            );
          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid LedgerEntry type.',
              details: {'type': type.name},
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class LedgerKeyAccount extends LedgerKey {
  final StellarPublicKey accountId;
  const LedgerKeyAccount(this.accountId) : super(LedgerEntryType.account);
  factory LedgerKeyAccount.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyAccount(
      StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'accountId': accountId.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'accountId': accountId.toAddress().toString()};
  }
}

class LedgerKeyTrustLine extends LedgerKey {
  final StellarPublicKey accountId;
  final TrustLineAsset asset;
  const LedgerKeyTrustLine({required this.accountId, required this.asset})
    : super(LedgerEntryType.trustline);
  factory LedgerKeyTrustLine.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyTrustLine(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      asset: TrustLineAsset.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('asset'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      TrustLineAsset.layout(property: 'asset'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'accountId': accountId.toLayoutStruct(),
      'asset': asset.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId.toAddress().toString(),
      'asset': asset.toJson(),
    };
  }
}

class LedgerKeyOffer extends LedgerKey {
  final StellarPublicKey accountId;
  final BigInt offerId;
  LedgerKeyOffer({required this.accountId, required BigInt offerId})
    : offerId = offerId.asI64,
      super(LedgerEntryType.offer);
  factory LedgerKeyOffer.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyOffer(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      offerId: json.valueAs('offerId'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      LayoutConst.s64be(property: 'offerId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'accountId': accountId.toLayoutStruct(), 'offerId': offerId};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId.toAddress().toString(),
      'offerId': offerId.toString(),
    };
  }
}

class LedgerKeyData extends LedgerKey {
  final StellarPublicKey accountId;
  final String dataName;
  LedgerKeyData({required this.accountId, required String dataName})
    : dataName = StellarValidator.validateString(value: dataName, max: 64),
      super(LedgerEntryType.data);
  factory LedgerKeyData.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyData(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      dataName: json.valueAs('dataName'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      LayoutConst.xdrString(property: 'dataName'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'accountId': accountId.toLayoutStruct(), 'dataName': dataName};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId.toAddress().toString(),
      'dataName': dataName,
    };
  }
}

class LedgerKeyClaimableBalance extends LedgerKey {
  final ClaimableBalanceId balanceId;
  const LedgerKeyClaimableBalance(this.balanceId)
    : super(LedgerEntryType.claimableBalance);
  factory LedgerKeyClaimableBalance.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyClaimableBalance(
      ClaimableBalanceId.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('balanceId'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ClaimableBalanceId.layout(property: 'balanceId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'balanceId': balanceId.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'balanceId': balanceId.toJson()};
  }
}

class LedgerKeyLiquidityPool extends LedgerKey {
  final BuBytes liquidityPoolId;
  LedgerKeyLiquidityPool(List<int> liquidityPoolId)
    : liquidityPoolId =
          liquidityPoolId
              .exc(
                name: 'liquidityPoolId',
                length: StellarConst.hash256Length,
                operation: "LedgerKeyLiquidityPool",
                reason: "Invalid liquidityPoolId bytes length.",
              )
              .asImmutableBytes,
      super(LedgerEntryType.liquidityPool);
  factory LedgerKeyLiquidityPool.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyLiquidityPool(json.valueAs('liquidityPoolId'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'liquidityPoolId',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'liquidityPoolId': liquidityPoolId};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'liquidityPoolId': BytesUtils.toHexString(liquidityPoolId, prefix: '0x'),
    };
  }
}

class LedgerKeyContractData extends LedgerKey {
  final ScAddress contract;
  final ScVal key;
  final ContractDataDurability durability;
  const LedgerKeyContractData({
    required this.contract,
    required this.key,
    required this.durability,
  }) : super(LedgerEntryType.contractData);
  factory LedgerKeyContractData.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyContractData(
      contract: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('contract'),
      ),
      durability: ContractDataDurability.fromValue(json.valueAs('durability')),
      key: ScVal.fromStruct(json.valueEnsureAsMap<String, dynamic>('key')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'contract'),
      ScVal.layout(property: 'key'),
      LayoutConst.s32be(property: 'durability'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'contract': contract.toVariantLayoutStruct(),
      'key': key.toVariantLayoutStruct(),
      'durability': durability.value,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contract': contract.toJson(),
      'key': key.toJson(),
      'durability': durability.name,
    };
  }
}

class LedgerKeyContractCode extends LedgerKey {
  final BuBytes hash;
  LedgerKeyContractCode(List<int> hash)
    : hash =
          hash
              .exc(
                name: 'hash',
                length: StellarConst.hash256Length,
                operation: "LedgerKeyContractCode",
                reason: "Invalid hash bytes length.",
              )
              .asImmutableBytes,
      super(LedgerEntryType.contractCode);
  factory LedgerKeyContractCode.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyContractCode(json.valueAs('hash'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'hash': BytesUtils.toHexString(hash, prefix: '0x')};
  }
}

class LedgerKeyConfigSetting extends LedgerKey {
  final ConfigSettingId configSettingId;
  const LedgerKeyConfigSetting(this.configSettingId)
    : super(LedgerEntryType.configSetting);
  factory LedgerKeyConfigSetting.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyConfigSetting(
      ConfigSettingId.fromValue(json.valueAs('configSettingId')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'configSettingId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'configSettingId': configSettingId.value};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'configSettingId': configSettingId.name};
  }
}

class LedgerKeyTTL extends LedgerKey {
  final BuBytes keyHash;
  LedgerKeyTTL(List<int> keyHash)
    : keyHash =
          keyHash
              .exc(
                name: 'keyHash',
                length: StellarConst.hash256Length,
                operation: "LedgerKeyTTL",
                reason: "Invalid keyHash bytes length.",
              )
              .asImmutableBytes,
      super(LedgerEntryType.ttl);
  factory LedgerKeyTTL.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyTTL(json.valueAs('keyHash'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'keyHash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'keyHash': keyHash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'keyHash': BytesUtils.toHexString(keyHash, prefix: '0x')};
  }
}

class LedgerFootprint extends XDRSerialization {
  final List<LedgerKey> readOnly;
  final List<LedgerKey> readWrite;
  LedgerFootprint({
    required List<LedgerKey> readOnly,
    required List<LedgerKey> readWrite,
  }) : readOnly = readOnly.immutable,
       readWrite = readWrite.immutable;
  factory LedgerFootprint.fromStruct(Map<String, dynamic> json) {
    return LedgerFootprint(
      readOnly:
          json
              .valueEnsureAsList<Map<String, dynamic>>('readOnly')
              .map((e) => LedgerKey.fromStruct(e))
              .toList(),
      readWrite:
          json
              .valueEnsureAsList<Map<String, dynamic>>('readWrite')
              .map((e) => LedgerKey.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(LedgerKey.layout(), property: 'readOnly'),
      LayoutConst.xdrVec(LedgerKey.layout(), property: 'readWrite'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'readOnly': readOnly.map((e) => e.toVariantLayoutStruct()).toList(),
      'readWrite': readWrite.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'readOnly': readOnly.map((e) => e.toJson()).toList(),
      'readWrite': readWrite.map((e) => e.toJson()).toList(),
    };
  }
}

class SorobanResources extends XDRSerialization {
  final LedgerFootprint footprint;
  final int instructions;
  final int readBytes;
  final int writeBytes;
  SorobanResources({
    required this.footprint,
    required int instructions,
    required int readBytes,
    required int writeBytes,
  }) : instructions = instructions.asU32,
       readBytes = readBytes.asU32,
       writeBytes = writeBytes.asU32;
  factory SorobanResources.fromStruct(Map<String, dynamic> json) {
    return SorobanResources(
      footprint: LedgerFootprint.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('footprint'),
      ),
      instructions: json.valueAs('instructions'),
      readBytes: json.valueAs('readBytes'),
      writeBytes: json.valueAs('writeBytes'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LedgerFootprint.layout(property: 'footprint'),
      LayoutConst.u32be(property: 'instructions'),
      LayoutConst.u32be(property: 'readBytes'),
      LayoutConst.u32be(property: 'writeBytes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'footprint': footprint.toLayoutStruct(),
      'instructions': instructions,
      'readBytes': readBytes,
      'writeBytes': writeBytes,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'footprint': footprint.toJson(),
      'instructions': instructions,
      'readBytes': readBytes,
      'writeBytes': writeBytes,
    };
  }
}

class SorobanTransactionData extends XDRSerialization {
  final ExtentionPointVoid ext;
  final SorobanResources resources;
  final BigInt resourceFee;
  SorobanTransactionData({
    required this.resources,
    required BigInt resourceFee,
    this.ext = const ExtentionPointVoid(),
  }) : resourceFee = resourceFee.asI64;

  factory SorobanTransactionData.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return SorobanTransactionData.fromStruct(decode);
  }
  factory SorobanTransactionData.fromStruct(Map<String, dynamic> json) {
    return SorobanTransactionData(
      resources: SorobanResources.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('resources'),
      ),
      resourceFee: json.valueAs('resourceFee'),
      ext: ExtentionPointVoid.fromStruct(json.valueAs('ext')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: 'ext'),
      SorobanResources.layout(property: 'resources'),
      LayoutConst.s64be(property: 'resourceFee'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'ext': ext.toVariantLayoutStruct(),
      'resources': resources.toLayoutStruct(),
      'resourceFee': resourceFee,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'resources': resources.toJson(),
      'resourceFee': resourceFee.toString(),
    };
  }
}

class StellarCryptoKeyType {
  final String name;
  final int value;

  const StellarCryptoKeyType._({required this.name, required this.value});

  static const ed25519 = StellarCryptoKeyType._(name: 'Ed25519', value: 0);
  static const preAuthTx = StellarCryptoKeyType._(name: 'PreAuthTx', value: 1);
  static const hashX = StellarCryptoKeyType._(name: 'HashX', value: 2);
  static const ed25519SignedPayload = StellarCryptoKeyType._(
    name: 'Ed25519SignedPayload',
    value: 3,
  );
  static const muxedEd25519 = StellarCryptoKeyType._(
    name: 'MuxedEd25519',
    value: 256,
  );
  static const List<StellarCryptoKeyType> values = [
    ed25519,
    preAuthTx,
    hashX,
    ed25519SignedPayload,
    muxedEd25519,
  ];
  static StellarCryptoKeyType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Asset type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'StellarCryptoKeyType.$name';
  }
}

abstract class MuxedAccount extends XDRVariantSerialization {
  final StellarCryptoKeyType type;
  const MuxedAccount._(this.type);
  StellarAddress get address;
  factory MuxedAccount(StellarAddress address) {
    if (address.type == XlmAddrTypes.muxed) {
      address as StellarMuxedAddress;
      return MuxedAccountMed25519(
        id: address.accountId,
        ed25519: address.keyBytes(),
      );
    } else if (address.type != XlmAddrTypes.pubKey) {
      throw BuError(DefaultErrorType.unsupported, 
        'Only Stellar ED25519 public key address (XlmAddrTypes.pubKey, XlmAddrTypes.muxed) can be converted to muxed account.',
        details: {'type': address.type.name},
      );
    }

    return MuxedAccountEd25519(address.keyBytes());
  }
  factory MuxedAccount.fromBase32Address(String address) {
    return MuxedAccount(StellarAddress.fromBase32Addr(address));
  }
  factory MuxedAccount.fromPublicKey(StellarPublicKey publicKey) {
    return MuxedAccountEd25519(publicKey.toBytes());
  }
  factory MuxedAccount.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = StellarCryptoKeyType.fromName(decode.variantName);
    switch (type) {
      case StellarCryptoKeyType.ed25519:
        return MuxedAccountEd25519.fromStruct(decode.value);
      case StellarCryptoKeyType.muxedEd25519:
        return MuxedAccountMed25519.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid MuxedAccount type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.lazyEnumU32Be([
        LazyVariantModel(
          index: StellarCryptoKeyType.ed25519.value,
          layout: MuxedAccountEd25519.layout,
          property: StellarCryptoKeyType.ed25519.name,
        ),
        LazyVariantModel(
          index: StellarCryptoKeyType.muxedEd25519.value,
          layout: MuxedAccountMed25519.layout,
          property: StellarCryptoKeyType.muxedEd25519.name,
        ),
      ], property: property);

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class MuxedAccountMed25519 extends MuxedAccount {
  final BigInt id;
  final BuBytes ed25519;
  MuxedAccountMed25519({required BigInt id, required List<int> ed25519})
    : id = id.asU64,
      ed25519 = ed25519.asImmutableBytes,
      super._(StellarCryptoKeyType.muxedEd25519);

  factory MuxedAccountMed25519.fromStruct(Map<String, dynamic> json) {
    return MuxedAccountMed25519(
      id: json.valueAs('id'),
      ed25519: json.valueAs('ed25519'),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.struct([
        LayoutConst.u64be(property: 'id'),
        LayoutConst.fixedBlob32(property: 'ed25519'),
      ], property: property);

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'id': id, 'ed25519': ed25519};
  }

  @override
  StellarMuxedAddress get address =>
      StellarMuxedAddress.fromPublicKey(publicKey: ed25519, accountId: id);
}

class MuxedAccountEd25519 extends MuxedAccount {
  final BuBytes ed25519;
  MuxedAccountEd25519(List<int> ed25519)
    : ed25519 = ed25519.asImmutableBytes,
      super._(StellarCryptoKeyType.ed25519);
  factory MuxedAccountEd25519.fromStruct(Map<String, dynamic> json) {
    return MuxedAccountEd25519(json.valueAs('ed25519'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.struct([
        LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'ed25519'),
      ], property: property);
  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ed25519': ed25519};
  }

  @override
  StellarAddress get address => StellarAccountAddress.fromPublicKey(ed25519);
}

class PreconditionType {
  final String name;
  final int value;

  const PreconditionType._(this.name, this.value);

  static const PreconditionType none = PreconditionType._('None', 0);
  static const PreconditionType time = PreconditionType._('Time', 1);
  static const PreconditionType v2 = PreconditionType._('V2', 2);

  static const List<PreconditionType> values = [none, time, v2];

  static PreconditionType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Precondition type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

class TimeBounds extends XDRSerialization {
  final BigInt minTime;
  final BigInt maxTime;
  TimeBounds({required BigInt minTime, required BigInt maxTime})
    : minTime = minTime.asU64,
      maxTime = maxTime.asU64;
  factory TimeBounds.fromStruct(Map<String, dynamic> json) {
    return TimeBounds(
      minTime: json.valueAs('minTime'),
      maxTime: json.valueAs('maxTime'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'minTime'),
      LayoutConst.u64be(property: 'maxTime'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'minTime': minTime, 'maxTime': maxTime};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'minTime': minTime.toString(), 'maxTime': maxTime.toString()};
  }
}

class LedgerBounds extends XDRSerialization {
  final int minLedger;
  final int maxLedger;
  LedgerBounds({required int minLedger, required int maxLedger})
    : minLedger = minLedger.asU32,
      maxLedger = maxLedger.asU32;
  factory LedgerBounds.fromStruct(Map<String, dynamic> json) {
    return LedgerBounds(
      minLedger: json.valueAs('minLedger'),
      maxLedger: json.valueAs('maxLedger'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'minLedger'),
      LayoutConst.u32be(property: 'maxLedger'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'minLedger': minLedger, 'maxLedger': maxLedger};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'minLedger': minLedger, 'maxLedger': maxLedger};
  }
}

class PreconditionsV2 extends XDRSerialization {
  final TimeBounds? timeBounds;
  final LedgerBounds? ledgerBounds;
  final BigInt? minSeqNum;
  final BigInt minSeqAge;
  final int minSeqLedgerGap;
  final List<SignerKey> extraSigners;
  PreconditionsV2({
    this.timeBounds,
    this.ledgerBounds,
    BigInt? minSeqNum,
    required BigInt minSeqAge,
    required int minSeqLedgerGap,
    required List<SignerKey> extraSigners,
  }) : minSeqNum = minSeqNum?.asI64,
       minSeqAge = minSeqAge.asU64,
       minSeqLedgerGap = minSeqLedgerGap.asU32,
       extraSigners = extraSigners.immutable.max(
         name: 'extraSigners',
         length: 2,
         operation: "PreconditionsV2",
         reason: "Invalid extraSigners length.",
       );
  factory PreconditionsV2.fromStruct(Map<String, dynamic> json) {
    return PreconditionsV2(
      timeBounds: json.valueTo<TimeBounds?, Map<String, dynamic>>(
        key: 'timeBounds',
        parse: (e) => TimeBounds.fromStruct(e),
      ),
      ledgerBounds: json.valueTo<LedgerBounds?, Map<String, dynamic>>(
        key: 'ledgerBounds',
        parse: (e) => LedgerBounds.fromStruct(e),
      ),
      minSeqNum: json.valueAs('minSeqNum'),
      minSeqAge: json.valueAs('minSeqAge'),
      minSeqLedgerGap: json.valueAs('minSeqLedgerGap'),
      extraSigners:
          json
              .valueEnsureAsList<Map<String, dynamic>>('extraSigners')
              .map((e) => SignerKey.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(TimeBounds.layout(), property: 'timeBounds'),
      LayoutConst.optionalU32Be(
        LedgerBounds.layout(),
        property: 'ledgerBounds',
      ),
      LayoutConst.optionalU32Be(LayoutConst.s64be(), property: 'minSeqNum'),
      LayoutConst.u64be(property: 'minSeqAge'),
      LayoutConst.u32be(property: 'minSeqLedgerGap'),
      LayoutConst.xdrVec(SignerKey.layout(), property: 'extraSigners'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'timeBounds': timeBounds?.toLayoutStruct(),
      'ledgerBounds': ledgerBounds?.toLayoutStruct(),
      'minSeqNum': minSeqNum,
      'minSeqAge': minSeqAge,
      'minSeqLedgerGap': minSeqLedgerGap,
      'extraSigners':
          extraSigners.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

abstract class Preconditions extends XDRVariantSerialization {
  final PreconditionType type;
  const Preconditions(this.type);
  factory Preconditions.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = PreconditionType.fromName(decode.variantName);
    switch (type) {
      case PreconditionType.none:
        return PrecondNone.fromStruct(decode.value);
      case PreconditionType.time:
        return PrecondTime.fromStruct(decode.value);
      case PreconditionType.v2:
        return PrecondV2.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid Precondition type.',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: PreconditionType.none.value,
        layout: PrecondNone.layout,
        property: PreconditionType.none.name,
      ),
      LazyVariantModel(
        index: PreconditionType.time.value,
        layout: PrecondTime.layout,
        property: PreconditionType.time.name,
      ),
      LazyVariantModel(
        index: PreconditionType.v2.value,
        layout: PrecondV2.layout,
        property: PreconditionType.v2.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class PrecondNone extends Preconditions {
  const PrecondNone() : super(PreconditionType.none);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  factory PrecondNone.fromStruct(Map<String, dynamic> json) {
    return const PrecondNone();
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class PrecondTime extends Preconditions {
  final TimeBounds timeBounds;
  const PrecondTime(this.timeBounds) : super(PreconditionType.time);
  factory PrecondTime.fromStruct(Map<String, dynamic> json) {
    return PrecondTime(
      TimeBounds.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('timeBounds'),
      ),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      TimeBounds.layout(property: 'timeBounds'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'timeBounds': timeBounds.toLayoutStruct()};
  }
}

class PrecondV2 extends Preconditions {
  final PreconditionsV2 preconditionsV2;
  const PrecondV2(this.preconditionsV2) : super(PreconditionType.v2);
  factory PrecondV2.fromStruct(Map<String, dynamic> json) {
    return PrecondV2(
      PreconditionsV2.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('preconditionsV2'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      PreconditionsV2.layout(property: 'preconditionsV2'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'preconditionsV2': preconditionsV2.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'preconditionsV2': preconditionsV2.toJson()};
  }
}

abstract class AssetCode extends XDRVariantSerialization {
  final AssetType type;
  final BuBytes code;
  const AssetCode({required this.type, required this.code});
  factory AssetCode.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = AssetType.fromName(decode.variantName);
    switch (type) {
      case AssetType.creditAlphanum12:
        return AssetCode12.fromStruct(decode.value);
      case AssetType.creditAlphanum4:
        return AssetCode4.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid AssetCode type',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      LayoutConst.none(property: AssetType.native.name),
      AssetCode4.layout(property: AssetType.creditAlphanum4.name),
      AssetCode12.layout(property: AssetType.creditAlphanum12.name),
      LayoutConst.none(property: AssetType.poolShare.name),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class AssetCode4 extends AssetCode {
  static const int codeLength = 4;
  AssetCode4(List<int> code)
    : super(
        type: AssetType.creditAlphanum4,
        code:
            code
                .exc(
                  name: 'code',
                  length: codeLength,
                  operation: "AssetCode4",
                  reason: "Invalid code bytes length.",
                )
                .asImmutableBytes,
      );
  factory AssetCode4.fromString(String code) {
    return AssetCode4(
      StellarHelper.toAlphanumAssetCode(code: code, length: codeLength),
    );
  }
  factory AssetCode4.fromStruct(Map<String, dynamic> json) {
    return AssetCode4(json.valueAs('code'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(codeLength, property: 'code'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'code': code};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'code': StellarHelper.toAssetsCode(code)};
  }
}

class AssetCode12 extends AssetCode {
  static const int codeLength = 12;
  AssetCode12(List<int> code)
    : super(
        type: AssetType.creditAlphanum12,
        code:
            code
                .exc(
                  name: 'code',
                  length: codeLength,
                  operation: "AssetCode12",
                  reason: "Invalid code bytes length.",
                )
                .asImmutableBytes,
      );
  factory AssetCode12.fromString(String code) {
    return AssetCode12(
      StellarHelper.toAlphanumAssetCode(code: code, length: codeLength),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(codeLength, property: 'code'),
    ], property: property);
  }

  factory AssetCode12.fromStruct(Map<String, dynamic> json) {
    return AssetCode12(json.valueAs('code'));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'code': code};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'code': StellarHelper.toAssetsCode(code)};
  }
}

class RevokeSponsorshipType {
  final String name;
  final int value;
  const RevokeSponsorshipType._({required this.name, required this.value});
  static const RevokeSponsorshipType ledgerEntry = RevokeSponsorshipType._(
    name: 'LedgerEntry',
    value: 0,
  );
  static const RevokeSponsorshipType signer = RevokeSponsorshipType._(
    name: 'Signer',
    value: 1,
  );

  static const List<RevokeSponsorshipType> values = [ledgerEntry, signer];
  static RevokeSponsorshipType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'RevokeSponsorship type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'RevokeSponsorshipType.$name';
  }
}

abstract class RevokeSponsorship extends XDRVariantSerialization {
  final RevokeSponsorshipType type;
  const RevokeSponsorship(this.type);
  factory RevokeSponsorship.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = RevokeSponsorshipType.fromName(decode.variantName);
    switch (type) {
      case RevokeSponsorshipType.ledgerEntry:
        return RevokeSponsorshipLedgerKey.fromStruct(decode.value);
      case RevokeSponsorshipType.signer:
        return RevokeSponsorshipSigner.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid RevokeSponsorship type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: RevokeSponsorshipType.ledgerEntry.value,
        layout: RevokeSponsorshipLedgerKey.layout,
        property: RevokeSponsorshipType.ledgerEntry.name,
      ),
      LazyVariantModel(
        index: RevokeSponsorshipType.signer.value,
        layout: RevokeSponsorshipSigner.layout,
        property: RevokeSponsorshipType.signer.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class RevokeSponsorshipSigner extends RevokeSponsorship {
  final StellarPublicKey accountId;
  final SignerKey signerKey;
  const RevokeSponsorshipSigner({
    required this.accountId,
    required this.signerKey,
  }) : super(RevokeSponsorshipType.signer);
  factory RevokeSponsorshipSigner.fromStruct(Map<String, dynamic> json) {
    return RevokeSponsorshipSigner(
      accountId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('accountId'),
      ),
      signerKey: SignerKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('signerKey'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'accountId'),
      SignerKey.layout(property: 'signerKey'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'accountId': accountId.toLayoutStruct(),
      'signerKey': signerKey.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId.toAddress().toString(),
      'signerKey': signerKey.toJson(),
    };
  }
}

class RevokeSponsorshipLedgerKey extends RevokeSponsorship {
  final LedgerKey ledgerKey;
  const RevokeSponsorshipLedgerKey(this.ledgerKey)
    : super(RevokeSponsorshipType.ledgerEntry);
  factory RevokeSponsorshipLedgerKey.fromStruct(Map<String, dynamic> json) {
    return RevokeSponsorshipLedgerKey(
      LedgerKey.fromStruct(json.valueEnsureAsMap<String, dynamic>('ledgerKey')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LedgerKey.layout(property: 'ledgerKey'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ledgerKey': ledgerKey.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'ledgerKey': ledgerKey.toJson()};
  }
}

class HostFunctionType {
  final String name;
  final int value;

  const HostFunctionType._({required this.name, required this.value});

  static const invokeContract = HostFunctionType._(
    name: 'InvokeContract',
    value: 0,
  );
  static const createContract = HostFunctionType._(
    name: 'CreateContract',
    value: 1,
  );
  static const uploadContractWasm = HostFunctionType._(
    name: 'UploadContractWasm',
    value: 2,
  );
  static const createContractV2 = HostFunctionType._(
    name: 'CreateContractV2',
    value: 3,
  );
  static const List<HostFunctionType> values = [
    invokeContract,
    createContract,
    uploadContractWasm,
    createContractV2,
  ];
  static HostFunctionType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'HostFunction type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'HostFunctionType.$name';
  }
}

abstract class HostFunction extends XDRVariantSerialization {
  final HostFunctionType type;
  const HostFunction(this.type);
  factory HostFunction.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = HostFunctionType.fromName(decode.variantName);
    switch (type) {
      case HostFunctionType.invokeContract:
        return HostFunctionTypeInvokeContract.fromStruct(decode.value);
      case HostFunctionType.createContract:
        return HostFunctionTypeCreateContract.fromStruct(decode.value);
      case HostFunctionType.uploadContractWasm:
        return HostFunctionTypeUploadContractWasm.fromStruct(decode.value);
      case HostFunctionType.createContractV2:
        return HostFunctionTypeCreateContractV2.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid HostFunction type.',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: HostFunctionType.invokeContract.value,
        layout: HostFunctionTypeInvokeContract.layout,
        property: HostFunctionType.invokeContract.name,
      ),
      LazyVariantModel(
        index: HostFunctionType.createContract.value,
        layout: HostFunctionTypeCreateContract.layout,
        property: HostFunctionType.createContract.name,
      ),
      LazyVariantModel(
        index: HostFunctionType.uploadContractWasm.value,
        layout: HostFunctionTypeUploadContractWasm.layout,
        property: HostFunctionType.uploadContractWasm.name,
      ),
      LazyVariantModel(
        index: HostFunctionType.createContractV2.value,
        layout: HostFunctionTypeCreateContractV2.layout,
        property: HostFunctionType.createContractV2.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class HostFunctionTypeInvokeContract extends HostFunction {
  final InvokeContractArgs args;
  HostFunctionTypeInvokeContract(this.args)
    : super(HostFunctionType.invokeContract);
  factory HostFunctionTypeInvokeContract.fromStruct(Map<String, dynamic> json) {
    return HostFunctionTypeInvokeContract(
      InvokeContractArgs.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      InvokeContractArgs.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'args': args.toJson()};
  }
}

class ContractIdPreimageType {
  final String name;
  final int value;

  const ContractIdPreimageType._({required this.name, required this.value});

  static const fromAddress = ContractIdPreimageType._(
    name: 'FromAddress',
    value: 0,
  );
  static const fromAsset = ContractIdPreimageType._(
    name: 'FromAsset',
    value: 1,
  );

  static const List<ContractIdPreimageType> values = [fromAddress, fromAsset];
  static ContractIdPreimageType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'ContractIdPreimage type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'ContractIdPreimageType.$name';
  }
}

abstract class ContractIdPreimage extends XDRVariantSerialization {
  final ContractIdPreimageType type;
  const ContractIdPreimage(this.type);
  factory ContractIdPreimage.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ContractIdPreimageType.fromName(decode.variantName);
    switch (type) {
      case ContractIdPreimageType.fromAddress:
        return ContractIdPreimageFromAddress.fromStruct(decode.value);
      case ContractIdPreimageType.fromAsset:
        return ContractIdPreimageFromAsset.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid ContractIdPreimage type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ContractIdPreimageType.fromAddress.value,
        layout: ContractIdPreimageFromAddress.layout,
        property: ContractIdPreimageType.fromAddress.name,
      ),
      LazyVariantModel(
        index: ContractIdPreimageType.fromAsset.value,
        layout: ContractIdPreimageFromAsset.layout,
        property: ContractIdPreimageType.fromAsset.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ContractIdPreimageFromAddress extends ContractIdPreimage {
  final ScAddress address;
  final BuBytes salt;
  ContractIdPreimageFromAddress({
    required this.address,
    required List<int> salt,
  }) : salt =
           salt
               .exc(
                 name: 'salt',
                 length: StellarConst.hash256Length,
                 operation: "ContractIdPreimageFromAddress",
                 reason: "Invalid salt bytes length.",
               )
               .asImmutableBytes,
       super(ContractIdPreimageType.fromAddress);
  factory ContractIdPreimageFromAddress.fromStruct(Map<String, dynamic> json) {
    return ContractIdPreimageFromAddress(
      address: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('address'),
      ),
      salt: json.valueAs('salt'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'address'),
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'salt'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'address': address.toVariantLayoutStruct(), 'salt': salt};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'address': address.address,
      'salt': BytesUtils.toHexString(salt, prefix: '0x'),
    };
  }
}

class ContractIdPreimageFromAsset extends ContractIdPreimage {
  final StellarAsset asset;
  ContractIdPreimageFromAsset(this.asset)
    : super(ContractIdPreimageType.fromAsset);
  factory ContractIdPreimageFromAsset.fromStruct(Map<String, dynamic> json) {
    return ContractIdPreimageFromAsset(
      StellarAsset.fromStruct(json.valueEnsureAsMap<String, dynamic>('asset')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: 'asset'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'asset': asset.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'asset': asset.toJson()};
  }
}

class CreateContractArgs extends XDRSerialization {
  final ContractIdPreimage contractIdPreimage;
  final ContractExecutable executable;
  const CreateContractArgs({
    required this.contractIdPreimage,
    required this.executable,
  });
  factory CreateContractArgs.fromStruct(Map<String, dynamic> json) {
    return CreateContractArgs(
      contractIdPreimage: ContractIdPreimage.fromStruct(
        json.valueAs('contractIdPreimage'),
      ),
      executable: ContractExecutable.fromStruct(json.valueAs('executable')),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractIdPreimage.layout(property: 'contractIdPreimage'),
      ContractExecutable.layout(property: 'executable'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'contractIdPreimage': contractIdPreimage.toVariantLayoutStruct(),
      'executable': executable.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contractIdPreimage': contractIdPreimage.toJson(),
      'executable': executable.toJson(),
    };
  }
}

/// XDR `CreateContractArgsV2`: create-contract args plus the constructor
/// arguments (protocol 22+).
class CreateContractArgsV2 extends XDRSerialization {
  final ContractIdPreimage contractIdPreimage;
  final ContractExecutable executable;
  final List<ScVal> constructorArgs;
  CreateContractArgsV2({
    required this.contractIdPreimage,
    required this.executable,
    required List<ScVal> constructorArgs,
  }) : constructorArgs = constructorArgs.immutable;
  factory CreateContractArgsV2.fromStruct(Map<String, dynamic> json) {
    return CreateContractArgsV2(
      contractIdPreimage: ContractIdPreimage.fromStruct(
        json.valueAs('contractIdPreimage'),
      ),
      executable: ContractExecutable.fromStruct(json.valueAs('executable')),
      constructorArgs:
          json
              .valueEnsureAsList<Map<String, dynamic>>('constructorArgs')
              .map((e) => ScVal.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractIdPreimage.layout(property: 'contractIdPreimage'),
      ContractExecutable.layout(property: 'executable'),
      LayoutConst.xdrVec(ScVal.layout(), property: 'constructorArgs'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'contractIdPreimage': contractIdPreimage.toVariantLayoutStruct(),
      'executable': executable.toVariantLayoutStruct(),
      'constructorArgs':
          constructorArgs.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contractIdPreimage': contractIdPreimage.toJson(),
      'executable': executable.toJson(),
      'constructorArgs': constructorArgs.map((e) => e.toJson()).toList(),
    };
  }
}

class HostFunctionTypeCreateContract extends HostFunction {
  final CreateContractArgs args;
  const HostFunctionTypeCreateContract(this.args)
    : super(HostFunctionType.createContract);
  factory HostFunctionTypeCreateContract.fromStruct(Map<String, dynamic> json) {
    return HostFunctionTypeCreateContract(
      CreateContractArgs.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgs.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }
}

class HostFunctionTypeCreateContractV2 extends HostFunction {
  final CreateContractArgsV2 args;
  const HostFunctionTypeCreateContractV2(this.args)
    : super(HostFunctionType.createContractV2);
  factory HostFunctionTypeCreateContractV2.fromStruct(
    Map<String, dynamic> json,
  ) {
    return HostFunctionTypeCreateContractV2(
      CreateContractArgsV2.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgsV2.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }
}

class HostFunctionTypeUploadContractWasm extends HostFunction {
  final BuBytes wasm;
  HostFunctionTypeUploadContractWasm(List<int> wasm)
    : wasm = wasm.asImmutableBytes,
      super(HostFunctionType.uploadContractWasm);
  factory HostFunctionTypeUploadContractWasm.fromStruct(
    Map<String, dynamic> json,
  ) {
    return HostFunctionTypeUploadContractWasm(json.valueAs('wasm'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVecBytes(property: 'wasm'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'wasm': wasm};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'wasm': BytesUtils.toHexString(wasm)};
  }
}

class SorobanCredentialsType {
  final String name;
  final int value;

  const SorobanCredentialsType._({required this.name, required this.value});

  static const sourceAccount = SorobanCredentialsType._(
    name: 'SourceAccount',
    value: 0,
  );
  static const address = SorobanCredentialsType._(name: 'Address', value: 1);
  static const addressV2 = SorobanCredentialsType._(
    name: 'AddressV2',
    value: 2,
  );
  static const addressWithDelegates = SorobanCredentialsType._(
    name: 'AddressWithDelegates',
    value: 3,
  );
  static const List<SorobanCredentialsType> values = [
    sourceAccount,
    address,
    addressV2,
    addressWithDelegates,
  ];
  static SorobanCredentialsType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'SorobanCredentials type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'SorobanCredentialsType.$name';
  }
}

abstract class SorobanCredentials extends XDRVariantSerialization {
  final SorobanCredentialsType type;
  const SorobanCredentials(this.type);
  factory SorobanCredentials.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = SorobanCredentialsType.fromName(decode.variantName);
    switch (type) {
      case SorobanCredentialsType.address:
        return SorobanAddressCredentials.fromStruct(decode.value);
      case SorobanCredentialsType.addressV2:
        return SorobanAddressCredentialsV2.fromStruct(decode.value);
      case SorobanCredentialsType.addressWithDelegates:
        return SorobanAddressCredentialsWithDelegates.fromStruct(decode.value);
      case SorobanCredentialsType.sourceAccount:
        return SorobanCredentialsSourceAccount.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid SorobanCredentials type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: SorobanCredentialsType.sourceAccount.value,
        layout: SorobanCredentialsSourceAccount.layout,
        property: SorobanCredentialsType.sourceAccount.name,
      ),
      LazyVariantModel(
        index: SorobanCredentialsType.address.value,
        layout: SorobanAddressCredentials.layout,
        property: SorobanCredentialsType.address.name,
      ),
      LazyVariantModel(
        index: SorobanCredentialsType.addressV2.value,
        layout: SorobanAddressCredentialsV2.layout,
        property: SorobanCredentialsType.addressV2.name,
      ),
      LazyVariantModel(
        index: SorobanCredentialsType.addressWithDelegates.value,
        layout: SorobanAddressCredentialsWithDelegates.layout,
        property: SorobanCredentialsType.addressWithDelegates.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class SorobanAddressCredentials extends SorobanCredentials {
  final ScAddress address;
  final BigInt nonce;
  final int signatureExpirationLedger;
  final ScVal signature;
  SorobanAddressCredentials({
    required this.address,
    required BigInt nonce,
    required int signatureExpirationLedger,
    required this.signature,
  }) : nonce = nonce.asI64,
       signatureExpirationLedger = signatureExpirationLedger.asU32,
       super(SorobanCredentialsType.address);
  factory SorobanAddressCredentials.fromStruct(Map<String, dynamic> json) {
    return SorobanAddressCredentials(
      address: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('address'),
      ),
      nonce: json.valueAs('nonce'),
      signatureExpirationLedger: json.valueAs('signatureExpirationLedger'),
      signature: ScVal.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('signature'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'address'),
      LayoutConst.s64be(property: 'nonce'),
      LayoutConst.u32be(property: 'signatureExpirationLedger'),
      ScVal.layout(property: 'signature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'address': address.toVariantLayoutStruct(),
      'nonce': nonce,
      'signatureExpirationLedger': signatureExpirationLedger,
      'signature': signature.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'address': address.address,
      'nonce': nonce.toString(),
      'signatureExpirationLedger': signatureExpirationLedger,
      'signature': signature.toJson(),
    };
  }
}

/// XDR `SorobanAddressCredentials` under the `ADDRESS_V2` arm (protocol 27+,
/// CAP-71-02): same wire shape as [SorobanAddressCredentials], different
/// authorization semantics on the network side.
class SorobanAddressCredentialsV2 extends SorobanCredentials {
  final ScAddress address;
  final BigInt nonce;
  final int signatureExpirationLedger;
  final ScVal signature;
  SorobanAddressCredentialsV2({
    required this.address,
    required BigInt nonce,
    required int signatureExpirationLedger,
    required this.signature,
  }) : nonce = nonce.asI64,
       signatureExpirationLedger = signatureExpirationLedger.asU32,
       super(SorobanCredentialsType.addressV2);
  factory SorobanAddressCredentialsV2.fromStruct(Map<String, dynamic> json) {
    return SorobanAddressCredentialsV2(
      address: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('address'),
      ),
      nonce: json.valueAs('nonce'),
      signatureExpirationLedger: json.valueAs('signatureExpirationLedger'),
      signature: ScVal.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('signature'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'address'),
      LayoutConst.s64be(property: 'nonce'),
      LayoutConst.u32be(property: 'signatureExpirationLedger'),
      ScVal.layout(property: 'signature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'address': address.toVariantLayoutStruct(),
      'nonce': nonce,
      'signatureExpirationLedger': signatureExpirationLedger,
      'signature': signature.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'address': address.address,
      'nonce': nonce.toString(),
      'signatureExpirationLedger': signatureExpirationLedger,
      'signature': signature.toJson(),
    };
  }
}

/// XDR `SorobanDelegateSignature`: one delegation link in the
/// `ADDRESS_WITH_DELEGATES` credential chain.
class SorobanDelegateSignature extends XDRSerialization {
  final ScAddress address;
  final ScVal signature;
  final List<SorobanDelegateSignature> nestedDelegates;
  SorobanDelegateSignature({
    required this.address,
    required this.signature,
    required List<SorobanDelegateSignature> nestedDelegates,
  }) : nestedDelegates = nestedDelegates.immutable;
  factory SorobanDelegateSignature.fromStruct(Map<String, dynamic> json) {
    return SorobanDelegateSignature(
      address: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('address'),
      ),
      signature: ScVal.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('signature'),
      ),
      nestedDelegates:
          json
              .valueEnsureAsList<Map<String, dynamic>>('nestedDelegates')
              .map((e) => SorobanDelegateSignature.fromStruct(e))
              .toList(),
    );
  }
  static Layout _selfVector({String? property}) {
    return LayoutConst.xdrVec(
      SorobanDelegateSignature.layout(),
      property: property,
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyStruct([
      LazyStructLayoutBuilder(
        layout: (property, params) => ScAddress.layout(property: property),
        property: 'address',
      ),
      LazyStructLayoutBuilder(
        layout: (property, params) => ScVal.layout(property: property),
        property: 'signature',
      ),
      LazyStructLayoutBuilder(
        layout: (property, params) => _selfVector(property: property),
        property: 'nestedDelegates',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'address': address.toVariantLayoutStruct(),
      'signature': signature.toVariantLayoutStruct(),
      'nestedDelegates':
          nestedDelegates.map((e) => e.toLayoutStruct()).toList(),
    };
  }
}

/// XDR `SorobanAddressCredentialsWithDelegates`.
class SorobanAddressCredentialsWithDelegates extends SorobanCredentials {
  final SorobanAddressCredentials addressCredentials;
  final List<SorobanDelegateSignature> delegates;
  SorobanAddressCredentialsWithDelegates({
    required this.addressCredentials,
    required List<SorobanDelegateSignature> delegates,
  }) : delegates = delegates.immutable,
       super(SorobanCredentialsType.addressWithDelegates);
  factory SorobanAddressCredentialsWithDelegates.fromStruct(
    Map<String, dynamic> json,
  ) {
    return SorobanAddressCredentialsWithDelegates(
      addressCredentials: SorobanAddressCredentials.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('addressCredentials'),
      ),
      delegates:
          json
              .valueEnsureAsList<Map<String, dynamic>>('delegates')
              .map((e) => SorobanDelegateSignature.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      SorobanAddressCredentials.layout(property: 'addressCredentials'),
      LayoutConst.xdrVec(
        SorobanDelegateSignature.layout(),
        property: 'delegates',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'addressCredentials': addressCredentials.toLayoutStruct(),
      'delegates': delegates.map((e) => e.toLayoutStruct()).toList(),
    };
  }
}

class SorobanCredentialsSourceAccount extends SorobanCredentials {
  const SorobanCredentialsSourceAccount()
    : super(SorobanCredentialsType.sourceAccount);
  factory SorobanCredentialsSourceAccount.fromStruct(
    Map<String, dynamic> json,
  ) {
    return const SorobanCredentialsSourceAccount();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class SorobanAuthorizedFunctionType {
  final String name;
  final int value;

  const SorobanAuthorizedFunctionType._({
    required this.name,
    required this.value,
  });

  static const contractFn = SorobanAuthorizedFunctionType._(
    name: 'ContractFn',
    value: 0,
  );
  static const createContractHostFn = SorobanAuthorizedFunctionType._(
    name: 'CreateContractHostFn',
    value: 1,
  );
  static const createContractV2HostFn = SorobanAuthorizedFunctionType._(
    name: 'CreateContractV2HostFn',
    value: 2,
  );
  static const List<SorobanAuthorizedFunctionType> values = [
    contractFn,
    createContractHostFn,
    createContractV2HostFn,
  ];
  static SorobanAuthorizedFunctionType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'SorobanAuthorizedFunction type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'SorobanAuthorizedFunctionType.$name';
  }
}

abstract class SorobanAuthorizedFunction extends XDRVariantSerialization {
  final SorobanAuthorizedFunctionType type;
  const SorobanAuthorizedFunction(this.type);

  factory SorobanAuthorizedFunction.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = SorobanAuthorizedFunctionType.fromName(decode.variantName);
    switch (type) {
      case SorobanAuthorizedFunctionType.contractFn:
        return SorobanAuthorizedFunctionTypeContractFunction.fromStruct(
          decode.value,
        );
      case SorobanAuthorizedFunctionType.createContractHostFn:
        return SorobanAuthorizedFunctionTypeCreateContractHostFunction.fromStruct(
          decode.value,
        );
      case SorobanAuthorizedFunctionType.createContractV2HostFn:
        return SorobanAuthorizedFunctionTypeCreateContractV2HostFunction.fromStruct(
          decode.value,
        );
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid SorobanAuthorizedFunction type.',
          details: {'type': type.name},
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: SorobanAuthorizedFunctionType.contractFn.value,
        layout: SorobanAuthorizedFunctionTypeContractFunction.layout,
        property: SorobanAuthorizedFunctionType.contractFn.name,
      ),
      LazyVariantModel(
        index: SorobanAuthorizedFunctionType.createContractHostFn.value,
        layout: SorobanAuthorizedFunctionTypeCreateContractHostFunction.layout,
        property: SorobanAuthorizedFunctionType.createContractHostFn.name,
      ),
      LazyVariantModel(
        index: SorobanAuthorizedFunctionType.createContractV2HostFn.value,
        layout:
            SorobanAuthorizedFunctionTypeCreateContractV2HostFunction.layout,
        property: SorobanAuthorizedFunctionType.createContractV2HostFn.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class InvokeContractArgs extends XDRSerialization {
  final ScAddress contractAddress;
  final ScValSymbol functionName;
  final List<ScVal> args;
  InvokeContractArgs({
    required this.contractAddress,
    required this.functionName,
    required List<ScVal> args,
  }) : args = args.immutable;
  factory InvokeContractArgs.fromStruct(Map<String, dynamic> json) {
    return InvokeContractArgs(
      contractAddress: ScAddress.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('contractAddress'),
      ),
      functionName: ScValSymbol.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('functionName'),
      ),
      args:
          json
              .valueEnsureAsList<Map<String, dynamic>>('args')
              .map((e) => ScVal.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: 'contractAddress'),
      ScValSymbol.layout(property: 'functionName'),
      LayoutConst.xdrVec(ScVal.layout(), property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contractAddress': contractAddress.address,
      'functionName': functionName.value,
      'args': args.map((e) => e.toJson()).toList(),
    };
  }

  /// should be test
  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'contractAddress': contractAddress.toVariantLayoutStruct(),
      'functionName': functionName.toLayoutStruct(),
      'args': args.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

class SorobanAuthorizedFunctionTypeContractFunction
    extends SorobanAuthorizedFunction {
  final InvokeContractArgs args;
  const SorobanAuthorizedFunctionTypeContractFunction(this.args)
    : super(SorobanAuthorizedFunctionType.contractFn);
  factory SorobanAuthorizedFunctionTypeContractFunction.fromStruct(
    Map<String, dynamic> json,
  ) {
    return SorobanAuthorizedFunctionTypeContractFunction(
      InvokeContractArgs.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      InvokeContractArgs.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'args': args.toJson()};
  }
}

class SorobanAuthorizedFunctionTypeCreateContractHostFunction
    extends SorobanAuthorizedFunction {
  final CreateContractArgs args;
  const SorobanAuthorizedFunctionTypeCreateContractHostFunction(this.args)
    : super(SorobanAuthorizedFunctionType.createContractHostFn);

  factory SorobanAuthorizedFunctionTypeCreateContractHostFunction.fromStruct(
    Map<String, dynamic> json,
  ) {
    return SorobanAuthorizedFunctionTypeCreateContractHostFunction(
      CreateContractArgs.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgs.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'args': args.toJson()};
  }
}

class SorobanAuthorizedFunctionTypeCreateContractV2HostFunction
    extends SorobanAuthorizedFunction {
  final CreateContractArgsV2 args;
  const SorobanAuthorizedFunctionTypeCreateContractV2HostFunction(this.args)
    : super(SorobanAuthorizedFunctionType.createContractV2HostFn);

  factory SorobanAuthorizedFunctionTypeCreateContractV2HostFunction.fromStruct(
    Map<String, dynamic> json,
  ) {
    return SorobanAuthorizedFunctionTypeCreateContractV2HostFunction(
      CreateContractArgsV2.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('args'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgsV2.layout(property: 'args'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'args': args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'args': args.toJson()};
  }
}

class SorobanAuthorizedInvocation extends XDRSerialization {
  final SorobanAuthorizedFunction function;
  final List<SorobanAuthorizedInvocation> subInvocations;
  SorobanAuthorizedInvocation({
    required this.function,
    required List<SorobanAuthorizedInvocation> subInvocations,
  }) : subInvocations = subInvocations.immutable;
  factory SorobanAuthorizedInvocation.fromStruct(Map<String, dynamic> json) {
    return SorobanAuthorizedInvocation(
      function: SorobanAuthorizedFunction.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('function'),
      ),
      subInvocations:
          json
              .valueEnsureAsList<Map<String, dynamic>>('subInvocations')
              .map((e) => SorobanAuthorizedInvocation.fromStruct(e))
              .toList(),
    );
  }
  static Layout _selfVector({String? property}) {
    return LayoutConst.xdrVec(
      SorobanAuthorizedInvocation.layout(),
      property: property,
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyStruct([
      LazyStructLayoutBuilder(
        layout:
            (property, params) =>
                SorobanAuthorizedFunction.layout(property: property),
        property: 'function',
      ),
      LazyStructLayoutBuilder(
        layout: (property, params) => _selfVector(property: property),
        property: 'subInvocations',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'function': function.toVariantLayoutStruct(),
      'subInvocations': subInvocations.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'function': function.toJson(),
      'subInvocations': subInvocations.map((e) => e.toJson()).toList(),
    };
  }
}

class SorobanAuthorizationEntry extends XDRSerialization {
  final SorobanCredentials credentials;
  final SorobanAuthorizedInvocation rootInvocation;
  const SorobanAuthorizationEntry({
    required this.credentials,
    required this.rootInvocation,
  });
  factory SorobanAuthorizationEntry.fromXdr(
    List<int> bytes, {
    String? property,
  }) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return SorobanAuthorizationEntry.fromStruct(decode);
  }
  factory SorobanAuthorizationEntry.fromStruct(Map<String, dynamic> json) {
    return SorobanAuthorizationEntry(
      credentials: SorobanCredentials.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('credentials'),
      ),
      rootInvocation: SorobanAuthorizedInvocation.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('rootInvocation'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      SorobanCredentials.layout(property: 'credentials'),
      SorobanAuthorizedInvocation.layout(property: 'rootInvocation'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'rootInvocation': rootInvocation.toLayoutStruct(),
      'credentials': credentials.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'rootInvocation': rootInvocation.toJson(),
      'credentials': credentials.toJson(),
    };
  }
}

class TrustLineFlag {
  final String name;
  final int value;

  const TrustLineFlag._({required this.name, required this.value});

  // Authorization required (the issuer must approve trustlines before assets can be held)
  static const authorizedFlag = TrustLineFlag._(name: 'Authorized', value: 1);

  // Trustline is frozen (cannot send, receive, or hold assets)
  static const frozenFlag = TrustLineFlag._(name: 'Frozen', value: 2);

  // Authorization revocable (issuer can revoke authorization at any time)
  static const authorizedToMaintainLiabilitiesFlag = TrustLineFlag._(
    name: 'AuthorizedToMaintainLiabilities',
    value: 4,
  );
  static const List<TrustLineFlag> values = [
    authorizedFlag,
    frozenFlag,
    authorizedToMaintainLiabilitiesFlag,
  ];
  @override
  String toString() {
    return 'TrustLineFlag.$name';
  }

  static TrustLineFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'TrustLineFlag not found.',
                details: {
                  'flag': flag?.toString(),
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

class TrustAuthFlag {
  final String name;
  final int value;

  const TrustAuthFlag._({required this.name, required this.value});

  // Authorization is fully disabled
  static const unauthorized = TrustAuthFlag._(name: 'Unauthorized', value: 0);

  // Authorization is fully enabled
  static const authorized = TrustAuthFlag._(name: 'Authorized', value: 1);

  // Authorized to maintain liabilities only
  static const authorizedToMaintainLiabilities = TrustAuthFlag._(
    name: 'AuthorizedToMaintainLiabilities',
    value: 2,
  );
  static const List<TrustAuthFlag> values = [
    unauthorized,
    authorized,
    authorizedToMaintainLiabilities,
  ];

  @override
  String toString() {
    return 'TrustAuthFlag.$name';
  }

  static TrustAuthFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'TrustAuthFlag not found.',
                details: {
                  'flag': flag?.toString(),
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

class AuthFlag {
  final String name;
  final int value;

  const AuthFlag._({required this.name, required this.value});

  static const requiredFlag = AuthFlag._(name: 'RequiredFlag', value: 1);
  static const revocableFlag = AuthFlag._(name: 'RevocableFlag', value: 2);
  static const immutableFlag = AuthFlag._(name: 'ImmutableFlag', value: 4);
  static const clawbackEnabledFlag = AuthFlag._(
    name: 'ClawbackEnabledFlag',
    value: 8,
  );
  static const List<AuthFlag> values = [
    requiredFlag,
    revocableFlag,
    immutableFlag,
    clawbackEnabledFlag,
  ];
  @override
  String toString() {
    return 'AuthFlag.$name';
  }

  static AuthFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'AuthFlag not found.',
                details: {
                  'flag': flag?.toString(),
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

class SorobanTransactionDataExt extends XDRVariantSerialization {
  final SorobanTransactionData? sorobanTransactionData;
  const SorobanTransactionDataExt({this.sorobanTransactionData});
  factory SorobanTransactionDataExt.fromXdr(
    List<int> bytes, {
    String? property,
  }) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return SorobanTransactionDataExt.fromStruct(decode);
  }
  factory SorobanTransactionDataExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const SorobanTransactionDataExt();
      case ExtensionPointType.extArgs1:
        return SorobanTransactionDataExt(
          sorobanTransactionData: SorobanTransactionData.fromStruct(
            decode.value,
          ),
        );
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 
          'Invalid SorobanTransactionData extension.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ExtensionPointType.extVoid.value,
        layout: LayoutConst.noArgs,
        property: ExtensionPointType.extVoid.name,
      ),
      LazyVariantModel(
        index: ExtensionPointType.extArgs1.value,
        layout: SorobanTransactionData.layout,
        property: ExtensionPointType.extArgs1.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    if (sorobanTransactionData != null) {
      return SorobanTransactionData.layout(property: property);
    }
    return LayoutConst.noArgs(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return sorobanTransactionData?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName {
    if (sorobanTransactionData == null) return ExtensionPointType.extVoid.name;
    return ExtensionPointType.extArgs1.name;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'sorobanTransactionData': sorobanTransactionData?.toJson()};
  }
}

class ExtensionPointType {
  final String name;
  final int value;
  const ExtensionPointType._({required this.name, required this.value});
  static const ExtensionPointType extVoid = ExtensionPointType._(
    name: 'extVoid',
    value: 0,
  );
  static const ExtensionPointType extArgs1 = ExtensionPointType._(
    name: 'extArgs1',
    value: 1,
  );
  static const ExtensionPointType extArgs2 = ExtensionPointType._(
    name: 'extArgs2',
    value: 2,
  );
  static const ExtensionPointType extArgs3 = ExtensionPointType._(
    name: 'extArgs3',
    value: 3,
  );
  static const List<ExtensionPointType> values = [
    extVoid,
    extArgs1,
    extArgs2,
    extArgs3,
  ];
  static ExtensionPointType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Asset type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

class StellarTransactionV1 extends StellarTransaction {
  final MuxedAccount sourceAccount;
  final int fee;
  @override
  final BigInt seqNum;
  final Preconditions cond;
  @override
  final StellarMemo memo;
  @override
  final List<Operation> operations;
  final SorobanTransactionDataExt sorobanData;

  StellarTransactionV1({
    required this.sourceAccount,
    required int fee,
    required BigInt seqNum,
    this.cond = const PrecondNone(),
    this.memo = const StellarMemoNone(),
    List<Operation> operations = const [],
    this.sorobanData = const SorobanTransactionDataExt(),
  }) : operations = operations.immutable.max(
         name: 'operations',
         length: StellarConst.maxTransactionOperationLength,
         operation: "StellarTransactionV1",
         reason: "Invalid operations length.",
       ),
       fee = fee.asU32,
       seqNum = seqNum.asI64,
       super(EnvelopeType.tx);

  factory StellarTransactionV1.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return StellarTransactionV1.fromStruct(decode);
  }
  factory StellarTransactionV1.fromStruct(Map<String, dynamic> json) {
    return StellarTransactionV1(
      sourceAccount: MuxedAccount.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('sourceAccount'),
      ),
      fee: json.valueAs('fee'),
      seqNum: json.valueAs('seqNum'),
      cond: Preconditions.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('cond'),
      ),
      memo: StellarMemo.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('memo'),
      ),
      operations:
          json
              .valueEnsureAsList<Map<String, dynamic>>('operations')
              .map((e) => Operation.fromStruct(e))
              .toList(),
      sorobanData: SorobanTransactionDataExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('sorobanData'),
      ),
    );
  }
  StellarTransactionV1 copyWith({
    MuxedAccount? sourceAccount,
    int? fee,
    BigInt? seqNum,
    Preconditions? cond,
    StellarMemo? memo,
    List<Operation>? operations,
    SorobanTransactionDataExt? sorobanData,
  }) {
    return StellarTransactionV1(
      sourceAccount: sourceAccount ?? this.sourceAccount,
      fee: fee ?? this.fee,
      seqNum: seqNum ?? this.seqNum,
      cond: cond ?? this.cond,
      memo: memo ?? this.memo,
      operations: operations ?? this.operations,
      sorobanData: sorobanData ?? this.sorobanData,
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedAccount.layout(property: 'sourceAccount'),
      LayoutConst.u32be(property: 'fee'),
      LayoutConst.s64be(property: 'seqNum'),
      Preconditions.layout(property: 'cond'),
      StellarMemo.layout(property: 'memo'),
      LayoutConst.xdrVec(Operation.layout(), property: 'operations'),
      SorobanTransactionDataExt.layout(property: 'sorobanData'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'sourceAccount': sourceAccount.toVariantLayoutStruct(),
      'fee': fee,
      'seqNum': seqNum,
      'cond': cond.toVariantLayoutStruct(),
      'memo': memo.toVariantLayoutStruct(),
      'operations': operations.map((e) => e.toLayoutStruct()).toList(),
      'sorobanData': sorobanData.toVariantLayoutStruct(),
    };
  }
}

class StellarTransactionV0 extends StellarTransaction {
  final StellarPublicKey sourceAccount;
  final int fee;
  @override
  final BigInt seqNum;
  final TimeBounds? timeBounds;
  @override
  final StellarMemo memo;
  @override
  final List<Operation> operations;
  final ExtentionPointVoid ext;

  StellarTransactionV0({
    required this.sourceAccount,
    required int fee,
    required BigInt seqNum,
    this.timeBounds,
    this.memo = const StellarMemoNone(),
    List<Operation> operations = const [],
    this.ext = const ExtentionPointVoid(),
  }) : operations = operations.immutable.max(
         length: StellarConst.maxTransactionOperationLength,
         name: 'operations',
         operation: "StellarTransactionV0",
         reason: "Invalid operations length.",
       ),
       fee = fee.asU32,
       seqNum = seqNum.asI64,
       super(EnvelopeType.txV0);

  factory StellarTransactionV0.fromStruct(Map<String, dynamic> json) {
    return StellarTransactionV0(
      sourceAccount: StellarPublicKey.fromPublicBytes(
        json.valueAs('sourceAccount'),
      ),
      fee: json.valueAs('fee'),
      seqNum: json.valueAs('seqNum'),
      timeBounds: json.valueTo<TimeBounds?, Map<String, dynamic>>(
        key: 'timeBounds',
        parse: (e) => TimeBounds.fromStruct(e),
      ),
      memo: StellarMemo.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('memo'),
      ),
      operations:
          json
              .valueEnsureAsList<Map<String, dynamic>>('operations')
              .map((e) => Operation.fromStruct(e))
              .toList(),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'sourceAccount',
      ),
      LayoutConst.u32be(property: 'fee'),
      LayoutConst.s64be(property: 'seqNum'),
      LayoutConst.optionalU32Be(TimeBounds.layout(), property: 'timeBounds'),
      StellarMemo.layout(property: 'memo'),
      LayoutConst.xdrVec(Operation.layout(), property: 'operations'),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'sourceAccount': sourceAccount.toBytes(),
      'fee': fee,
      'seqNum': seqNum,
      'timeBounds': timeBounds?.toLayoutStruct(),
      'memo': memo.toVariantLayoutStruct(),
      'operations': operations.map((e) => e.toLayoutStruct()).toList(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

class DecoratedSignature extends XDRSerialization {
  final BuBytes hint;
  final BuBytes signature;
  DecoratedSignature({required List<int> hint, required List<int> signature})
    : hint =
          hint
              .exc(
                length: StellarConst.pubkeyHintBytesLength,
                name: 'hint',
                operation: "DecoratedSignature",
                reason: "Invalid hint bytes length.",
              )
              .asImmutableBytes,
      signature =
          signature
              .max(
                length: StellarConst.ed25519SignatureLength,
                name: 'signature',
                operation: "DecoratedSignature",
                reason: "Invalid signature bytes length.",
              )
              .asImmutableBytes;

  factory DecoratedSignature.fromStruct(Map<String, dynamic> json) {
    return DecoratedSignature(
      hint: json.valueAs('hint'),
      signature: json.valueAs('signature'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.pubkeyHintBytesLength,
        property: 'hint',
      ),
      LayoutConst.xdrVecBytes(property: 'signature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hint': hint, 'signature': signature};
  }
}

/// XDR `StellarValueType` (stellar-xdr v30.0). The `signedMs` /
/// `emptyTxSetMs` arms (CAP-88) carry millisecond close times; every ledger
/// produced after the Protocol 30 upgrade uses one of them.
class StellarValueType {
  final String name;
  final int value;
  const StellarValueType._({required this.name, required this.value});

  static const basic = StellarValueType._(name: 'Basic', value: 0);
  static const signed = StellarValueType._(name: 'Signed', value: 1);
  static const emptyTxSet = StellarValueType._(name: 'EmptyTxSet', value: 2);
  static const signedMs = StellarValueType._(name: 'SignedMs', value: 3);
  static const emptyTxSetMs = StellarValueType._(
    name: 'EmptyTxSetMs',
    value: 4,
  );

  static const List<StellarValueType> values = [
    basic,
    signed,
    emptyTxSet,
    signedMs,
    emptyTxSetMs,
  ];
  static StellarValueType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'StellarValue type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'StellarValueType.$name';
  }
}

/// XDR `LedgerCloseValueSignature`: node id plus its signature.
class LedgerCloseValueSignature extends XDRSerialization {
  final StellarPublicKey nodeId;
  final BuBytes signature;
  LedgerCloseValueSignature({
    required this.nodeId,
    required List<int> signature,
  }) : signature = signature.asImmutableBytes;
  factory LedgerCloseValueSignature.fromStruct(Map<String, dynamic> json) {
    return LedgerCloseValueSignature(
      nodeId: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('nodeId'),
      ),
      signature: json.valueAs('signature'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: 'nodeId'),
      LayoutConst.xdrVecBytes(property: 'signature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'nodeId': nodeId.toLayoutStruct(), 'signature': signature};
  }
}

/// XDR `signedMsValue` (CAP-88): `closeTimeMs` is the full close time in
/// milliseconds; `closeTime` equals `closeTimeMs ~/ 1000`.
class StellarValueSignedMs extends XDRSerialization {
  final BigInt closeTimeMs;
  final LedgerCloseValueSignature lcValueSignature;
  StellarValueSignedMs({
    required BigInt closeTimeMs,
    required this.lcValueSignature,
  }) : closeTimeMs = closeTimeMs.asU64;
  factory StellarValueSignedMs.fromStruct(Map<String, dynamic> json) {
    return StellarValueSignedMs(
      closeTimeMs: json.valueAs('closeTimeMs'),
      lcValueSignature: LedgerCloseValueSignature.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('lcValueSignature'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'closeTimeMs'),
      LedgerCloseValueSignature.layout(property: 'lcValueSignature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'closeTimeMs': closeTimeMs,
      'lcValueSignature': lcValueSignature.toLayoutStruct(),
    };
  }
}

/// XDR `StellarValue` empty-tx-set body (shared by the `emptyTxSet` and
/// `emptyTxSetMs` arms; the latter additionally carries `closeTimeMs`).
class StellarValueEmptyTxSetBody extends XDRSerialization {
  final BuBytes txSetHash;
  final BuBytes previousLedgerHash;
  final int previousLedgerVersion;
  final LedgerCloseValueSignature lcValueSignature;
  StellarValueEmptyTxSetBody({
    required List<int> txSetHash,
    required List<int> previousLedgerHash,
    required int previousLedgerVersion,
    required this.lcValueSignature,
  }) : txSetHash =
           txSetHash
               .exc(
                 length: StellarConst.hash256Length,
                 name: 'txSetHash',
                 operation: 'StellarValueEmptyTxSetBody',
                 reason: 'Invalid txSetHash bytes length.',
               )
               .asImmutableBytes,
       previousLedgerHash =
           previousLedgerHash
               .exc(
                 length: StellarConst.hash256Length,
                 name: 'previousLedgerHash',
                 operation: 'StellarValueEmptyTxSetBody',
                 reason: 'Invalid previousLedgerHash bytes length.',
               )
               .asImmutableBytes,
       previousLedgerVersion = previousLedgerVersion.asU32;
  factory StellarValueEmptyTxSetBody.fromStruct(Map<String, dynamic> json) {
    return StellarValueEmptyTxSetBody(
      txSetHash: json.valueAs('txSetHash'),
      previousLedgerHash: json.valueAs('previousLedgerHash'),
      previousLedgerVersion: json.valueAs('previousLedgerVersion'),
      lcValueSignature: LedgerCloseValueSignature.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('lcValueSignature'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'txSetHash'),
      LayoutConst.fixedBlobN(
        StellarConst.hash256Length,
        property: 'previousLedgerHash',
      ),
      LayoutConst.u32be(property: 'previousLedgerVersion'),
      LedgerCloseValueSignature.layout(property: 'lcValueSignature'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'txSetHash': txSetHash,
      'previousLedgerHash': previousLedgerHash,
      'previousLedgerVersion': previousLedgerVersion,
      'lcValueSignature': lcValueSignature.toLayoutStruct(),
    };
  }
}

/// XDR `proposedMsValue` (CAP-88).
class StellarValueEmptyTxSetMs extends XDRSerialization {
  final BigInt closeTimeMs;
  final StellarValueEmptyTxSetBody body;
  StellarValueEmptyTxSetMs({required BigInt closeTimeMs, required this.body})
    : closeTimeMs = closeTimeMs.asU64;
  factory StellarValueEmptyTxSetMs.fromStruct(Map<String, dynamic> json) {
    return StellarValueEmptyTxSetMs(
      closeTimeMs: json.valueAs('closeTimeMs'),
      body: StellarValueEmptyTxSetBody.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('body'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'closeTimeMs'),
      StellarValueEmptyTxSetBody.layout(property: 'body'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'closeTimeMs': closeTimeMs, 'body': body.toLayoutStruct()};
  }
}

/// XDR `StellarValue`: the value SCP agrees on per ledger. Decoders built
/// against older XDR fail on Protocol 30 ledgers because every ledger after
/// the upgrade uses the `signedMs` / `emptyTxSetMs` arms (CAP-88).
class StellarValue extends XDRSerialization {
  /// Transaction set hash of the ledger.
  final BuBytes txSetHash;

  /// Whole-second close time (`closeTimeMs ~/ 1000` for ms arms).
  final BigInt closeTime;

  /// Upgrade entries (at most 6 opaque values of at most 128 bytes each).
  final List<BuBytes> upgrades;

  /// Consensus extension arm.
  final StellarValueExt ext;

  StellarValue({
    required List<int> txSetHash,
    required BigInt closeTime,
    required List<List<int>> upgrades,
    required this.ext,
  }) : txSetHash =
           txSetHash
               .exc(
                 length: StellarConst.hash256Length,
                 name: 'txSetHash',
                 operation: 'StellarValue',
                 reason: 'Invalid txSetHash bytes length.',
               )
               .asImmutableBytes,
       closeTime = closeTime.asU64,
       upgrades =
           upgrades.immutable
               .max(
                 length: 6,
                 name: 'upgrades',
                 operation: 'StellarValue',
                 reason: 'Invalid upgrades length.',
               )
               .map(
                 (e) =>
                     e
                         .max(
                           length: 128,
                           name: 'upgrade',
                           operation: 'StellarValue',
                           reason: 'Invalid upgrade bytes length.',
                         )
                         .asImmutableBytes,
               )
               .toList();

  /// The [StellarValueType] of [ext].
  StellarValueType get type => ext.type;

  factory StellarValue.fromStruct(Map<String, dynamic> json) {
    return StellarValue(
      txSetHash: (json.valueAs<List>('txSetHash')).cast<int>(),
      closeTime: json.valueAs('closeTime'),
      upgrades:
          (json.valueAs<List>(
            'upgrades',
          )).map((e) => (e as List).cast<int>()).toList(),
      ext: StellarValueExt.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'txSetHash'),
      LayoutConst.u64be(property: 'closeTime'),
      LayoutConst.xdrVec(LayoutConst.xdrVecBytes(), property: 'upgrades'),
      StellarValueExt.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'txSetHash': txSetHash,
      'closeTime': closeTime,
      'upgrades': upgrades,
      'ext': ext.toVariantLayoutStruct(),
    };
  }
}

/// XDR `StellarValue.ext` union. Kept as a separate type so the arm index
/// follows the XDR discriminant while [StellarValue] carries the shared body.
class StellarValueExt extends XDRVariantSerialization {
  final StellarValueType type;
  final XDRSerialization? value;
  const StellarValueExt._({required this.type, this.value});

  factory StellarValueExt.basic() =>
      const StellarValueExt._(type: StellarValueType.basic);

  factory StellarValueExt.signed(LedgerCloseValueSignature signature) =>
      StellarValueExt._(type: StellarValueType.signed, value: signature);

  factory StellarValueExt.emptyTxSet(StellarValueEmptyTxSetBody body) =>
      StellarValueExt._(type: StellarValueType.emptyTxSet, value: body);

  factory StellarValueExt.signedMs(StellarValueSignedMs body) =>
      StellarValueExt._(type: StellarValueType.signedMs, value: body);

  factory StellarValueExt.emptyTxSetMs(StellarValueEmptyTxSetMs body) =>
      StellarValueExt._(type: StellarValueType.emptyTxSetMs, value: body);

  factory StellarValueExt.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = StellarValueType.fromName(decode.variantName);
    switch (type) {
      case StellarValueType.basic:
        return StellarValueExt.basic();
      case StellarValueType.signed:
        return StellarValueExt._(
          type: type,
          value: LedgerCloseValueSignature.fromStruct(decode.value),
        );
      case StellarValueType.emptyTxSet:
        return StellarValueExt._(
          type: type,
          value: StellarValueEmptyTxSetBody.fromStruct(decode.value),
        );
      case StellarValueType.signedMs:
        return StellarValueExt._(
          type: type,
          value: StellarValueSignedMs.fromStruct(decode.value),
        );
      case StellarValueType.emptyTxSetMs:
        return StellarValueExt._(
          type: type,
          value: StellarValueEmptyTxSetMs.fromStruct(decode.value),
        );
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid StellarValue type.',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: StellarValueType.basic.value,
        layout: LayoutConst.noArgs,
        property: StellarValueType.basic.name,
      ),
      LazyVariantModel(
        index: StellarValueType.signed.value,
        layout: LedgerCloseValueSignature.layout,
        property: StellarValueType.signed.name,
      ),
      LazyVariantModel(
        index: StellarValueType.emptyTxSet.value,
        layout: StellarValueEmptyTxSetBody.layout,
        property: StellarValueType.emptyTxSet.name,
      ),
      LazyVariantModel(
        index: StellarValueType.signedMs.value,
        layout: StellarValueSignedMs.layout,
        property: StellarValueType.signedMs.name,
      ),
      LazyVariantModel(
        index: StellarValueType.emptyTxSetMs.value,
        layout: StellarValueEmptyTxSetMs.layout,
        property: StellarValueType.emptyTxSetMs.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    final v = value;
    if (v == null) return LayoutConst.noArgs(property: property);
    return v.createLayout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    final v = value;
    if (v == null) return {};
    if (v is XDRVariantSerialization) return v.toVariantLayoutStruct();
    return v.toLayoutStruct();
  }

  @override
  String get variantName => type.name;
}

class EnvelopeType {
  final String name;
  final int value;
  const EnvelopeType._(this.name, this.value);

  static const EnvelopeType txV0 = EnvelopeType._('txV0', 0);
  static const EnvelopeType scp = EnvelopeType._('scp', 1);
  static const EnvelopeType tx = EnvelopeType._('tx', 2);
  static const EnvelopeType auth = EnvelopeType._('auth', 3);
  static const EnvelopeType scpValue = EnvelopeType._('scpValue', 4);
  static const EnvelopeType txFeeBump = EnvelopeType._('txFeeBump', 5);
  static const EnvelopeType opId = EnvelopeType._('opId', 6);
  static const EnvelopeType poolRevokeOpId = EnvelopeType._(
    'poolRevokeOpId',
    7,
  );
  static const EnvelopeType contractId = EnvelopeType._('contractId', 8);
  static const EnvelopeType sorobanAuthorization = EnvelopeType._(
    'sorobanAuthorization',
    9,
  );

  static const List<EnvelopeType> values = [
    txV0,
    scp,
    tx,
    auth,
    scpValue,
    txFeeBump,
    opId,
    poolRevokeOpId,
    contractId,
    sorobanAuthorization,
  ];
  static EnvelopeType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Envelope type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'EnvelopeType.$name';
  }
}

abstract class Envelope<T extends StellarTransaction>
    extends XDRVariantSerialization {
  final EnvelopeType type;
  T get tx;
  List<DecoratedSignature> get signatures;
  const Envelope(this.type);
  Envelope copyWith({T? tx, List<DecoratedSignature>? signatures});

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(EnvelopeType.values.length, (index) {
        final type = EnvelopeType.values.elementAt(index);
        switch (type) {
          case EnvelopeType.txFeeBump:
            return LazyVariantModel(
              index: type.value,
              layout: FeeBumpTransactionEnvelope.layout,
              property: type.name,
            );
          case EnvelopeType.txV0:
            return LazyVariantModel(
              index: type.value,
              layout: TransactionV0Envelope.layout,
              property: type.name,
            );
          case EnvelopeType.tx:
            return LazyVariantModel(
              index: type.value,
              layout: TransactionV1Envelope.layout,
              property: type.name,
            );
          default:
            return LazyVariantModel(
              index: type.value,
              layout:
                  ({property}) =>
                      throw BuError(DefaultErrorType.unsupported, 
                        'Envelope type is not supported.',
                        details: {'type': type.name, 'property': property},
                      ),
              property: type.name,
            );
        }
      }),
      property: property,
    );
  }

  factory Envelope.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = EnvelopeType.fromName(decode.variantName);
    Envelope envlope;
    switch (type) {
      case EnvelopeType.txV0:
        envlope = TransactionV0Envelope.fromStruct(decode.value);
        break;
      case EnvelopeType.tx:
        envlope = TransactionV1Envelope.fromStruct(decode.value);
        break;
      case EnvelopeType.txFeeBump:
        envlope = FeeBumpTransactionEnvelope.fromStruct(decode.value);
        break;
      default:
        throw BuError(DefaultErrorType.unsupported, 
          'Envelope type is not supported.',
          details: {'type': type.name},
        );
    }
    if (envlope is! Envelope<T>) {
      throw BuError(DefaultErrorType.castFailed, 
        'Envelope casting failed.',
        details: {
          'expected': 'Envelope<$T>',
          'envelope': envlope.runtimeType.toString(),
        },
      );
    }
    return envlope;
  }
  factory Envelope.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return Envelope.fromStruct(decode);
  }
  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  E cast<E extends Envelope<T>>() {
    if (this is! E) {
      throw BuError(DefaultErrorType.castFailed, 
        'Incorrect Envelope casting.',
        details: {'expected': '$E', 'type': '$runtimeType'},
      );
    }
    return this as E;
  }

  String txId(List<int> networkIdHash) {
    final payload = TransactionSignaturePayload(
      networkId: networkIdHash,
      taggedTransaction: tx,
    );
    return payload.txId();
  }
}

class TransactionV0Envelope extends Envelope<StellarTransactionV0> {
  @override
  final StellarTransactionV0 tx;
  @override
  final List<DecoratedSignature> signatures;
  TransactionV0Envelope({
    required this.tx,
    required List<DecoratedSignature> signatures,
  }) : signatures = signatures.immutable.max(
         length: StellarConst.envlopSignaturesLength,
         name: 'signatures',
         operation: "TransactionV0Envelope",
         reason: "Invalid signatures length.",
       ),
       super(EnvelopeType.txV0);

  factory TransactionV0Envelope.fromStruct(Map<String, dynamic> json) {
    return TransactionV0Envelope(
      tx: StellarTransactionV0.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('tx'),
      ),
      signatures:
          json
              .valueEnsureAsList<Map<String, dynamic>>('signatures')
              .map((e) => DecoratedSignature.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarTransactionV0.layout(property: 'tx'),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: 'signatures'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'tx': tx.toLayoutStruct(),
      'signatures': signatures.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  TransactionV0Envelope copyWith({
    StellarTransactionV0? tx,
    List<DecoratedSignature>? signatures,
  }) {
    return TransactionV0Envelope(
      tx: tx ?? this.tx,
      signatures: signatures ?? this.signatures,
    );
  }
}

class TransactionV1Envelope extends Envelope<StellarTransactionV1> {
  @override
  final StellarTransactionV1 tx;
  @override
  final List<DecoratedSignature> signatures;
  TransactionV1Envelope({
    required this.tx,
    required List<DecoratedSignature> signatures,
  }) : signatures = signatures.immutable.max(
         length: StellarConst.envlopSignaturesLength,
         name: 'signatures',
         operation: "TransactionV1Envelope",
         reason: "Invalid signatures length.",
       ),
       super(EnvelopeType.tx);
  factory TransactionV1Envelope.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return TransactionV1Envelope.fromStruct(decode);
  }
  factory TransactionV1Envelope.fromStruct(Map<String, dynamic> json) {
    return TransactionV1Envelope(
      tx: StellarTransactionV1.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('tx'),
      ),
      signatures:
          json
              .valueEnsureAsList<Map<String, dynamic>>('signatures')
              .map((e) => DecoratedSignature.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarTransactionV1.layout(property: 'tx'),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: 'signatures'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'tx': tx.toLayoutStruct(),
      'signatures': signatures.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  TransactionV1Envelope copyWith({
    StellarTransactionV1? tx,
    List<DecoratedSignature>? signatures,
  }) {
    return TransactionV1Envelope(
      tx: tx ?? this.tx,
      signatures: signatures ?? this.signatures,
    );
  }
}

class StellarFeeBumpTransaction extends StellarTransaction {
  final MuxedAccount feeSource;
  final BigInt fee;
  final TransactionV1Envelope innerTx;
  final ExtentionPointVoid ext;
  StellarFeeBumpTransaction({
    required this.feeSource,
    required BigInt fee,
    required this.innerTx,
    this.ext = const ExtentionPointVoid(),
  }) : fee = fee.asI64,
       super(EnvelopeType.txFeeBump);
  factory StellarFeeBumpTransaction.fromStruct(Map<String, dynamic> json) {
    return StellarFeeBumpTransaction(
      feeSource: MuxedAccount.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('feeSource'),
      ),
      fee: json.valueAs('fee'),
      innerTx:
          Envelope.fromStruct(
            json.valueEnsureAsMap<String, dynamic>('innerTx'),
          ).cast(),
      ext: ExtentionPointVoid.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('ext'),
      ),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedAccount.layout(property: 'feeSource'),
      LayoutConst.s64be(property: 'fee'),
      Envelope.layout(property: 'innerTx'),
      ExtentionPointVoid.layout(property: 'ext'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'feeSource': feeSource.toVariantLayoutStruct(),
      'fee': fee,
      'innerTx': innerTx.toVariantLayoutStruct(),
      'ext': ext.toVariantLayoutStruct(),
    };
  }

  @override
  StellarMemo get memo => innerTx.tx.memo;
  @override
  List<Operation<OperationBody>> get operations => innerTx.tx.operations;
  @override
  BigInt get seqNum => innerTx.tx.seqNum;
}

class FeeBumpTransactionEnvelope extends Envelope<StellarFeeBumpTransaction> {
  @override
  final StellarFeeBumpTransaction tx;
  @override
  final List<DecoratedSignature> signatures;
  FeeBumpTransactionEnvelope({
    required this.tx,
    required List<DecoratedSignature> signatures,
  }) : signatures = signatures.immutable.max(
         length: StellarConst.envlopSignaturesLength,
         name: 'signatures',
         operation: "FeeBumpTransactionEnvelope",
         reason: "Invalid signatures length.",
       ),
       super(EnvelopeType.txFeeBump);

  factory FeeBumpTransactionEnvelope.fromStruct(Map<String, dynamic> json) {
    return FeeBumpTransactionEnvelope(
      tx: StellarFeeBumpTransaction.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('tx'),
      ),
      signatures:
          json
              .valueEnsureAsList<Map<String, dynamic>>('signatures')
              .map((e) => DecoratedSignature.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarFeeBumpTransaction.layout(property: 'tx'),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: 'signatures'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'tx': tx.toLayoutStruct(),
      'signatures': signatures.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  FeeBumpTransactionEnvelope copyWith({
    StellarFeeBumpTransaction? tx,
    List<DecoratedSignature>? signatures,
  }) {
    return FeeBumpTransactionEnvelope(
      tx: tx ?? this.tx,
      signatures: signatures ?? this.signatures,
    );
  }
}

abstract class StellarTransaction extends XDRVariantSerialization {
  final EnvelopeType type;
  StellarMemo get memo;
  List<Operation> get operations;
  BigInt get seqNum;
  const StellarTransaction(this.type);
  factory StellarTransaction.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return StellarTransaction.fromStruct(decode);
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(EnvelopeType.values.length, (index) {
        final type = EnvelopeType.values.elementAt(index);
        switch (type) {
          case EnvelopeType.txFeeBump:
            return LazyVariantModel(
              index: type.value,
              layout: StellarFeeBumpTransaction.layout,
              property: type.name,
            );
          case EnvelopeType.tx:
            return LazyVariantModel(
              index: type.value,
              layout: StellarTransactionV1.layout,
              property: type.name,
            );
          case EnvelopeType.txV0:
            return LazyVariantModel(
              index: type.value,
              layout: StellarTransactionV0.layout,
              property: type.name,
            );
          default:
            return LazyVariantModel(
              index: type.value,
              layout:
                  ({property}) =>
                      throw BuError(DefaultErrorType.unsupported, 
                        'Transaction type is not supported.',
                        details: {'type': type.name, 'property': property},
                      ),
              property: type.name,
            );
        }
      }),
      property: property,
    );
  }

  factory StellarTransaction.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = EnvelopeType.fromName(decode.variantName);
    switch (type) {
      case EnvelopeType.tx:
        return StellarTransactionV1.fromStruct(decode.value);
      case EnvelopeType.txV0:
        return StellarTransactionV0.fromStruct(decode.value);
      case EnvelopeType.txFeeBump:
        return StellarFeeBumpTransaction.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.unsupported, 
          'Transaction type is not supported.',
          details: {'type': type.name},
        );
    }
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  T cast<T extends StellarTransaction>() {
    if (this is! T) {
      throw BuError(DefaultErrorType.castFailed, 
        'Incorrect StellarTransaction casting.',
        details: {'expected': '$T', 'type': '$runtimeType'},
      );
    }
    return this as T;
  }
}

class TransactionSignaturePayload extends XDRSerialization {
  final BuBytes networkId;
  final StellarTransaction taggedTransaction;
  TransactionSignaturePayload({
    required List<int> networkId,
    required this.taggedTransaction,
  }) : networkId =
           networkId
               .exc(
                 length: StellarConst.hash256Length,
                 name: 'networkId',
                 operation: "TransactionSignaturePayload",
                 reason: "Invalid networkId bytes length.",
               )
               .asImmutableBytes;
  factory TransactionSignaturePayload.fromXdr(
    List<int> bytes, {
    String? property,
  }) {
    final decode = XDRSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return TransactionSignaturePayload.fromStruct(decode);
  }
  factory TransactionSignaturePayload.fromStruct(Map<String, dynamic> json) {
    return TransactionSignaturePayload(
      networkId: json.valueAs('networkId'),
      taggedTransaction: StellarTransaction.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('taggedTransaction'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'networkId'),
      StellarTransaction.layout(property: 'taggedTransaction'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'networkId': networkId,
      'taggedTransaction': taggedTransaction.toVariantLayoutStruct(),
    };
  }

  BuBytes txHash() {
    return QuickCrypto.sha256Hash(toXDR());
  }

  String txId() {
    return BytesUtils.toHexString(txHash());
  }
}

class MemoType {
  final String name;
  final int value;

  const MemoType._(this.name, this.value);

  static const MemoType none = MemoType._('none', 0);
  static const MemoType text = MemoType._('text', 1);
  static const MemoType id = MemoType._('id', 2);
  static const MemoType hash = MemoType._('hash', 3);
  static const MemoType returnHash = MemoType._('returnHash', 4);
  static List<MemoType> values = [none, text, id, hash, returnHash];
  static MemoType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Asset type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'MemoType.$name';
  }
}

abstract class StellarMemo extends XDRVariantSerialization {
  final MemoType type;
  const StellarMemo({required this.type});
  factory StellarMemo.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = MemoType.fromName(decode.variantName);
    switch (type) {
      case MemoType.none:
        return StellarMemoNone.fromStruct(decode.value);
      case MemoType.returnHash:
        return StellarMemoReturnHash.fromStruct(decode.value);
      case MemoType.hash:
        return StellarMemoHash.fromStruct(decode.value);
      case MemoType.id:
        return StellarMemoID.fromStruct(decode.value);
      case MemoType.text:
        return StellarMemoText.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid Memo type.',
          details: {'type': type.name},
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: MemoType.none.value,
        layout: StellarMemoNone.layout,
        property: MemoType.none.name,
      ),
      LazyVariantModel(
        index: MemoType.text.value,
        layout: StellarMemoText.layout,
        property: MemoType.text.name,
      ),
      LazyVariantModel(
        index: MemoType.id.value,
        layout: StellarMemoID.layout,
        property: MemoType.id.name,
      ),
      LazyVariantModel(
        index: MemoType.hash.value,
        layout: StellarMemoHash.layout,
        property: MemoType.hash.name,
      ),
      LazyVariantModel(
        index: MemoType.returnHash.value,
        layout: StellarMemoReturnHash.layout,
        property: MemoType.returnHash.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  T cast<T extends StellarMemo>() {
    if (this is! T) {
      throw BuError(DefaultErrorType.castFailed, 
        'Stellar memo casting failed.',
        details: {'expected': '$T', 'type': runtimeType.toString()},
      );
    }
    return this as T;
  }
}

class StellarMemoReturnHash extends StellarMemo {
  final BuBytes hash;
  StellarMemoReturnHash(List<int> hash)
    : hash =
          hash
              .exc(
                length: StellarConst.hash256Length,
                name: 'hash',
                operation: "StellarMemoReturnHash",
                reason: "Invalid hash bytes length.",
              )
              .asImmutableBytes,
      super(type: MemoType.returnHash);
  factory StellarMemoReturnHash.fromStruct(Map<String, dynamic> json) {
    return StellarMemoReturnHash(json.valueAs('hash'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash};
  }
}

class StellarMemoHash extends StellarMemo {
  final BuBytes hash;
  StellarMemoHash(List<int> hash)
    : hash =
          hash
              .exc(
                length: StellarConst.hash256Length,
                name: 'hash',
                operation: "StellarMemoHash",
                reason: "Invalid hash bytes length.",
              )
              .asImmutableBytes,
      super(type: MemoType.hash);
  factory StellarMemoHash.fromStruct(Map<String, dynamic> json) {
    return StellarMemoHash(json.valueAs('hash'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'hash'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hash': hash};
  }
}

class StellarMemoID extends StellarMemo {
  final BigInt id;
  StellarMemoID(BigInt id) : id = id.asU64, super(type: MemoType.id);
  factory StellarMemoID.fromStruct(Map<String, dynamic> json) {
    return StellarMemoID(json.valueAs('id'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: 'id'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'id': id};
  }
}

class StellarMemoText extends StellarMemo {
  final String text;
  StellarMemoText(String text)
    : text = StellarValidator.validateString(value: text, max: 28),
      super(type: MemoType.text);

  factory StellarMemoText.fromStruct(Map<String, dynamic> json) {
    return StellarMemoText(json.valueAs('text'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'text'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'text': text};
  }
}

class StellarMemoNone extends StellarMemo {
  const StellarMemoNone() : super(type: MemoType.none);

  factory StellarMemoNone.fromStruct(Map<String, dynamic> json) {
    return const StellarMemoNone();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }
}

class SignerKeyType {
  final String name;
  final int value;

  const SignerKeyType._({required this.name, required this.value});

  static const SignerKeyType ed25519 = SignerKeyType._(
    name: 'ed25519',
    value: 0,
  );
  static const SignerKeyType preAuthTx = SignerKeyType._(
    name: 'preAuthTx',
    value: 1,
  );
  static const SignerKeyType hashX = SignerKeyType._(name: 'hashX', value: 2);
  static const SignerKeyType ed25519SignedPayload = SignerKeyType._(
    name: 'ed25519SignedPayload',
    value: 3,
  );
  static const List<SignerKeyType> values = [
    ed25519,
    preAuthTx,
    hashX,
    ed25519SignedPayload,
  ];
  static SignerKeyType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'SignerKey type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  @override
  String toString() {
    return 'SignerKeyType.$name';
  }
}

abstract class SignerKey extends XDRVariantSerialization {
  final SignerKeyType type;
  const SignerKey({required this.type});
  factory SignerKey.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = SignerKeyType.fromName(decode.variantName);
    switch (type) {
      case SignerKeyType.ed25519:
        return SignerKeyEd25519.fromStruct(decode.value);
      case SignerKeyType.hashX:
        return SignerKeyHashX.fromStruct(decode.value);
      case SignerKeyType.preAuthTx:
        return SignerKeyPreAuthTx.fromStruct(decode.value);
      case SignerKeyType.ed25519SignedPayload:
        return SignerKeyEd25519SignedPayload.fromStruct(decode.value);
      default:
        throw BuError(DefaultErrorType.invalidArgument, 
          'Invalid SignerKeyType "${type.name}".',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(SignerKeyType.values.length, (index) {
        final type = SignerKeyType.values.elementAt(index);
        switch (type) {
          case SignerKeyType.ed25519:
            return LazyVariantModel(
              index: type.value,
              layout: SignerKeyEd25519.layout,
              property: type.name,
            );
          case SignerKeyType.hashX:
            return LazyVariantModel(
              index: type.value,
              layout: SignerKeyHashX.layout,
              property: type.name,
            );
          case SignerKeyType.preAuthTx:
            return LazyVariantModel(
              index: type.value,
              layout: SignerKeyPreAuthTx.layout,
              property: type.name,
            );
          case SignerKeyType.ed25519SignedPayload:
            return LazyVariantModel(
              index: type.value,
              layout: SignerKeyEd25519SignedPayload.layout,
              property: type.name,
            );
          default:
            throw BuError(DefaultErrorType.invalidArgument, 
              'Invalid SignerKeyType "${type.name}".',
            );
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class SignerKeyEd25519SignedPayload extends SignerKey {
  final BuBytes ed25519;
  final BuBytes payload;
  SignerKeyEd25519SignedPayload({
    required List<int> ed25519,
    required List<int> payload,
  }) : ed25519 =
           ed25519
               .exc(
                 length: StellarConst.ed25519PubKeyLength,
                 name: 'ed25519',
                 operation: "SignerKeyEd25519SignedPayload",
                 reason: "Invalid ed25519 bytes length.",
               )
               .asImmutableBytes,
       payload =
           payload
               .max(
                 length: StellarConst.payloadLength,
                 name: 'payload',
                 operation: "SignerKeyEd25519SignedPayload",
                 reason: "Invalid payload bytes length.",
               )
               .asImmutableBytes,
       super(type: SignerKeyType.ed25519SignedPayload);

  factory SignerKeyEd25519SignedPayload.fromStruct(Map<String, dynamic> json) {
    return SignerKeyEd25519SignedPayload(
      ed25519: json.valueAs('ed25519'),
      payload: json.valueAs('payload'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.ed25519PubKeyLength,
        property: 'ed25519',
      ),
      LayoutConst.xdrVecBytes(property: 'payload'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ed25519': ed25519, 'payload': payload};
  }
}

class SignerKeyEd25519 extends SignerKey {
  final BuBytes ed25519;
  SignerKeyEd25519(List<int> ed25519)
    : ed25519 =
          ed25519
              .exc(
                length: StellarConst.ed25519PubKeyLength,
                name: 'ed25519',
                operation: "SignerKeyEd25519",
                reason: "Invalid ed25519 bytes length.",
              )
              .asImmutableBytes,
      super(type: SignerKeyType.ed25519);

  factory SignerKeyEd25519.fromStruct(Map<String, dynamic> json) {
    return SignerKeyEd25519(json.valueAs('ed25519'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.ed25519PubKeyLength,
        property: 'ed25519',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'ed25519': ed25519};
  }
}

class SignerKeyPreAuthTx extends SignerKey {
  final BuBytes preAuthTx;
  SignerKeyPreAuthTx(List<int> preAuthTx)
    : preAuthTx =
          preAuthTx
              .exc(
                length: StellarConst.hash256Length,
                name: 'preAuthTx',
                operation: "SignerKeyPreAuthTx",
                reason: "Invalid preAuthTx bytes length.",
              )
              .asImmutableBytes,
      super(type: SignerKeyType.preAuthTx);

  factory SignerKeyPreAuthTx.fromStruct(Map<String, dynamic> json) {
    return SignerKeyPreAuthTx(json.valueAs('preAuthTx'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.ed25519PubKeyLength,
        property: 'preAuthTx',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'preAuthTx': preAuthTx};
  }
}

class SignerKeyHashX extends SignerKey {
  final BuBytes hashX;
  SignerKeyHashX(List<int> hashX)
    : hashX =
          hashX
              .exc(
                length: StellarConst.hash256Length,
                name: 'hashX',
                operation: "SignerKeyHashX",
                reason: "Invalid hashX bytes length.",
              )
              .asImmutableBytes,
      super(type: SignerKeyType.hashX);

  factory SignerKeyHashX.fromStruct(Map<String, dynamic> json) {
    return SignerKeyHashX(json.valueAs('hashX'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        StellarConst.ed25519PubKeyLength,
        property: 'hashX',
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'hashX': hashX};
  }
}

class Signer extends XDRSerialization {
  final SignerKey key;
  final int weight;
  Signer({required this.key, required int weight}) : weight = weight.asU32;
  factory Signer.fromStruct(Map<String, dynamic> json) {
    return Signer(
      key: SignerKey.fromStruct(json.valueEnsureAsMap<String, dynamic>('key')),
      weight: json.valueAs('weight'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      SignerKey.layout(property: 'key'),
      LayoutConst.u32be(property: 'weight'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'key': key.toVariantLayoutStruct(), 'weight': weight};
  }
}

class _StellarAssetConst {
  static const int creditAlphanum4Length = 4;
  static const int creditAlphanum12Length = 12;
}

class AssetType {
  final int value;
  final String name;
  const AssetType._({required this.value, required this.name});

  static const AssetType native = AssetType._(value: 0, name: 'Native');
  static const AssetType creditAlphanum4 = AssetType._(
    name: 'CreditAlphanum4',
    value: 1,
  );
  static const AssetType creditAlphanum12 = AssetType._(
    value: 2,
    name: 'CreditAlphanum12',
  );
  static const AssetType poolShare = AssetType._(value: 3, name: 'PoolShare');

  static const List<AssetType> values = [
    native,
    creditAlphanum4,
    creditAlphanum12,
    poolShare,
  ];
  bool get isNative => this == native;

  @override
  String toString() {
    return 'AssetType.$name';
  }

  static AssetType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(DefaultErrorType.notFound, 
                'Asset type not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }
}

abstract class StellarAsset extends XDRVariantSerialization {
  final AssetType type;
  const StellarAsset({required this.type});
  factory StellarAsset.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = AssetType.fromName(decode.variantName);
    switch (type) {
      case AssetType.native:
        return StellarAssetNative.fromStruct(decode.value);
      case AssetType.creditAlphanum12:
        return StellarAssetCreditAlphanum12.fromStruct(decode.value);
      case AssetType.creditAlphanum4:
        return StellarAssetCreditAlphanum4.fromStruct(decode.value);
      case AssetType.poolShare:
        return StellarAssetPoolShare.fromStruct(decode.value);
      default:
        throw const BuError(DefaultErrorType.invalidArgument, 'Invalid AssetType.');
    }
  }
  factory StellarAsset.fromXdr(List<int> bytes, {String? property}) {
    final json = XDRVariantSerialization.deserialize(
      bytes: bytes,
      layout: layout(property: property),
    );
    return StellarAsset.fromStruct(json);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
      List.generate(AssetType.values.length, (index) {
        final type = AssetType.values.elementAt(index);
        switch (type) {
          case AssetType.native:
            return LazyVariantModel(
              index: type.value,
              layout: StellarAssetNative.layout,
              property: type.name,
            );
          case AssetType.creditAlphanum12:
            return LazyVariantModel(
              index: type.value,
              layout: StellarAssetCreditAlphanum12.layout,
              property: type.name,
            );
          case AssetType.creditAlphanum4:
            return LazyVariantModel(
              index: type.value,
              layout: StellarAssetCreditAlphanum4.layout,
              property: type.name,
            );
          case AssetType.poolShare:
            return LazyVariantModel(
              index: type.value,
              layout: StellarAssetPoolShare.layout,
              property: type.name,
            );
          default:
            throw const BuError(DefaultErrorType.invalidArgument, 'Invalid AssetType.');
        }
      }),
      property: property,
    );
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  T cast<T extends StellarAsset>() {
    if (this is! T) {
      throw BuError(DefaultErrorType.castFailed, 
        'Stellar asset casting failed.',
        details: {'expected': '$T', 'asset': runtimeType.toString()},
      );
    }
    return this as T;
  }
}

class StellarAssetCreditAlphanum4 extends StellarAsset {
  final StellarPublicKey issuer;
  final String code;
  StellarAssetCreditAlphanum4._({required this.issuer, required this.code})
    : super(type: AssetType.creditAlphanum4);
  factory StellarAssetCreditAlphanum4({
    required StellarPublicKey issuer,
    required String code,
  }) {
    return StellarAssetCreditAlphanum4._(
      issuer: issuer,
      code: StellarValidator.validateAssetCode(
        code,
        length: _StellarAssetConst.creditAlphanum4Length,
      ),
    );
  }
  factory StellarAssetCreditAlphanum4.fromStruct(Map<String, dynamic> json) {
    final code = StellarHelper.toAssetsCode(json.valueAs('code'));
    return StellarAssetCreditAlphanum4(
      issuer: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('issuer'),
      ),
      code: code,
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        _StellarAssetConst.creditAlphanum4Length,
        property: 'code',
      ),
      StellarPublicKey.layout(property: 'issuer'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'issuer': issuer.toLayoutStruct(),
      'code': StellarHelper.toAlphanumAssetCode(
        code: code,
        length: _StellarAssetConst.creditAlphanum4Length,
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {'issuer': issuer.toAddress().toString(), 'name': code};
  }

  @override
  bool operator ==(other) {
    if (other is! StellarAssetCreditAlphanum4) return false;
    return code == other.code && issuer == other.issuer;
  }

  @override
  int get hashCode => code.hashCode ^ issuer.hashCode ^ type.hashCode;
}

class StellarAssetCreditAlphanum12 extends StellarAsset {
  final StellarPublicKey issuer;
  final String code;
  StellarAssetCreditAlphanum12._({required this.issuer, required this.code})
    : super(type: AssetType.creditAlphanum12);
  factory StellarAssetCreditAlphanum12({
    required StellarPublicKey issuer,
    required String code,
  }) {
    return StellarAssetCreditAlphanum12._(
      issuer: issuer,
      code: StellarValidator.validateAssetCode(
        code,
        length: _StellarAssetConst.creditAlphanum12Length,
      ),
    );
  }
  factory StellarAssetCreditAlphanum12.fromStruct(Map<String, dynamic> json) {
    return StellarAssetCreditAlphanum12(
      issuer: StellarPublicKey.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('issuer'),
      ),
      code: StellarHelper.toAssetsCode(json.valueAs('code')),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(
        _StellarAssetConst.creditAlphanum12Length,
        property: 'code',
      ),
      StellarPublicKey.layout(property: 'issuer'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'issuer': issuer.toLayoutStruct(),
      'code': StellarHelper.toAlphanumAssetCode(
        code: code,
        length: _StellarAssetConst.creditAlphanum12Length,
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {'issuer': issuer.toAddress().toString(), 'name': code};
  }

  @override
  bool operator ==(other) {
    if (other is! StellarAssetCreditAlphanum12) return false;
    return code == other.code && issuer == other.issuer;
  }

  @override
  int get hashCode => code.hashCode ^ issuer.hashCode ^ type.hashCode;
}

class StellarAssetNative extends StellarAsset {
  final String code = 'XLM';
  StellarAssetNative() : super(type: AssetType.native);
  factory StellarAssetNative.fromStruct(Map<String, dynamic> json) {
    return StellarAssetNative();
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': code};
  }

  @override
  bool operator ==(other) {
    if (other is! StellarAssetNative) return false;
    return true;
  }

  @override
  int get hashCode => code.hashCode ^ type.hashCode;
}

/// should not be used in some models
class StellarAssetPoolShare extends StellarAsset {
  final BuBytes poolID;
  StellarAssetPoolShare(List<int> poolID)
    : poolID =
          poolID
              .max(
                length: StellarConst.hash256Length,
                name: 'poolID',
                operation: "StellarAssetPoolShare",
                reason: "Invalid poolID bytes length.",
              )
              .asImmutableBytes,
      super(type: AssetType.poolShare);
  factory StellarAssetPoolShare.fromStruct(Map<String, dynamic> json) {
    return StellarAssetPoolShare(json.valueAs('poolId'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: 'poolId'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'poolId': poolID};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'poolId': BytesUtils.toHexString(poolID, prefix: '0x')};
  }

  @override
  bool operator ==(other) {
    if (other is! StellarAssetPoolShare) return false;
    return BytesUtils.bytesEqual(poolID, other.poolID);
  }

  @override
  int get hashCode =>
      poolID.fold<int>(0, (p, c) => p ^ c).hashCode ^ type.hashCode;
}
