import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/helper/helper.dart';
import 'package:stellar_dart/src/keypair/keypair.dart';
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
  static const LedgerEntryType claimableBalance =
      LedgerEntryType._('claimableBalance', 4);
  static const LedgerEntryType liquidityPool =
      LedgerEntryType._('liquidityPool', 5);
  static const LedgerEntryType contractData =
      LedgerEntryType._('contractData', 6);
  static const LedgerEntryType contractCode =
      LedgerEntryType._('contractCode', 7);
  static const LedgerEntryType configSetting =
      LedgerEntryType._('configSetting', 8);
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
    ttl
  ];
  static LedgerEntryType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "LedgerEntry type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "LedgerEntryType.$name";
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
        return TTLEntery.fromStruct(decode.value);
      default:
        throw DartStellarPlugingException("Invalid LedgerEntry type.",
            details: {"type": type.name});
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
                  index: type.value);
            case LedgerEntryType.trustline:
              return LazyVariantModel(
                  layout: TrustLineEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.offer:
              return LazyVariantModel(
                  layout: OfferEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.data:
              return LazyVariantModel(
                  layout: DataEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.claimableBalance:
              return LazyVariantModel(
                  layout: ClaimableBalanceEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.liquidityPool:
              return LazyVariantModel(
                  layout: LiquidityPoolEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.contractData:
              return LazyVariantModel(
                  layout: ContractDataEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.contractCode:
              return LazyVariantModel(
                  layout: ContractCodeEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.configSetting:
              return LazyVariantModel(
                  layout: ConfigSettingEntry.layout,
                  property: type.name,
                  index: type.value);
            case LedgerEntryType.ttl:
              return LazyVariantModel(
                  layout: TTLEntery.layout,
                  property: type.name,
                  index: type.value);
            default:
              throw DartStellarPlugingException("Invalid LedgerEntry type.",
                  details: {"type": type.name});
          }
        }),
        property: property);
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
      : buying = buying.asInt64,
        selling = selling.asInt64;
  factory Liabilities.fromStruct(Map<String, dynamic> json) {
    return Liabilities(buying: json.as("buying"), selling: json.as("selling"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "buying"),
      LayoutConst.s64be(property: "selling"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"buying": buying, "selling": selling};
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
  final List<int> thresholds;
  final List<Signer> signers;
  final AccountEntryExt ext;
  AccountEntry(
      {required this.accountId,
      required BigInt balance,
      required BigInt seqNum,
      required int numSubEntries,
      this.inflationDest,
      required int flags,
      required String homeDomain,
      required List<int> thresholds,
      required List<Signer> signers,
      required this.ext})
      : homeDomain = homeDomain.max(32),
        thresholds = thresholds.asImmutableBytes.max(4, name: "thresholds"),
        signers = signers.immutable,
        balance = balance.asInt64,
        seqNum = seqNum.asInt64,
        flags = flags.asUint32,
        numSubEntries = numSubEntries.asUint32,
        super(LedgerEntryType.account);
  factory AccountEntry.fromStruct(Map<String, dynamic> json) {
    return AccountEntry(
        accountId: StellarPublicKey.fromStruct(json.asMap("accountId")),
        balance: json.as("balance"),
        seqNum: json.as("seqNum"),
        numSubEntries: json.as("numSubEntries"),
        flags: json.as("flags"),
        homeDomain: json.as("homeDomain"),
        signers: json
            .asListOfMap("signers")!
            .map((e) => Signer.fromStruct(e))
            .toList(),
        thresholds: json.asBytes("thresholds"),
        ext: AccountEntryExt.fromStruct(json.asMap("ext")),
        inflationDest: json.mybeAs<StellarPublicKey, Map<String, dynamic>>(
            key: "inflationDest",
            onValue: (p0) => StellarPublicKey.fromStruct(p0)));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      LayoutConst.s64be(property: "balance"),
      LayoutConst.s64be(property: "seqNum"),
      LayoutConst.u32be(property: "numSubEntries"),
      LayoutConst.optionalU32Be(StellarPublicKey.layout(),
          property: "inflationDest"),
      LayoutConst.u32be(property: "flags"),
      LayoutConst.xdrString(property: "homeDomain"),
      LayoutConst.fixedBlobN(StellarConst.thresHoldsLen,
          property: "thresholds"),
      LayoutConst.xdrVec(Signer.layout(), property: "signers"),
      AccountEntryExt.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "signers": signers.map((e) => e.toLayoutStruct()).toList(),
      "thresholds": thresholds,
      "homeDomain": homeDomain,
      "flags": flags,
      "inflationDest": inflationDest?.toLayoutStruct(),
      "numSubEntries": numSubEntries,
      "seqNum": seqNum,
      "balance": balance,
      "accountId": accountId.toLayoutStruct(),
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
          property: ExtensionPointType.extVoid.name),
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
  AccountEntryExtensionV3(
      {required int seqLedger,
      required BigInt seqTime,
      this.ext = const ExtentionPointVoid()})
      : seqTime = seqTime.asUint64,
        seqLedger = seqLedger.asUint32;
  factory AccountEntryExtensionV3.fromStruct(Map<String, dynamic> json) {
    return AccountEntryExtensionV3(
        seqLedger: json.as("seqLedger"),
        seqTime: json.as("seqTime"),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      LayoutConst.u32be(property: "seqLedger"),
      LayoutConst.u64be(property: "seqTime")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "seqLedger": seqLedger,
      "seqTime": seqTime
    };
  }
}

class AccountEntryExtensionV3Ext extends XDRVariantSerialization {
  final AccountEntryExtensionV3? v3;
  const AccountEntryExtensionV3Ext({this.v3});
  factory AccountEntryExtensionV3Ext.fromXdr(List<int> bytes,
      {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
            v3: AccountEntryExtensionV3.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid AccountEntryExtensionV3Ext extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs3.value,
          layout: AccountEntryExtensionV3.layout,
          property: ExtensionPointType.extArgs3.name)
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
  })  : numSponsored = numSponsored.asUint32,
        numSponsoring = numSponsoring.asUint32,
        signerSponsoringIDs =
            signerSponsoringIDs.immutable.max(20, name: "signerSponsoringIDs");
  factory AccountEntryExtensionV2.fromStruct(Map<String, dynamic> json) {
    return AccountEntryExtensionV2(
        numSponsored: json.as("numSponsored"),
        numSponsoring: json.as("numSponsoring"),
        signerSponsoringIDs: json.as<List>("signerSponsoringIDs").map((e) {
          if (e == null) return null;
          try {
            final data = Map<String, dynamic>.from(e);
            return StellarPublicKey.fromStruct(data);
          } catch (e, s) {
            throw DartStellarPlugingException("Incorrect value.", details: {
              "key": "signerSponsoringIDs",
              "data": json["signerSponsoringIDs"],
              "error": e.toString(),
              "stack": s.toString()
            });
          }
        }).toList(),
        ext: AccountEntryExtensionV3Ext.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "numSponsored"),
      LayoutConst.u32be(property: "numSponsoring"),
      LayoutConst.xdrVec(LayoutConst.optionalU32Be(StellarPublicKey.layout()),
          property: "signerSponsoringIDs"),
      AccountEntryExtensionV3Ext.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "numSponsored": numSponsored,
      "numSponsoring": numSponsoring,
      "signerSponsoringIDs":
          signerSponsoringIDs.map((e) => e?.toLayoutStruct()).toList(),
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class AccountEntryExtensionV2Ext extends XDRVariantSerialization {
  final AccountEntryExtensionV2? v2;
  const AccountEntryExtensionV2Ext({this.v2});
  factory AccountEntryExtensionV2Ext.fromXdr(List<int> bytes,
      {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return AccountEntryExtensionV2Ext.fromStruct(decode);
  }
  factory AccountEntryExtensionV2Ext.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ExtensionPointType.fromName(decode.variantName);
    switch (type) {
      case ExtensionPointType.extVoid:
        return const AccountEntryExtensionV2Ext();
      case ExtensionPointType.extArgs3:
        return AccountEntryExtensionV2Ext(
            v2: AccountEntryExtensionV2.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid AccountEntryExtensionV2 extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs2.value,
          layout: AccountEntryExtensionV2.layout,
          property: ExtensionPointType.extArgs2.name)
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
      liabilities: Liabilities.fromStruct(json.asMap("liabilities")),
      ext: AccountEntryExtensionV2Ext.fromStruct(json.asMap("ext")),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Liabilities.layout(property: "liabilities"),
      AccountEntryExtensionV2Ext.layout(property: "ext"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "liabilities": liabilities.toLayoutStruct(),
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class AccountEntryExt extends XDRVariantSerialization {
  final AccountEntryExtensionV1? v1;
  const AccountEntryExt({this.v1});
  factory AccountEntryExt.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
            v1: AccountEntryExtensionV1.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid AccountEntry extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: AccountEntryExtensionV1.layout,
          property: ExtensionPointType.extArgs1.name)
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
  TrustLineEntryExtensionV2(
      {required int liquidityPoolUseCount,
      this.ext = const ExtentionPointVoid()})
      : liquidityPoolUseCount = liquidityPoolUseCount.asInt32;
  factory TrustLineEntryExtensionV2.fromStruct(Map<String, dynamic> json) {
    return TrustLineEntryExtensionV2(
        liquidityPoolUseCount: json.as("liquidityPoolUseCount"),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: "liquidityPoolUseCount"),
      ExtentionPointVoid.layout(property: "ext"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "liquidityPoolUseCount": liquidityPoolUseCount,
      "ext": ext.toVariantLayoutStruct()
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
            v2: TrustLineEntryExtensionV2.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid TrustLineEntryExtensionV2 extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs2.value,
          layout: TrustLineEntryExtensionV2.layout,
          property: ExtensionPointType.extArgs2.name)
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
        liabilities: Liabilities.fromStruct(json.asMap("liabilities")),
        ext: TrustLineEntryV2Ext.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      Liabilities.layout(property: "liabilities"),
      TrustLineEntryV2Ext.layout(property: "ext"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "liabilities": liabilities.toLayoutStruct(),
      "ext": ext.toVariantLayoutStruct(),
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
        throw const DartStellarPlugingException(
            "Invalid TrustLineEntryV1 extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: TrustLineEntryExtensionV2.layout,
          property: ExtensionPointType.extArgs1.name)
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
  TrustLineEntry(
      {required this.accountId,
      required this.asset,
      required BigInt balance,
      required BigInt limit,
      required int flags,
      required this.ext})
      : balance = balance.asInt64,
        limit = limit.asInt64,
        flags = flags.asUint32,
        super(LedgerEntryType.trustline);
  factory TrustLineEntry.fromStruct(Map<String, dynamic> json) {
    return TrustLineEntry(
        accountId: StellarPublicKey.fromStruct(json.asMap("accountId")),
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        balance: json.as("balance"),
        limit: json.as("limit"),
        flags: json.as("flags"),
        ext: TrustLineEntryExt.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      StellarAsset.layout(property: "asset"),
      LayoutConst.s64be(property: "balance"),
      LayoutConst.s64be(property: "limit"),
      LayoutConst.u32be(property: "flags"),
      TrustLineEntryExt.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "accountId": accountId.toLayoutStruct(),
      "asset": asset.toVariantLayoutStruct(),
      "balance": balance,
      "limit": limit,
      "flags": flags,
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class StellarPrice extends XDRSerialization {
  final int numerator;
  final int denominator;
  StellarPrice({required int numerator, required int denominator})
      : numerator = numerator.asInt32,
        denominator = denominator.asInt32;
  factory StellarPrice.fromDecimal(String price) {
    return StellarHelper.approximatePriceUsingContinuedFraction(price);
  }
  factory StellarPrice.fromStruct(Map<String, dynamic> json) {
    return StellarPrice(
        numerator: json.as("numerator"), denominator: json.as("denominator"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: "numerator"),
      LayoutConst.s32be(property: "denominator"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"numerator": numerator, "denominator": denominator};
  }

  BigRational toBigRational() {
    return BigRational(BigInt.from(numerator),
        denominator: BigInt.from(denominator));
  }

  String toPrice([int? scale]) {
    final rational = BigRational(BigInt.from(numerator),
        denominator: BigInt.from(denominator));
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

  OfferEntry(
      {required this.sellerId,
      required BigInt offerId,
      required this.selling,
      required this.buying,
      required BigInt amount,
      required this.price,
      required int flags,
      required this.ext})
      : offerId = offerId.asInt64,
        amount = amount.asInt64,
        flags = flags.asUint32,
        super(LedgerEntryType.offer);
  factory OfferEntry.fromStruct(Map<String, dynamic> json) {
    return OfferEntry(
        amount: json.as("amount"),
        buying: StellarAsset.fromStruct(json.asMap("buying")),
        selling: StellarAsset.fromStruct(json.asMap("selling")),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
        flags: json.as("flags"),
        offerId: json.as("offerId"),
        price: StellarPrice.fromStruct(json.asMap("price")),
        sellerId: StellarPublicKey.fromStruct(json.asMap("sellerId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "sellerId"),
      LayoutConst.s64be(property: "offerId"),
      StellarAsset.layout(property: "selling"),
      StellarAsset.layout(property: "buying"),
      LayoutConst.s64be(property: "amount"),
      StellarPrice.layout(property: "price"),
      LayoutConst.u32be(property: "flags"),
      ExtentionPointVoid.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sellerId": sellerId.toLayoutStruct(),
      "offerId": offerId,
      "selling": selling.toVariantLayoutStruct(),
      "buying": buying.toVariantLayoutStruct(),
      "amount": amount,
      "price": price.toLayoutStruct(),
      "flags": flags,
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class DataEntry extends LedgerEntryData {
  final StellarPublicKey accountId;
  final String dataName;
  final List<int> dataValue;
  final ExtentionPointVoid ext;
  DataEntry(
      {required this.accountId,
      required String dataName,
      required List<int> dataValue,
      this.ext = const ExtentionPointVoid()})
      : dataName = dataName.max(StellarConst.str64),
        dataValue = dataValue.asImmutableBytes
            .max(StellarConst.dataValueLength, name: "dataValue"),
        super(LedgerEntryType.data);
  factory DataEntry.fromStruct(Map<String, dynamic> json) {
    return DataEntry(
        accountId: StellarPublicKey.fromStruct(json.asMap("accountId")),
        dataName: json.as("dataName"),
        dataValue: json.asBytes("dataValue"),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      LayoutConst.xdrString(property: "dataName"),
      LayoutConst.xdrVecBytes(property: "dataValue"),
      ExtentionPointVoid.layout(property: "ext"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "accountId": accountId.createLayout(),
      "dataName": dataName,
      "dataValue": dataValue,
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class ClaimableBalanceEntryExtensionV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final int flags;
  ClaimableBalanceEntryExtensionV1(
      {this.ext = const ExtentionPointVoid(), required int flags})
      : flags = flags.asUint32;
  factory ClaimableBalanceEntryExtensionV1.fromStruct(
      Map<String, dynamic> json) {
    return ClaimableBalanceEntryExtensionV1(
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
        flags: json.as("flags"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      LayoutConst.u32be(property: "flags"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ext": ext.toVariantLayoutStruct(), "flags": flags};
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
            v1: ClaimableBalanceEntryExtensionV1.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid TrustLineEntryV1 extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: ClaimableBalanceEntryExtensionV1.layout,
          property: ExtensionPointType.extArgs1.name)
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
  static const ClaimableBalanceIdType v0 =
      ClaimableBalanceIdType._(name: "V0", value: 0);
  static const List<ClaimableBalanceIdType> values = [v0];
  static ClaimableBalanceIdType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClaimableBalanceId not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ClaimableBalanceIdType.$name";
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
        throw StellarAddressException("Invalid ClaimableBalanceId type.",
            details: {"type": type.name});
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be(
        [ClaimableBalanceIdV0.layout(property: ClaimableBalanceIdType.v0.name)],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ClaimableBalanceIdV0 extends ClaimableBalanceId {
  final List<int> hash;
  ClaimableBalanceIdV0(List<int> hash)
      : hash = hash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "ClaimableBalanceIdV0 Hash"),
        super(ClaimableBalanceIdType.v0);
  factory ClaimableBalanceIdV0.fromStruct(Map<String, dynamic> json) {
    return ClaimableBalanceIdV0(json.asBytes("hash"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hash": hash};
  }
}

class ClaimantType {
  final String name;
  final int value;
  const ClaimantType._({required this.name, required this.value});
  static const ClaimantType v0 = ClaimantType._(name: "V0", value: 0);
  static const List<ClaimantType> values = [v0];
  static ClaimantType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "Claimant type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ClaimantType.$name";
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
        throw const DartStellarPlugingException("Invalid Claimant type.");
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
        destination: StellarPublicKey.fromStruct(json.asMap("destination")),
        predicate: ClaimPredicate.fromStruct(json.asMap("predicate")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "destination"),
      ClaimPredicate.layout(property: "predicate"),
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
      "destination": destination.toLayoutStruct(),
      "predicate": predicate.toVariantLayoutStruct(),
    };
  }
}

class ClaimPredicateType {
  final String name;
  final int value;
  const ClaimPredicateType._({required this.name, required this.value});
  static const ClaimPredicateType unconditional =
      ClaimPredicateType._(name: "Unconditional", value: 0);
  static const ClaimPredicateType and =
      ClaimPredicateType._(name: "And", value: 1);
  static const ClaimPredicateType or =
      ClaimPredicateType._(name: "Or", value: 2);
  static const ClaimPredicateType not =
      ClaimPredicateType._(name: "Not", value: 3);
  static const ClaimPredicateType beforeAbsoluteTime =
      ClaimPredicateType._(name: "BeforeAbsoluteTime", value: 4);
  static const ClaimPredicateType beforeRelativeTime =
      ClaimPredicateType._(name: "BeforeRelativeTime", value: 5);
  static const List<ClaimPredicateType> values = [
    unconditional,
    and,
    or,
    not,
    beforeAbsoluteTime,
    beforeRelativeTime
  ];
  static ClaimPredicateType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClaimPredicate type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ClaimPredicateType.$name";
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
        throw const DartStellarPlugingException("Invalid ClaimPredicate type.");
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
                  property: type.name);
            case ClaimPredicateType.and:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimPredicateAnd.layout,
                  property: type.name);
            case ClaimPredicateType.or:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimPredicateOr.layout,
                  property: type.name);
            case ClaimPredicateType.not:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimPredicateNot.layout,
                  property: type.name);
            case ClaimPredicateType.beforeAbsoluteTime:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimPredicateBeforeAbsoluteTime.layout,
                  property: type.name);
            case ClaimPredicateType.beforeRelativeTime:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimPredicateBeforeRelativeTime.layout,
                  property: type.name);

            default:
              throw const DartStellarPlugingException(
                  "Invalid ClaimPredicate type.");
          }
        }),
        property: property);
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
      : andPredicates = value.immutable.max(2, name: "ClaimPredicate"),
        super(ClaimPredicateType.and);
  factory ClaimPredicateAnd.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateAnd(json
        .asListOfMap("andPredicates")!
        .map((e) => ClaimPredicate.fromStruct(e))
        .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ClaimPredicate.layout(), property: "andPredicates")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "andPredicates":
          andPredicates.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }
}

class ClaimPredicateOr extends ClaimPredicate {
  final List<ClaimPredicate> orPredicates;
  ClaimPredicateOr(List<ClaimPredicate> orPredicates)
      : orPredicates = orPredicates.immutable.max(2, name: "ClaimPredicate"),
        super(ClaimPredicateType.or);
  factory ClaimPredicateOr.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateOr(json
        .asListOfMap("orPredicates")!
        .map((e) => ClaimPredicate.fromStruct(e))
        .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.xdrVec(ClaimPredicate.layout(), property: "orPredicates")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "orPredicates":
          orPredicates.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }
}

class ClaimPredicateNot extends ClaimPredicate {
  final ClaimPredicate? notPredicate;
  ClaimPredicateNot(this.notPredicate) : super(ClaimPredicateType.not);
  factory ClaimPredicateNot.fromStruct(Map<String, dynamic> json) {
    return ClaimPredicateNot(
      json.mybeAs<ClaimPredicate, Map<String, dynamic>>(
          key: "notPredicate", onValue: (e) => ClaimPredicate.fromStruct(e)),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(ClaimPredicate.layout(),
          property: "notPredicate")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"notPredicate": notPredicate?.toVariantLayoutStruct()};
  }
}

class ClaimPredicateBeforeAbsoluteTime extends ClaimPredicate {
  final BigInt absBefore;
  ClaimPredicateBeforeAbsoluteTime(BigInt absBefore)
      : absBefore = absBefore.asInt64,
        super(ClaimPredicateType.beforeAbsoluteTime);
  factory ClaimPredicateBeforeAbsoluteTime.fromStruct(
      Map<String, dynamic> json) {
    return ClaimPredicateBeforeAbsoluteTime(json.as("absBefore"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.s64be(property: "absBefore")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"absBefore": absBefore};
  }
}

class ClaimPredicateBeforeRelativeTime extends ClaimPredicate {
  final BigInt relBefore;
  ClaimPredicateBeforeRelativeTime(BigInt relBefore)
      : relBefore = relBefore.asInt64,
        super(ClaimPredicateType.beforeRelativeTime);
  factory ClaimPredicateBeforeRelativeTime.fromStruct(
      Map<String, dynamic> json) {
    return ClaimPredicateBeforeRelativeTime(json.as("relBefore"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.s64be(property: "relBefore")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"relBefore": relBefore};
  }
}

class ClaimableBalanceEntry extends LedgerEntryData {
  final ClaimableBalanceId balanceId;
  final List<Claimant> claimants;
  final StellarAsset asset;
  final BigInt amount;
  final ClaimableBalanceEntryExt ext;
  ClaimableBalanceEntry(
      {required this.balanceId,
      required List<Claimant> claimants,
      required this.asset,
      required BigInt amount,
      required this.ext})
      : claimants = claimants.immutable.max(10, name: "claimants"),
        amount = amount.asInt64,
        super(LedgerEntryType.claimableBalance);
  factory ClaimableBalanceEntry.fromStruct(Map<String, dynamic> json) {
    return ClaimableBalanceEntry(
        amount: json.as("amount"),
        balanceId: ClaimableBalanceId.fromStruct(json.asMap("balanceId")),
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        claimants: json
            .asListOfMap("claimants")!
            .map((e) => Claimant.fromStruct(e))
            .toList(),
        ext: ClaimableBalanceEntryExt.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ClaimableBalanceId.layout(property: "balanceId"),
      LayoutConst.xdrVec(Claimant.layout(), property: "claimants"),
      StellarAsset.layout(property: "asset"),
      LayoutConst.u64(property: "amount"),
      ClaimableBalanceEntryExt.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "balanceId": balanceId.toVariantLayoutStruct(),
      "claimants": claimants.map((e) => e.toVariantLayoutStruct()).toList(),
      "asset": asset.toVariantLayoutStruct(),
      "amount": amount,
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class LiquidityPoolType {
  final int value;
  final String name;
  const LiquidityPoolType._({required this.value, required this.name});
  static const LiquidityPoolType liquidityPoolConstantProduct =
      LiquidityPoolType._(name: "liquidityPoolConstantProduct", value: 0);
  static const List<LiquidityPoolType> values = [liquidityPoolConstantProduct];
  static LiquidityPoolType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "LiquidityPool type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "LiquidityPoolType.$name";
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
        throw DartStellarPlugingException("Invalid LiquidityPool type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          layout: LiquidityPoolEntryConstantProduct.layout,
          property: LiquidityPoolType.liquidityPoolConstantProduct.name,
          index: LiquidityPoolType.liquidityPoolConstantProduct.value)
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
  LiquidityPoolConstantProductParameters(
      {required this.assetA, required this.assetB, required int fee})
      : fee = fee.asInt32;
  factory LiquidityPoolConstantProductParameters.fromStruct(
      Map<String, dynamic> json) {
    return LiquidityPoolConstantProductParameters(
        assetA: StellarAsset.fromStruct(json.asMap("assetA")),
        assetB: StellarAsset.fromStruct(json.asMap("assetB")),
        fee: json.as("fee"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "assetA"),
      StellarAsset.layout(property: "assetB"),
      LayoutConst.s32be(property: "fee")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "assetA": assetA.toVariantLayoutStruct(),
      "assetB": assetB.toVariantLayoutStruct(),
      "fee": fee
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
  LiquidityPoolEntryConstantProduct(
      {required this.param,
      required BigInt reserveA,
      required BigInt reserveB,
      required BigInt totalPoolShares,
      required BigInt poolSharesTrustLineCount})
      : reserveA = reserveA.asInt64,
        reserveB = reserveB.asInt64,
        totalPoolShares = totalPoolShares.asInt64,
        poolSharesTrustLineCount = poolSharesTrustLineCount.asInt64,
        super(LiquidityPoolType.liquidityPoolConstantProduct);
  factory LiquidityPoolEntryConstantProduct.fromStruct(
      Map<String, dynamic> json) {
    return LiquidityPoolEntryConstantProduct(
      param: LiquidityPoolConstantProductParameters.fromStruct(
          json.asMap("param")),
      poolSharesTrustLineCount: json.as("poolSharesTrustLineCount"),
      reserveA: json.as("reserveA"),
      reserveB: json.as("reserveB"),
      totalPoolShares: json.as("totalPoolShares"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LiquidityPoolConstantProductParameters.layout(property: "param"),
      LayoutConst.s64be(property: "reserveA"),
      LayoutConst.s64be(property: "reserveB"),
      LayoutConst.s64be(property: "totalPoolShares"),
      LayoutConst.s64be(property: "poolSharesTrustLineCount"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "param": param.toLayoutStruct(),
      "reserveA": reserveA,
      "reserveB": reserveB,
      "totalPoolShares": totalPoolShares,
      "poolSharesTrustLineCount": poolSharesTrustLineCount
    };
  }
}

class LiquidityPoolEntry extends LedgerEntryData {
  final List<int> liquidityPoolId;
  final LiquidityPoolEntryBody body;
  LiquidityPoolEntry({required List<int> liquidityPoolId, required this.body})
      : liquidityPoolId = liquidityPoolId.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "liquidityPoolId"),
        super(LedgerEntryType.liquidityPool);
  factory LiquidityPoolEntry.fromStruct(Map<String, dynamic> json) {
    return LiquidityPoolEntry(
        liquidityPoolId: json.asBytes("liquidityPoolId"),
        body: LiquidityPoolEntryBody.fromStruct(json.asMap("body")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "liquidityPoolId"),
      LiquidityPoolEntryBody.layout(property: "body")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "liquidityPoolId": liquidityPoolId,
      "body": body.toVariantLayoutStruct()
    };
  }
}

class ScAddressType {
  final String name;
  final int value;
  const ScAddressType._({required this.name, required this.value});
  static const ScAddressType account =
      ScAddressType._(name: "account", value: 0);
  static const ScAddressType contract =
      ScAddressType._(name: "contract", value: 1);
  static const List<ScAddressType> values = [account, contract];
  static ScAddressType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ScAddress type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ScAddressType.$name";
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
      case XlmAddrTypes.muxed:
        return ScAddressAccountId(address.toPublicKey());
      default:
        throw DartStellarPlugingException("Invalid address type.",
            details: {"type": address.type.name});
    }
  }
  factory ScAddress.fromBase32Address(String address) {
    return ScAddress.fromAddress(StellarAddress.fromBase32Addr(address));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ScAddressAccountId.layout(property: ScAddressType.account.name),
      ScAddressContract.layout(property: ScAddressType.contract.name)
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
      default:
        throw DartStellarPlugingException("Invalid ScAddress type.",
            details: {"type": type.name});
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
        StellarPublicKey.fromStruct(json.asMap("accountId")));
  }
  factory ScAddressAccountId.fromAddress(StellarAddress address) {
    return ScAddressAccountId(address.toPublicKey());
  }
  factory ScAddressAccountId.fromBase32Address(String address) {
    return ScAddressAccountId.fromAddress(
        StellarAddress.fromBase32Addr(address));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([StellarPublicKey.layout(property: "accountId")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"accountId": accountId.toLayoutStruct()};
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
        StellarContractAddress.fromBytes(json.asBytes("contractId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "contractId")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"contractId": contractId.keyBytes()};
  }

  @override
  StellarAddress get address => contractId;

  @override
  Map<String, dynamic> toJson() {
    return {"contractId": contractId.toString()};
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
  static const contractInstance =
      ScValueType._(name: 'ContractInstance', value: 19);
  static const ledgerKeyContractInstance =
      ScValueType._(name: 'LedgerKeyContractInstance', value: 20);
  static const ledgerKeyNonce =
      ScValueType._(name: 'LedgerKeyNonce', value: 21);
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
    ledgerKeyNonce
  ];
  static ScValueType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("ScValue type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ScValueType.$name";
  }
}

abstract class ScVal<T> extends XDRVariantSerialization {
  final ScValueType type;
  final T value;
  const ScVal({required this.type, required this.value});
  factory ScVal.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
        throw const DartStellarPlugingException("Invalid ScVal type.");
    }

    if (val is! ScVal<T>) {
      throw DartStellarPlugingException("Incorrect SCval type casting.",
          details: {"excepted": "$T", "ScVal": val.runtimeType});
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
                  property: type.name);
            case ScValueType.voidType:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValVoid.layout,
                  property: type.name);
            case ScValueType.error:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValError.layout,
                  property: type.name);
            case ScValueType.u32:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValU32.layout,
                  property: type.name);
            case ScValueType.i32:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValI32.layout,
                  property: type.name);
            case ScValueType.u64:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValU64.layout,
                  property: type.name);
            case ScValueType.i64:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValI64.layout,
                  property: type.name);
            case ScValueType.timepoint:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValTimePoint.layout,
                  property: type.name);
            case ScValueType.duration:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValDuration.layout,
                  property: type.name);
            case ScValueType.u128:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValU128.layout,
                  property: type.name);
            case ScValueType.i128:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValI128.layout,
                  property: type.name);
            case ScValueType.u256:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValU256.layout,
                  property: type.name);
            case ScValueType.i256:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValI256.layout,
                  property: type.name);
            case ScValueType.bytes:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValBytes.layout,
                  property: type.name);
            case ScValueType.string:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValString.layout,
                  property: type.name);
            case ScValueType.symbol:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValSymbol.layout,
                  property: type.name);
            case ScValueType.vec:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValVec.layout,
                  property: type.name);
            case ScValueType.map:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValMap.layout,
                  property: type.name);
            case ScValueType.address:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValAddress.layout,
                  property: type.name);
            case ScValueType.contractInstance:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValInstance.layout,
                  property: type.name);
            case ScValueType.ledgerKeyContractInstance:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValKeyContractInstance.layout,
                  property: type.name);
            case ScValueType.ledgerKeyNonce:
              return LazyVariantModel(
                  index: type.value,
                  layout: ScValNonceKey.layout,
                  property: type.name);
            default:
              throw const DartStellarPlugingException("Invalid ScVal type.");
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  E cast<E extends ScVal>() {
    if (this is! E) {
      throw DartStellarPlugingException("ScVal Casting failed.",
          details: {"excepted": "$T", "type": "$runtimeType"});
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
    auth
  ];
  static ScErrorType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("ScError type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ScErrorType.$name";
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
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  // @override
  // Layout<T> createLayout({String? property}) {
  //   return LayoutConst.none(property: property) as Layout<T>;
  // }

  @override
  String get variantName => type.name;
}

class ScErrorContract extends ScError {
  final int contractCode;
  ScErrorContract(int contractCode)
      : contractCode = contractCode.asUint32,
        super(ScErrorType.contract);
  factory ScErrorContract.fromStruct(Map<String, dynamic> json) {
    return ScErrorContract(json.as("contractCode"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "contractCode"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"contractCode": contractCode};
  }
}

class ScErrorCode extends ScError {
  ScErrorCode._(ScErrorType code) : super(code);
  factory ScErrorCode(ScErrorType code) {
    if (code == ScErrorType.contract) {
      throw const DartStellarPlugingException(
          "Use `ScErrorContract` instead `ScErrorCode` for user-defined error code.");
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
      LayoutConst.boolean32Be(property: "value"),
    ], property: property);
  }

  factory ScValBoolean.fromStruct(Map<String, dynamic> json) {
    return ScValBoolean(json.as("value"));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValError extends ScVal<ScError> {
  ScValError(ScError value) : super(type: ScValueType.error, value: value);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ScError.layout(property: "value")],
        property: property);
  }

  factory ScValError.fromStruct(Map<String, dynamic> json) {
    return ScValError(ScError.fromStruct(json.asMap("value")));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "value": value.toVariantLayoutStruct(),
    };
  }
}

class ScValU32 extends ScVal<int> {
  ScValU32(int value) : super(type: ScValueType.u32, value: value.asUint32);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "value"),
    ], property: property);
  }

  factory ScValU32.fromStruct(Map<String, dynamic> json) {
    return ScValU32(json.as("value"));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValI32 extends ScVal<int> {
  ScValI32(int value) : super(type: ScValueType.i32, value: value.asInt32);
  factory ScValI32.fromStruct(Map<String, dynamic> json) {
    return ScValI32(json.as("value"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s32be(property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValU64 extends ScVal<BigInt> {
  ScValU64(BigInt value) : super(type: ScValueType.u64, value: value.asUint64);
  factory ScValU64.fromStruct(Map<String, dynamic> json) {
    return ScValU64(json.as("value"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValI64 extends ScVal<BigInt> {
  ScValI64(BigInt value) : super(type: ScValueType.i64, value: value.asInt64);
  factory ScValI64.fromStruct(Map<String, dynamic> json) {
    return ScValI64(json.as("value"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValTimePoint extends ScVal<BigInt> {
  ScValTimePoint(BigInt value)
      : super(type: ScValueType.timepoint, value: value.asUint64);
  factory ScValTimePoint.fromStruct(Map<String, dynamic> json) {
    return ScValTimePoint(json.as("value"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class UInt128Parts extends XDRSerialization {
  final BigInt hi;
  final BigInt lo;
  UInt128Parts({required BigInt hi, required BigInt lo})
      : hi = hi.asUint64,
        lo = lo.asUint64;

  factory UInt128Parts.fromStruct(Map<String, dynamic> json) {
    return UInt128Parts(hi: json.as("hi"), lo: json.as("lo"));
  }
  factory UInt128Parts.fromNumber(BigInt number) {
    if (number.isNegative || number.bitLength > 128) {
      if (number.isNegative) {
        throw DartStellarPlugingException("Invalid Unsigned int.",
            details: {"number": number.toString()});
      }
      throw DartStellarPlugingException("Number is to large for `Int256Parts`",
          details: {"number": number.toString()});
    }
    BigInt hi = (number >> 64).toUnsigned(64);
    BigInt lo = number.toUnsigned(64);
    return UInt128Parts(hi: hi, lo: lo);
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "hi"),
      LayoutConst.u64be(property: "lo"),
    ], property: property);
  }

  BigInt toBigInt() {
    BigInt part = (hi << 64);
    BigInt int256 = part | lo;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hi": hi, "lo": lo};
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
      : hi = hi.asInt64,
        lo = lo.asUint64;
  factory Int128Parts.fromNumber(BigInt number) {
    if (number.bitLength > 128) {
      throw DartStellarPlugingException("Number is to large for `Int256Parts`",
          details: {"number": number.toString()});
    }
    BigInt hi = (number >> 64).toSigned(64);
    BigInt lo = number.toUnsigned(64);
    return Int128Parts(hi: hi, lo: lo);
  }
  factory Int128Parts.fromStruct(Map<String, dynamic> json) {
    return Int128Parts(hi: json.as("hi"), lo: json.as("lo"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "hi"),
      LayoutConst.u64be(property: "lo"),
    ], property: property);
  }

  BigInt toBigInt() {
    BigInt part = (hi << 64);
    BigInt int256 = part | lo;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hi": hi, "lo": lo};
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
  })  : hiHi = hiHi.asUint64,
        hiLo = hiLo.asUint64,
        loHi = loHi.asUint64,
        loLo = loLo.asUint64;
  factory UInt256Parts.fromStruct(Map<String, dynamic> json) {
    return UInt256Parts(
      hiHi: json.as("hiHi"),
      hiLo: json.as("hiLo"),
      loHi: json.as("loHi"),
      loLo: json.as("loLo"),
    );
  }
  factory UInt256Parts.fromNumber(BigInt number) {
    if (number.isNegative || number.bitLength > 256) {
      if (number.isNegative) {
        throw DartStellarPlugingException("Invalid Unsigned int.",
            details: {"number": number.toString()});
      }
      throw DartStellarPlugingException("Number is to large for `Int256Parts`",
          details: {"number": number.toString()});
    }
    BigInt hiHi = (number >> 192).toUnsigned(64);
    BigInt hiLo = (number >> 128).toUnsigned(64);
    BigInt loHi = (number >> 64).toUnsigned(64);
    BigInt loLo = number.toUnsigned(64);
    return UInt256Parts(hiHi: hiHi, hiLo: hiLo, loHi: loHi, loLo: loLo);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "hiHi"),
      LayoutConst.u64be(property: "hiLo"),
      LayoutConst.u64be(property: "loHi"),
      LayoutConst.u64be(property: "loLo"),
    ], property: property);
  }

  BigInt toBigInt() {
    BigInt part1 = (hiHi << 192);
    BigInt part2 = (hiLo << 128);
    BigInt part3 = (loHi << 64);
    BigInt part4 = loLo;
    BigInt int256 = part1 | part2 | part3 | part4;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hiHi": hiHi, "hiLo": hiLo, "loHi": loHi, "loLo": loLo};
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
  })  : hiHi = hiHi.asInt64,
        hiLo = hiLo.asUint64,
        loHi = loHi.asUint64,
        loLo = loLo.asUint64;
  factory Int256Parts.fromStruct(Map<String, dynamic> json) {
    return Int256Parts(
      hiHi: json.as("hiHi"),
      hiLo: json.as("hiLo"),
      loHi: json.as("loHi"),
      loLo: json.as("loLo"),
    );
  }
  factory Int256Parts.fromNumber(BigInt number) {
    if (number.bitLength > 256) {
      throw const DartStellarPlugingException(
          "Number is to large for `Int256Parts`");
    }
    BigInt hiHi = (number >> 192).toSigned(64);
    BigInt hiLo = (number >> 128).toUnsigned(64);
    BigInt loHi = (number >> 64).toUnsigned(64);
    BigInt loLo = number.toUnsigned(64);
    return Int256Parts(hiHi: hiHi, hiLo: hiLo, loHi: loHi, loLo: loLo);
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "hiHi"),
      LayoutConst.u64be(property: "hiLo"),
      LayoutConst.u64be(property: "loHi"),
      LayoutConst.u64be(property: "loLo"),
    ], property: property);
  }

  BigInt toBigInt() {
    BigInt part1 = (hiHi << 192);
    BigInt part2 = (hiLo << 128);
    BigInt part3 = (loHi << 64);
    BigInt part4 = loLo;
    BigInt int256 = part1 | part2 | part3 | part4;
    return int256;
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hiHi": hiHi, "hiLo": hiLo, "loHi": loHi, "loLo": loLo};
  }

  @override
  String toString() {
    return toBigInt().toString();
  }
}

class ScValDuration extends ScVal<BigInt> {
  ScValDuration(BigInt value)
      : super(type: ScValueType.duration, value: value.asUint64);
  factory ScValDuration.fromStruct(Map<String, dynamic> json) {
    return ScValDuration(json.as("value"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.u64be(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValU128 extends ScVal<UInt128Parts> {
  ScValU128(UInt128Parts value) : super(type: ScValueType.u128, value: value);
  factory ScValU128.fromNumber(BigInt num) {
    return ScValU128(UInt128Parts.fromNumber(num));
  }
  factory ScValU128.fromStruct(Map<String, dynamic> json) {
    return ScValU128(UInt128Parts.fromStruct(json.asMap("value")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([UInt128Parts.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
  }
}

class ScValI128 extends ScVal<Int128Parts> {
  ScValI128(Int128Parts value) : super(type: ScValueType.i128, value: value);
  factory ScValI128.fromStruct(Map<String, dynamic> json) {
    return ScValI128(Int128Parts.fromStruct(json.asMap("value")));
  }
  factory ScValI128.fromNumber(BigInt num) {
    return ScValI128(Int128Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([Int128Parts.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
  }
}

class ScValU256 extends ScVal<UInt256Parts> {
  ScValU256(UInt256Parts value) : super(type: ScValueType.u256, value: value);
  factory ScValU256.fromStruct(Map<String, dynamic> json) {
    return ScValU256(UInt256Parts.fromStruct(json.asMap("value")));
  }
  factory ScValU256.fromNumber(BigInt num) {
    return ScValU256(UInt256Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([UInt256Parts.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
  }
}

class ScValI256 extends ScVal<Int256Parts> {
  ScValI256(Int256Parts value) : super(type: ScValueType.i256, value: value);
  factory ScValI256.fromStruct(Map<String, dynamic> json) {
    return ScValI256(Int256Parts.fromStruct(json.asMap("value")));
  }
  factory ScValI256.fromNumber(BigInt num) {
    return ScValI256(Int256Parts.fromNumber(num));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([Int256Parts.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
  }
}

class ScValBytes extends ScVal<List<int>> {
  ScValBytes(List<int> bytes)
      : super(type: ScValueType.bytes, value: bytes.asImmutableBytes);
  factory ScValBytes.fromHex(String hexBytes) {
    return ScValBytes(BytesUtils.fromHexString(hexBytes));
  }
  factory ScValBytes.fromStruct(Map<String, dynamic> json) {
    return ScValBytes(json.asBytes("value"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.xdrVecBytes(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValString extends ScVal<String> {
  ScValString(String str) : super(type: ScValueType.string, value: str);
  factory ScValString.fromStruct(Map<String, dynamic> json) {
    return ScValString(json.as("value"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.xdrString(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScValSymbol extends ScVal<String> {
  ScValSymbol(String sym) : super(type: ScValueType.symbol, value: sym.max(32));
  factory ScValSymbol.fromStruct(Map<String, dynamic> json) {
    return ScValSymbol(json.as("value"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.xdrString(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value};
  }
}

class ScMapEntry<K extends ScVal, V extends ScVal> extends XDRSerialization {
  final K key;
  final V value;
  const ScMapEntry(this.key, this.value);
  factory ScMapEntry.fromStruct(Map<String, dynamic> json) {
    return ScMapEntry(ScVal.fromStruct(json.asMap("key")) as K,
        ScVal.fromStruct(json.asMap("value")) as V);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScVal.layout(property: "key"),
      ScVal.layout(property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "key": key.toVariantLayoutStruct(),
      "value": value.toVariantLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {"key": key.toJson(), "value": value.toJson()};
  }
}

class ScNonceKey extends XDRSerialization {
  final BigInt nonce;
  ScNonceKey(BigInt nonce) : nonce = nonce.asInt64;
  factory ScNonceKey.fromStruct(Map<String, dynamic> json) {
    return ScNonceKey(json.as("nonce"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.s64be(property: "nonce")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"nonce": nonce};
  }
}

class ScValVec extends ScVal<List<ScVal>?> {
  ScValVec({List<ScVal>? value})
      : super(type: ScValueType.vec, value: value?.immutable);
  factory ScValVec.fromStruct(Map<String, dynamic> json) {
    return ScValVec(
        value: json
            .asListOfMap("value", throwOnNull: false)
            ?.map((e) => ScVal.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(LayoutConst.xdrVec(ScVal.layout()),
          property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "value": value?.map((e) => e.toVariantLayoutStruct()).toList() ?? const []
    };
  }
}

class ScValMap extends ScVal<List<ScMapEntry>?> {
  ScValMap({List<ScMapEntry>? value})
      : super(type: ScValueType.map, value: value?.immutable);
  factory ScValMap.fromStruct(Map<String, dynamic> json) {
    return ScValMap(
        value: json
            .asListOfMap("value", throwOnNull: false)
            ?.map((e) => ScMapEntry.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(LayoutConst.xdrVec(ScMapEntry.layout()),
          property: "value"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "value": value?.map((e) => e.toLayoutStruct()).toList() ?? const [],
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
    return ScValAddress(ScAddress.fromStruct(json.asMap("value")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ScAddress.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toVariantLayoutStruct()};
  }
}

class ScValNonceKey extends ScVal<ScNonceKey> {
  ScValNonceKey(ScNonceKey value)
      : super(type: ScValueType.ledgerKeyNonce, value: value);
  factory ScValNonceKey.fromStruct(Map<String, dynamic> json) {
    return ScValNonceKey(ScNonceKey.fromStruct(json.asMap("value")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ScNonceKey.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
  }
}

class ScValInstance extends ScVal<ScContractInstance> {
  ScValInstance(ScContractInstance value)
      : super(type: ScValueType.contractInstance, value: value);

  factory ScValInstance.fromStruct(Map<String, dynamic> json) {
    return ScValInstance(ScContractInstance.fromStruct(json.asMap("value")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ScContractInstance.layout(property: "value")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"value": value.toLayoutStruct()};
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
  static const ContractExecutableType executableWasm =
      ContractExecutableType._(name: "ExecutableWasm", value: 0);
  static const ContractExecutableType executableStellarAsset =
      ContractExecutableType._(name: "ExecutableStellarAsset", value: 1);
  static const List<ContractExecutableType> values = [
    executableWasm,
    executableStellarAsset
  ];
  static ContractExecutableType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ContractExecutable type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ContractExecutableType.$name";
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
      default:
        throw const DartStellarPlugingException(
            "Invalid ContractExecutable type.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      ContractExecutableWasmHash.layout(
          property: ContractExecutableType.executableWasm.name),
      ContractExecutableStellarAsset.layout(
          property: ContractExecutableType.executableStellarAsset.name)
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
  final List<int> hash;
  ContractExecutableWasmHash(List<int> hash)
      : hash = hash.asImmutableBytes.exc(StellarConst.hash256Length,
            name: "ContractExecutableWasmHash"),
        super(ContractExecutableType.executableWasm);
  factory ContractExecutableWasmHash.fromStruct(Map<String, dynamic> json) {
    return ContractExecutableWasmHash(json.asBytes("hash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hash": hash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"hash": BytesUtils.toHexString(hash, prefix: "0x")};
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

class ScContractInstance extends XDRSerialization {
  final ContractExecutable executable;
  final List<ScMapEntry>? storage;
  ScContractInstance({required this.executable, List<ScMapEntry>? storage})
      : storage = storage?.immutable;
  factory ScContractInstance.fromStruct(Map<String, dynamic> json) {
    return ScContractInstance(
        executable: ContractExecutable.fromStruct(json.asMap("executable")),
        storage: json
            .asListOfMap("storage", throwOnNull: false)
            ?.map((e) => ScMapEntry.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractExecutable.layout(property: "executable"),
      LayoutConst.optionalU32Be(LayoutConst.xdrVec(ScMapEntry.layout()),
          property: "storage"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "executable": executable.toVariantLayoutStruct(),
      "storage": storage?.map((e) => e.toLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "executable": executable.toJson(),
      "storage": storage?.map((e) => e.toJson()).toList(),
    };
  }
}

class ContractDataDurability {
  final String name;
  final int value;
  const ContractDataDurability._({required this.name, required this.value});
  static const ContractDataDurability temporary =
      ContractDataDurability._(name: "temporary", value: 0);
  static const ContractDataDurability persistent =
      ContractDataDurability._(name: "persistent", value: 1);
  static const List<ContractDataDurability> values = [temporary, persistent];
  static ContractDataDurability fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw DartStellarPlugingException(
          "ContractDataDurability not found.",
          details: {
            "value": value,
            "values": values.map((e) => e.value).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ContractDataDurability.$name";
  }
}

class ContractDataEntry extends LedgerEntryData {
  final ExtentionPointVoid ext;
  final ScAddress contract;
  final ScVal key;
  final ContractDataDurability durability;
  final ScVal val;
  const ContractDataEntry(
      {required this.contract,
      required this.key,
      required this.durability,
      required this.val,
      this.ext = const ExtentionPointVoid()})
      : super(LedgerEntryType.contractData);
  factory ContractDataEntry.fromStruct(Map<String, dynamic> json) {
    return ContractDataEntry(
        contract: ScAddress.fromStruct(json.asMap("contract")),
        durability: ContractDataDurability.fromValue(json.as("durability")),
        key: ScVal.fromStruct(json.asMap("key")),
        val: ScVal.fromStruct(json.asMap("val")),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      ScAddress.layout(property: "contract"),
      ScVal.layout(property: "key"),
      LayoutConst.u32be(property: "durability"),
      ScVal.layout(property: "val"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "contract": contract.toVariantLayoutStruct(),
      "key": key.toVariantLayoutStruct(),
      "durability": durability.value,
      "val": val.toVariantLayoutStruct()
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
  ContractCodeCostInputs(
      {required int nInstructions,
      required int nFunctions,
      required int nGlobals,
      required int nTableEntries,
      required int nTypes,
      required int nDataSegments,
      required int nElemSegments,
      required int nImports,
      required int nExports,
      required int nDataSegmentBytes,
      this.ext = const ExtentionPointVoid()})
      : nInstructions = nInstructions.asUint32,
        nFunctions = nFunctions.asUint32,
        nGlobals = nGlobals.asUint32,
        nTableEntries = nTableEntries.asUint32,
        nTypes = nTypes.asUint32,
        nDataSegments = nDataSegments.asUint32,
        nElemSegments = nElemSegments.asUint32,
        nImports = nImports.asUint32,
        nExports = nExports.asUint32,
        nDataSegmentBytes = nDataSegmentBytes.asUint32;
  factory ContractCodeCostInputs.fromStruct(Map<String, dynamic> json) {
    return ContractCodeCostInputs(
      ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
      nDataSegmentBytes: json.as("nDataSegmentBytes"),
      nDataSegments: json.as("nDataSegments"),
      nElemSegments: json.as("nElemSegments"),
      nExports: json.as("nExports"),
      nFunctions: json.as("nFunctions"),
      nGlobals: json.as("nGlobals"),
      nImports: json.as("nImports"),
      nInstructions: json.as("nInstructions"),
      nTableEntries: json.as("nTableEntries"),
      nTypes: json.as("nTypes"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      LayoutConst.u32be(property: "nInstructions"),
      LayoutConst.u32be(property: "nFunctions"),
      LayoutConst.u32be(property: "nGlobals"),
      LayoutConst.u32be(property: "nTableEntries"),
      LayoutConst.u32be(property: "nTypes"),
      LayoutConst.u32be(property: "nDataSegments"),
      LayoutConst.u32be(property: "nElemSegments"),
      LayoutConst.u32be(property: "nImports"),
      LayoutConst.u32be(property: "nExports"),
      LayoutConst.u32be(property: "nDataSegmentBytes"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "nInstructions": nInstructions,
      "nFunctions": nFunctions,
      "nGlobals": nGlobals,
      "nTableEntries": nTableEntries,
      "nTypes": nTypes,
      "nElemSegments": nElemSegments,
      "nDataSegments": nDataSegments,
      "nImports": nImports,
      "nDataSegmentBytes": nDataSegmentBytes,
      "nExports": nExports,
    };
  }
}

class ContractCodeEntryV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final ContractCodeCostInputs costInputs;
  const ContractCodeEntryV1(
      {required this.costInputs, this.ext = const ExtentionPointVoid()});
  factory ContractCodeEntryV1.fromStruct(Map<String, dynamic> json) {
    return ContractCodeEntryV1(
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
        costInputs:
            ContractCodeCostInputs.fromStruct(json.asMap("costInputs")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "costInputs": costInputs.toLayoutStruct()
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
            v1: ContractCodeEntryV1.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid ContractCodeEntry extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: ContractCodeEntryV1.layout,
          property: ExtensionPointType.extArgs1.name)
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
  final List<int> hash;
  final List<int> code;
  ContractCodeEntry(
      {required this.ext, required List<int> hash, required List<int> code})
      : code = code.asImmutableBytes,
        hash = hash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "ContractCodeEntry Hash"),
        super(LedgerEntryType.contractCode);
  factory ContractCodeEntry.fromStruct(Map<String, dynamic> json) {
    return ContractCodeEntry(
        code: json.asBytes("code"),
        ext: ContractCodeEntryExt.fromStruct(json.asMap("ext")),
        hash: json.asBytes("hash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractCodeEntryExt.layout(property: "ext"),
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash"),
      LayoutConst.xdrVecBytes(property: "code")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "hash": hash,
      "code": code,
      "ext": ext.toVariantLayoutStruct(),
    };
  }
}

class ConfigSettingId {
  final String name;
  final int value;

  const ConfigSettingId._({required this.name, required this.value});

  static const contractMaxSizeBytes =
      ConfigSettingId._(name: 'ContractMaxSizeBytes', value: 0);
  static const contractComputeV0 =
      ConfigSettingId._(name: 'ContractComputeV0', value: 1);
  static const contractLedgerCostV0 =
      ConfigSettingId._(name: 'ContractLedgerCostV0', value: 2);
  static const contractHistoricalDataV0 =
      ConfigSettingId._(name: 'ContractHistoricalDataV0', value: 3);
  static const contractEventsV0 =
      ConfigSettingId._(name: 'ContractEventsV0', value: 4);
  static const contractBandwidthV0 =
      ConfigSettingId._(name: 'ContractBandwidthV0', value: 5);
  static const contractCostParamsCpuInstructions =
      ConfigSettingId._(name: 'ContractCostParamsCpuInstructions', value: 6);
  static const contractCostParamsMemoryBytes =
      ConfigSettingId._(name: 'ContractCostParamsMemoryBytes', value: 7);
  static const contractDataKeySizeBytes =
      ConfigSettingId._(name: 'ContractDataKeySizeBytes', value: 8);
  static const contractDataEntrySizeBytes =
      ConfigSettingId._(name: 'ContractDataEntrySizeBytes', value: 9);
  static const stateArchival =
      ConfigSettingId._(name: 'StateArchival', value: 10);
  static const contractExecutionLanes =
      ConfigSettingId._(name: 'ContractExecutionLanes', value: 11);
  static const bucketlistSizeWindow =
      ConfigSettingId._(name: 'BucketlistSizeWindow', value: 12);
  static const evictionIterator =
      ConfigSettingId._(name: 'EvictionIterator', value: 13);
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
    evictionIterator
  ];
  static ConfigSettingId fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw DartStellarPlugingException(
          "ConfigSettingId not found.",
          details: {
            "value": value,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  static ConfigSettingId fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ConfigSettingId not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ConfigSettingId.$name";
  }
}

class ConfigSettingEntry extends LedgerEntryData {
  final ConfigSetting configSetting;
  ConfigSettingEntry(this.configSetting) : super(LedgerEntryType.configSetting);
  factory ConfigSettingEntry.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingEntry(
        ConfigSetting.fromStruct(json.asMap("configSetting")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ConfigSetting.layout(property: "configSetting")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"configSetting": configSetting.toVariantLayoutStruct()};
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
        return ConfingSettingContractMaxSizeBytes.fromStruct(decode.value);
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
        return ConfingSettingContractCostParamsCpuInstructions.fromStruct(
            decode.value);

      case ConfigSettingId.contractCostParamsMemoryBytes:
        return ConfingSettingContractCostParamsMemoryBytes.fromStruct(
            decode.value);

      case ConfigSettingId.contractDataKeySizeBytes:
        return ConfingSettingContractDataKeySizeBytes.fromStruct(decode.value);
      case ConfigSettingId.contractDataEntrySizeBytes:
        return ConfingSettingContractDataEnterySizeBytes.fromStruct(
            decode.value);
      case ConfigSettingId.stateArchival:
        return ConfigSettingContractStateArchivalSettings.fromStruct(
            decode.value);

      case ConfigSettingId.contractExecutionLanes:
        return ConfigSettingContractExecutionLanesV0.fromStruct(decode.value);
      case ConfigSettingId.bucketlistSizeWindow:
        return ConfigSettingBucketlistSizeWindow.fromStruct(decode.value);

      case ConfigSettingId.evictionIterator:
        return ConfigSettingEvictionIterator.fromStruct(decode.value);

      default:
        throw DartStellarPlugingException('Invalid ConfigSettingId.',
            details: {"ConfigSettingId": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
        List.generate(ConfigSettingId.values.length, (index) {
          final type = ConfigSettingId.values.elementAt(index);
          switch (type) {
            case ConfigSettingId.contractMaxSizeBytes:
              return LazyVariantModel(
                  layout: ConfingSettingContractMaxSizeBytes.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractComputeV0:
              return LazyVariantModel(
                  layout: ConfigSettingContractComputeV0.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractLedgerCostV0:
              return LazyVariantModel(
                  layout: ConfigSettingContractLedgerCostV0.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractHistoricalDataV0:
              return LazyVariantModel(
                  layout: ConfigSettingContractHistoricalDataV0.layout,
                  property: type.name,
                  index: type.value);

            case ConfigSettingId.contractEventsV0:
              return LazyVariantModel(
                  layout: ConfigSettingContractEventsV0.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractBandwidthV0:
              return LazyVariantModel(
                  layout: ConfigSettingContractBandwidthV0.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractCostParamsCpuInstructions:
              return LazyVariantModel(
                  layout:
                      ConfingSettingContractCostParamsCpuInstructions.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractCostParamsMemoryBytes:
              return LazyVariantModel(
                  layout: ConfingSettingContractCostParamsMemoryBytes.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractDataKeySizeBytes:
              return LazyVariantModel(
                  layout: ConfingSettingContractDataKeySizeBytes.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractDataEntrySizeBytes:
              return LazyVariantModel(
                  layout: ConfingSettingContractDataEnterySizeBytes.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.stateArchival:
              return LazyVariantModel(
                  layout: ConfigSettingContractStateArchivalSettings.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.contractExecutionLanes:
              return LazyVariantModel(
                  layout: ConfigSettingContractExecutionLanesV0.layout,
                  property: type.name,
                  index: type.value);
            case ConfigSettingId.bucketlistSizeWindow:
              return LazyVariantModel(
                  layout: ConfigSettingBucketlistSizeWindow.layout,
                  property: type.name,
                  index: type.value);

            case ConfigSettingId.evictionIterator:
              return LazyVariantModel(
                  layout: ConfigSettingEvictionIterator.layout,
                  property: type.name,
                  index: type.value);
            default:
              throw DartStellarPlugingException('Invalid ConfigSettingId.',
                  details: {"ConfigSettingId": type.name});
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => settingId.name;
}

class ConfingSettingContractMaxSizeBytes extends ConfigSetting {
  final int contractMaxSizeBytes;
  ConfingSettingContractMaxSizeBytes(int contractMaxSizeBytes)
      : contractMaxSizeBytes = contractMaxSizeBytes.asUint32,
        super(ConfigSettingId.contractMaxSizeBytes);
  factory ConfingSettingContractMaxSizeBytes.fromStruct(
      Map<String, dynamic> json) {
    return ConfingSettingContractMaxSizeBytes(json.as("contractMaxSizeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "contractMaxSizeBytes"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"contractMaxSizeBytes": contractMaxSizeBytes};
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
  })  : ledgerMaxInstructions = ledgerMaxInstructions.asInt64,
        txMaxInstructions = txMaxInstructions.asInt64,
        feeRatePerInstructionsIncrement =
            feeRatePerInstructionsIncrement.asInt64,
        txMemoryLimit = txMemoryLimit.asUint32,
        super(ConfigSettingId.contractComputeV0);
  factory ConfigSettingContractComputeV0.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingContractComputeV0(
      feeRatePerInstructionsIncrement:
          json.as("feeRatePerInstructionsIncrement"),
      ledgerMaxInstructions: json.as("ledgerMaxInstructions"),
      txMaxInstructions: json.as("txMaxInstructions"),
      txMemoryLimit: json.as("txMemoryLimit"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "ledgerMaxInstructions"),
      LayoutConst.s64be(property: "txMaxInstructions"),
      LayoutConst.s64be(property: "feeRatePerInstructionsIncrement"),
      LayoutConst.u32be(property: "txMemoryLimit"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "txMaxInstructions": txMaxInstructions,
      "ledgerMaxInstructions": ledgerMaxInstructions,
      "feeRatePerInstructionsIncrement": feeRatePerInstructionsIncrement,
      "txMemoryLimit": txMemoryLimit
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
  })  : ledgerMaxReadLedgerEntries = ledgerMaxReadLedgerEntries.asUint32,
        ledgerMaxReadBytes = ledgerMaxReadBytes.asUint32,
        ledgerMaxWriteLedgerEntries = ledgerMaxWriteLedgerEntries.asUint32,
        ledgerMaxWriteBytes = ledgerMaxWriteBytes.asUint32,
        txMaxReadLedgerEntries = txMaxReadLedgerEntries.asUint32,
        txMaxReadBytes = txMaxReadBytes.asUint32,
        txMaxWriteLedgerEntries = txMaxWriteLedgerEntries.asUint32,
        txMaxWriteBytes = txMaxWriteBytes.asUint32,
        feeReadLedgerEntry = feeReadLedgerEntry.asInt64,
        feeWriteLedgerEntry = feeWriteLedgerEntry.asInt64,
        feeRead1Kb = feeRead1Kb.asInt64,
        bucketListTargetSizeBytes = bucketListTargetSizeBytes.asInt64,
        writeFee1KbBucketListLow = writeFee1KbBucketListLow.asInt64,
        writeFee1KbBucketListHigh = writeFee1KbBucketListHigh.asInt64,
        bucketListWriteFeeGrowthFactor =
            bucketListWriteFeeGrowthFactor.asUint32,
        super(ConfigSettingId.contractLedgerCostV0);
  factory ConfigSettingContractLedgerCostV0.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingContractLedgerCostV0(
      bucketListTargetSizeBytes: json.as("bucketListTargetSizeBytes"),
      bucketListWriteFeeGrowthFactor: json.as("bucketListWriteFeeGrowthFactor"),
      feeRead1Kb: json.as("feeRead1Kb"),
      feeReadLedgerEntry: json.as("feeReadLedgerEntry"),
      feeWriteLedgerEntry: json.as("feeWriteLedgerEntry"),
      ledgerMaxReadBytes: json.as("ledgerMaxReadBytes"),
      ledgerMaxReadLedgerEntries: json.as("ledgerMaxReadLedgerEntries"),
      ledgerMaxWriteBytes: json.as("ledgerMaxWriteBytes"),
      ledgerMaxWriteLedgerEntries: json.as("ledgerMaxWriteLedgerEntries"),
      txMaxReadBytes: json.as("txMaxReadBytes"),
      txMaxReadLedgerEntries: json.as("txMaxReadLedgerEntries"),
      txMaxWriteBytes: json.as("txMaxWriteBytes"),
      txMaxWriteLedgerEntries: json.as("txMaxWriteLedgerEntries"),
      writeFee1KbBucketListHigh: json.as("writeFee1KbBucketListHigh"),
      writeFee1KbBucketListLow: json.as("writeFee1KbBucketListLow"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "ledgerMaxReadLedgerEntries"),
      LayoutConst.u32be(property: "ledgerMaxReadBytes"),
      LayoutConst.u32be(property: "ledgerMaxWriteLedgerEntries"),
      LayoutConst.u32be(property: "ledgerMaxWriteBytes"),
      LayoutConst.u32be(property: "txMaxReadLedgerEntries"),
      LayoutConst.u32be(property: "txMaxReadBytes"),
      LayoutConst.u32be(property: "txMaxWriteLedgerEntries"),
      LayoutConst.u32be(property: "txMaxWriteBytes"),
      LayoutConst.s64be(property: "feeReadLedgerEntry"),
      LayoutConst.s64be(property: "feeWriteLedgerEntry"),
      LayoutConst.s64be(property: "feeRead1Kb"),
      LayoutConst.s64be(property: "bucketListTargetSizeBytes"),
      LayoutConst.s64be(property: "writeFee1KbBucketListLow"),
      LayoutConst.s64be(property: "writeFee1KbBucketListHigh"),
      LayoutConst.u32be(property: "bucketListWriteFeeGrowthFactor"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ledgerMaxReadLedgerEntries": ledgerMaxReadLedgerEntries,
      "ledgerMaxReadBytes": ledgerMaxReadBytes,
      "ledgerMaxWriteLedgerEntries": ledgerMaxWriteLedgerEntries,
      "ledgerMaxWriteBytes": ledgerMaxWriteBytes,
      "txMaxReadLedgerEntries": txMaxReadLedgerEntries,
      "txMaxReadBytes": txMaxReadBytes,
      "txMaxWriteLedgerEntries": txMaxWriteLedgerEntries,
      "txMaxWriteBytes": txMaxWriteBytes,
      "feeReadLedgerEntry": feeReadLedgerEntry,
      "feeWriteLedgerEntry": feeWriteLedgerEntry,
      "feeRead1Kb": feeRead1Kb,
      "bucketListTargetSizeBytes": bucketListTargetSizeBytes,
      "writeFee1KbBucketListLow": writeFee1KbBucketListLow,
      "writeFee1KbBucketListHigh": writeFee1KbBucketListHigh,
      "bucketListWriteFeeGrowthFactor": bucketListWriteFeeGrowthFactor,
    };
  }
}

/// Historical data (pushed to core archives) settings for contracts.
class ConfigSettingContractHistoricalDataV0 extends ConfigSetting {
  /// Fee for storing 1KB in archives
  final BigInt feeHistorical1Kb;
  ConfigSettingContractHistoricalDataV0(BigInt feeHistorical1Kb)
      : feeHistorical1Kb = feeHistorical1Kb.asInt64,
        super(ConfigSettingId.contractHistoricalDataV0);
  factory ConfigSettingContractHistoricalDataV0.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingContractHistoricalDataV0(json.as("feeHistorical1Kb"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.s64be(property: "feeHistorical1Kb")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"feeHistorical1Kb": feeHistorical1Kb};
  }
}

/// Contract event-related settings.
class ConfigSettingContractEventsV0 extends ConfigSetting {
  ///  Maximum size of events that a contract call can emit.
  final int txMaxContractEventsSizeBytes;

  /// Fee for generating 1KB of contract events.
  final BigInt feeContractEvents1Kb;
  ConfigSettingContractEventsV0(
      {required int txMaxContractEventsSizeBytes,
      required BigInt feeContractEvents1Kb})
      : txMaxContractEventsSizeBytes = txMaxContractEventsSizeBytes.asUint32,
        feeContractEvents1Kb = feeContractEvents1Kb.asInt64,
        super(ConfigSettingId.contractEventsV0);
  factory ConfigSettingContractEventsV0.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingContractEventsV0(
        feeContractEvents1Kb: json.as("feeContractEvents1Kb"),
        txMaxContractEventsSizeBytes: json.as("txMaxContractEventsSizeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "txMaxContractEventsSizeBytes"),
      LayoutConst.s64be(property: "feeContractEvents1Kb"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "txMaxContractEventsSizeBytes": txMaxContractEventsSizeBytes,
      "feeContractEvents1Kb": feeContractEvents1Kb
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
  ConfigSettingContractBandwidthV0(
      {required int ledgerMaxTxsSizeBytes,
      required int txMaxSizeBytes,
      required BigInt feeTxSize1Kb})
      : ledgerMaxTxsSizeBytes = ledgerMaxTxsSizeBytes.asUint32,
        txMaxSizeBytes = txMaxSizeBytes.asUint32,
        feeTxSize1Kb = feeTxSize1Kb.asInt64,
        super(ConfigSettingId.contractBandwidthV0);
  factory ConfigSettingContractBandwidthV0.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingContractBandwidthV0(
        feeTxSize1Kb: json.as("feeTxSize1Kb"),
        ledgerMaxTxsSizeBytes: json.as("ledgerMaxTxsSizeBytes"),
        txMaxSizeBytes: json.as("txMaxSizeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "ledgerMaxTxsSizeBytes"),
      LayoutConst.u32be(property: "txMaxSizeBytes"),
      LayoutConst.s64be(property: "feeTxSize1Kb"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ledgerMaxTxsSizeBytes": ledgerMaxTxsSizeBytes,
      "txMaxSizeBytes": txMaxSizeBytes,
      "feeTxSize1Kb": feeTxSize1Kb
    };
  }
}

class ContractCostParamEntry extends XDRSerialization {
  /// use [ext] to add more terms (e.g. higher order polynomials) in the future
  final ExtentionPointVoid ext;
  final BigInt constTerm;
  final BigInt linearTerm;
  ContractCostParamEntry(
      {required BigInt constTerm,
      required BigInt linearTerm,
      this.ext = const ExtentionPointVoid()})
      : constTerm = constTerm.asInt64,
        linearTerm = linearTerm.asInt64;
  factory ContractCostParamEntry.fromStruct(Map<String, dynamic> json) {
    return ContractCostParamEntry(
        constTerm: json.as("constTerm"),
        linearTerm: json.as("linearTerm"),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      LayoutConst.s64be(property: "constTerm"),
      LayoutConst.s64be(property: "linearTerm"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "constTerm": constTerm,
      "linearTerm": linearTerm,
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class ConfingSettingContractCostParamsCpuInstructions extends ConfigSetting {
  final List<ContractCostParamEntry> params;
  ConfingSettingContractCostParamsCpuInstructions(
      List<ContractCostParamEntry> params)
      : params = params.immutable,
        super(ConfigSettingId.contractCostParamsCpuInstructions);
  factory ConfingSettingContractCostParamsCpuInstructions.fromStruct(
      Map<String, dynamic> json) {
    return ConfingSettingContractCostParamsCpuInstructions(json
        .asListOfMap("params")!
        .map((e) => ContractCostParamEntry.fromStruct(e))
        .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.xdrVec(ContractCostParamEntry.layout(property: "params"))],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"params": params.map((e) => e.toLayoutStruct()).toList()};
  }
}

class ConfingSettingContractCostParamsMemoryBytes extends ConfigSetting {
  final List<ContractCostParamEntry> params;
  ConfingSettingContractCostParamsMemoryBytes(
      List<ContractCostParamEntry> params)
      : params = params.immutable.max(1024,
            name: "ConfingSettingContractCostParamsMemoryBytes Params"),
        super(ConfigSettingId.contractCostParamsMemoryBytes);
  factory ConfingSettingContractCostParamsMemoryBytes.fromStruct(
      Map<String, dynamic> json) {
    return ConfingSettingContractCostParamsMemoryBytes(json
        .asListOfMap("params")!
        .map((e) => ContractCostParamEntry.fromStruct(e))
        .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.xdrVec(ContractCostParamEntry.layout(property: "params"))],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"params": params.map((e) => e.toLayoutStruct()).toList()};
  }
}

class ConfingSettingContractDataKeySizeBytes extends ConfigSetting {
  final int contractDataKeySizeBytes;
  ConfingSettingContractDataKeySizeBytes(int contractDataKeySizeBytes)
      : contractDataKeySizeBytes = contractDataKeySizeBytes.asUint32,
        super(ConfigSettingId.contractDataKeySizeBytes);
  factory ConfingSettingContractDataKeySizeBytes.fromStruct(
      Map<String, dynamic> json) {
    return ConfingSettingContractDataKeySizeBytes(
        json.as("contractDataKeySizeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "contractDataKeySizeBytes"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"contractDataKeySizeBytes": contractDataKeySizeBytes};
  }
}

class ConfingSettingContractDataEnterySizeBytes extends ConfigSetting {
  final int contractDataEnterySizeBytes;
  ConfingSettingContractDataEnterySizeBytes(int contractDataEnterySizeBytes)
      : contractDataEnterySizeBytes = contractDataEnterySizeBytes.asUint32,
        super(ConfigSettingId.contractDataEntrySizeBytes);
  factory ConfingSettingContractDataEnterySizeBytes.fromStruct(
      Map<String, dynamic> json) {
    return ConfingSettingContractDataEnterySizeBytes(
        json.as("contractDataEnterySizeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "contractDataEnterySizeBytes"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"contractDataEnterySizeBytes": contractDataEnterySizeBytes};
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
      bucketListSizeWindowSampleSize: json.as("bucketListSizeWindowSampleSize"),
      bucketListWindowSamplePeriod: json.as("bucketListWindowSamplePeriod"),
      evictionScanSize: json.as("evictionScanSize"),
      maxEntriesToArchive: json.as("maxEntriesToArchive"),
      maxEntryTtl: json.as("maxEntryTtl"),
      minPersistentTtl: json.as("minPersistentTtl"),
      minTemporaryTtl: json.as("minTemporaryTtl"),
      persistentRentRateDenominator: json.as("persistentRentRateDenominator"),
      startingEvictionScanLevel: json.as("startingEvictionScanLevel"),
      tempRentRateDenominator: json.as("tempRentRateDenominator"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "maxEntryTtl"),
      LayoutConst.u32be(property: "minTemporaryTtl"),
      LayoutConst.u32be(property: "minPersistentTtl"),
      LayoutConst.s64be(property: "persistentRentRateDenominator"),
      LayoutConst.s64be(property: "tempRentRateDenominator"),
      LayoutConst.u32be(property: "maxEntriesToArchive"),
      LayoutConst.u32be(property: "bucketListSizeWindowSampleSize"),
      LayoutConst.u32be(property: "bucketListWindowSamplePeriod"),
      LayoutConst.u32be(property: "evictionScanSize"),
      LayoutConst.u32be(property: "startingEvictionScanLevel"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "maxEntryTtl": maxEntryTtl,
      "minTemporaryTtl": minTemporaryTtl,
      "minPersistentTtl": minPersistentTtl,
      "persistentRentRateDenominator": persistentRentRateDenominator,
      "tempRentRateDenominator": tempRentRateDenominator,
      "maxEntriesToArchive": maxEntriesToArchive,
      "bucketListSizeWindowSampleSize": bucketListSizeWindowSampleSize,
      "bucketListWindowSamplePeriod": bucketListWindowSamplePeriod,
      "evictionScanSize": evictionScanSize,
      "startingEvictionScanLevel": startingEvictionScanLevel
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
  })  : maxEntryTtl = maxEntryTtl.asUint32,
        minTemporaryTtl = minTemporaryTtl.asUint32,
        minPersistentTtl = minPersistentTtl.asUint32,
        persistentRentRateDenominator = persistentRentRateDenominator.asInt64,
        tempRentRateDenominator = tempRentRateDenominator.asInt64,
        maxEntriesToArchive = maxEntriesToArchive.asUint32,
        bucketListSizeWindowSampleSize =
            bucketListSizeWindowSampleSize.asUint32,
        bucketListWindowSamplePeriod = bucketListWindowSamplePeriod.asUint32,
        evictionScanSize = evictionScanSize.asUint32,
        startingEvictionScanLevel = startingEvictionScanLevel.asUint32;
}

class ConfigSettingContractStateArchivalSettings extends ConfigSetting {
  final StateArchivalSettings settings;
  ConfigSettingContractStateArchivalSettings(this.settings)
      : super(ConfigSettingId.stateArchival);
  factory ConfigSettingContractStateArchivalSettings.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingContractStateArchivalSettings(
        StateArchivalSettings.fromStruct(json.asMap("settings")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [StateArchivalSettings.layout(property: "settings")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"settings": settings.toLayoutStruct()};
  }
}

/// General “Soroban execution lane” settings
class ConfigSettingContractExecutionLanesV0 extends ConfigSetting {
  /// maximum number of Soroban transactions per ledger
  final int ledgerMaxTxCount;
  ConfigSettingContractExecutionLanesV0(int ledgerMaxTxCount)
      : ledgerMaxTxCount = ledgerMaxTxCount.asUint32,
        super(ConfigSettingId.contractExecutionLanes);
  factory ConfigSettingContractExecutionLanesV0.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingContractExecutionLanesV0(json.as("ledgerMaxTxCount"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([LayoutConst.u32be(property: "ledgerMaxTxCount")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ledgerMaxTxCount": ledgerMaxTxCount};
  }
}

class ConfigSettingBucketlistSizeWindow extends ConfigSetting {
  ConfigSettingBucketlistSizeWindow(List<BigInt> bucketlistSizeWindow)
      : bucketlistSizeWindow =
            bucketlistSizeWindow.map((e) => e.asUint64).toList().immutable,
        super(ConfigSettingId.bucketlistSizeWindow);
  final List<BigInt> bucketlistSizeWindow;
  factory ConfigSettingBucketlistSizeWindow.fromStruct(
      Map<String, dynamic> json) {
    return ConfigSettingBucketlistSizeWindow(
        json.as<List>("ledgerMaxTxCount").map((e) {
      if (e is! BigInt) {
        throw DartStellarPlugingException("Incorrect value.", details: {
          "key": "ledgerMaxTxCount",
          "excepted": "BigInt",
          "value": e.runtimeType,
          "data": json["ledgerMaxTxCount"]
        });
      }
      return e;
    }).toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(LayoutConst.u64be(), property: "bucketlistSizeWindow")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"bucketlistSizeWindow": bucketlistSizeWindow};
  }
}

class EvictionIterator extends XDRSerialization {
  final int bucketListLevel;
  final bool isCurrBucket;
  final BigInt bucketFileOffset;
  EvictionIterator(
      {required int bucketListLevel,
      required this.isCurrBucket,
      required BigInt bucketFileOffset})
      : bucketListLevel = bucketListLevel.asUint32,
        bucketFileOffset = bucketFileOffset.asUint64;
  factory EvictionIterator.fromStruct(Map<String, dynamic> json) {
    return EvictionIterator(
        bucketFileOffset: json.as("bucketFileOffset"),
        bucketListLevel: json.as("bucketListLevel"),
        isCurrBucket: json.as("isCurrBucket"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "bucketListLevel"),
      LayoutConst.boolean32Be(property: "isCurrBucket"),
      LayoutConst.u64be(property: "bucketFileOffset"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "bucketFileOffset": bucketFileOffset,
      "isCurrBucket": isCurrBucket,
      "bucketListLevel": bucketListLevel
    };
  }
}

class ConfigSettingEvictionIterator extends ConfigSetting {
  final EvictionIterator evictionIterator;
  ConfigSettingEvictionIterator(this.evictionIterator)
      : super(ConfigSettingId.evictionIterator);
  factory ConfigSettingEvictionIterator.fromStruct(Map<String, dynamic> json) {
    return ConfigSettingEvictionIterator(
        EvictionIterator.fromStruct(json.asMap("evictionIterator")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ConfigSettingEvictionIterator.layout(property: "evictionIterator")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"evictionIterator": evictionIterator.toLayoutStruct()};
  }
}

class TTLEntery extends LedgerEntryData {
  /// Hash of the LedgerKey that is associated with this TTLEntery
  final List<int> keyHash;
  final int liveUntilLedgerSeq;
  TTLEntery({required List<int> keyHash, required int liveUntilLedgerSeq})
      : liveUntilLedgerSeq = liveUntilLedgerSeq.asUint32,
        keyHash = keyHash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "keyHash"),
        super(LedgerEntryType.ttl);
  factory TTLEntery.fromStruct(Map<String, dynamic> json) {
    return TTLEntery(
        keyHash: json.asBytes("keyHash"),
        liveUntilLedgerSeq: json.as("liveUntilLedgerSeq"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "keyHash"),
      LayoutConst.u32be(property: "liveUntilLedgerSeq"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"keyHash": keyHash, "liveUntilLedgerSeq": liveUntilLedgerSeq};
  }
}

class LedgerEntryExtensionV1 extends XDRSerialization {
  final ExtentionPointVoid ext;
  final StellarPublicKey? sponsoringId;
  LedgerEntryExtensionV1(
      {this.ext = const ExtentionPointVoid(), this.sponsoringId});
  factory LedgerEntryExtensionV1.fromStruct(Map<String, dynamic> json) {
    return LedgerEntryExtensionV1(
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
        sponsoringId: json.mybeAs<StellarPublicKey, Map<String, dynamic>>(
            key: "sponsoringId",
            onValue: (e) => StellarPublicKey.fromStruct(e)));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(StellarPublicKey.layout(),
          property: "sponsoringId"),
      ExtentionPointVoid.layout(property: "ext"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sponsoringId": sponsoringId?.toLayoutStruct(),
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class LedgerEntryExt extends XDRVariantSerialization {
  final LedgerEntryExtensionV1? v1;
  LedgerEntryExt({this.v1});

  factory LedgerEntryExt.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
            v1: LedgerEntryExtensionV1.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid LedgerEntry extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: LedgerEntryExtensionV1.layout,
          property: ExtensionPointType.extArgs1.name)
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
  LedgerEntry(
      {required int lastModifiedLedgerSeq,
      required this.data,
      required this.ext})
      : lastModifiedLedgerSeq = lastModifiedLedgerSeq.asUint32;
  factory LedgerEntry.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return LedgerEntry.fromStruct(decode);
  }
  factory LedgerEntry.fromStruct(Map<String, dynamic> json) {
    return LedgerEntry(
        data: LedgerEntryData.fromStruct(json.asMap("data")),
        ext: LedgerEntryExt.fromStruct(json.asMap("ext")),
        lastModifiedLedgerSeq: json.as("lastModifiedLedgerSeq"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "lastModifiedLedgerSeq"),
      LedgerEntryData.layout(property: "data"),
      LedgerEntryExt.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "lastModifiedLedgerSeq": lastModifiedLedgerSeq,
      "data": data.toVariantLayoutStruct(),
      "ext": ext.toVariantLayoutStruct()
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
        throw const DartStellarPlugingException("Invalid LedgerEntry type.");
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
                  property: type.name);
            case LedgerEntryType.trustline:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyTrustLine.layout,
                  property: type.name);
            case LedgerEntryType.offer:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyOffer.layout,
                  property: type.name);
            case LedgerEntryType.data:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyData.layout,
                  property: type.name);
            case LedgerEntryType.claimableBalance:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyClaimableBalance.layout,
                  property: type.name);
            case LedgerEntryType.liquidityPool:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyLiquidityPool.layout,
                  property: type.name);
            case LedgerEntryType.contractData:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyContractData.layout,
                  property: type.name);
            case LedgerEntryType.contractCode:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyContractCode.layout,
                  property: type.name);
            case LedgerEntryType.configSetting:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyConfigSetting.layout,
                  property: type.name);
            case LedgerEntryType.ttl:
              return LazyVariantModel(
                  index: type.value,
                  layout: LedgerKeyTTL.layout,
                  property: type.name);
            default:
              throw const DartStellarPlugingException(
                  "Invalid LedgerEntry type.");
          }
        }),
        property: property);
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
    return LedgerKeyAccount(json.asMap("accountId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"accountId": accountId.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"accountId": accountId.toAddress().toString()};
  }
}

class LedgerKeyTrustLine extends LedgerKey {
  final StellarPublicKey accountId;
  final TrustLineAsset asset;
  const LedgerKeyTrustLine({required this.accountId, required this.asset})
      : super(LedgerEntryType.trustline);
  factory LedgerKeyTrustLine.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyTrustLine(
        accountId: json.asMap("accountId"),
        asset: TrustLineAsset.fromStruct(json.asMap("asset")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      TrustLineAsset.layout(property: "asset")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "accountId": accountId.toLayoutStruct(),
      "asset": asset.toVariantLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "accountId": accountId.toAddress().toString(),
      "asset": asset.toJson()
    };
  }
}

class LedgerKeyOffer extends LedgerKey {
  final StellarPublicKey accountId;
  final BigInt offerId;
  LedgerKeyOffer({required this.accountId, required BigInt offerId})
      : offerId = offerId.asInt64,
        super(LedgerEntryType.offer);
  factory LedgerKeyOffer.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyOffer(
        accountId: json.asMap("accountId"), offerId: json.as("offerId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      LayoutConst.s64be(property: "offerId")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"accountId": accountId.toLayoutStruct(), "offerId": offerId};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "accountId": accountId.toAddress().toString(),
      "offerId": offerId.toString()
    };
  }
}

class LedgerKeyData extends LedgerKey {
  final StellarPublicKey accountId;
  final String dataName;
  LedgerKeyData({required this.accountId, required String dataName})
      : dataName = dataName.max(64),
        super(LedgerEntryType.data);
  factory LedgerKeyData.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyData(
        accountId: json.asMap("accountId"), dataName: json.as("dataName"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      LayoutConst.xdrString(property: "dataName")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"accountId": accountId.toLayoutStruct(), "dataName": dataName};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "accountId": accountId.toAddress().toString(),
      "dataName": dataName
    };
  }
}

class LedgerKeyClaimableBalance extends LedgerKey {
  final ClaimableBalanceId balanceId;
  const LedgerKeyClaimableBalance(this.balanceId)
      : super(LedgerEntryType.claimableBalance);
  factory LedgerKeyClaimableBalance.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyClaimableBalance(
        ClaimableBalanceId.fromStruct(json.asMap("balanceId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ClaimableBalanceId.layout(property: "balanceId")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "balanceId": balanceId.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "balanceId": balanceId.toJson(),
    };
  }
}

class LedgerKeyLiquidityPool extends LedgerKey {
  final List<int> liquidityPoolId;
  LedgerKeyLiquidityPool(List<int> liquidityPoolId)
      : liquidityPoolId = liquidityPoolId.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "liquidityPoolId"),
        super(LedgerEntryType.liquidityPool);
  factory LedgerKeyLiquidityPool.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyLiquidityPool(json.asBytes("liquidityPoolId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "liquidityPoolId")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"liquidityPoolId": liquidityPoolId};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "liquidityPoolId": BytesUtils.toHexString(liquidityPoolId, prefix: "0x"),
    };
  }
}

class LedgerKeyContractData extends LedgerKey {
  final ScAddress contract;
  final ScVal key;
  final ContractDataDurability durability;
  const LedgerKeyContractData(
      {required this.contract, required this.key, required this.durability})
      : super(LedgerEntryType.contractData);
  factory LedgerKeyContractData.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyContractData(
        contract: ScAddress.fromStruct(json.asMap("contract")),
        durability: ContractDataDurability.fromValue(json.as("durability")),
        key: ScVal.fromStruct(json.asMap("key")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: "contract"),
      ScVal.layout(property: "key"),
      LayoutConst.s32be(property: "durability")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "contract": contract.toVariantLayoutStruct(),
      "key": key.toVariantLayoutStruct(),
      "durability": durability.value
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "contract": contract.toJson(),
      "key": key.toJson(),
      "durability": durability.name
    };
  }
}

class LedgerKeyContractCode extends LedgerKey {
  final List<int> hash;
  LedgerKeyContractCode(List<int> hash)
      : hash = hash.asImmutableBytes.exc(StellarConst.hash256Length,
            name: "LedgerKeyContractCode Hash"),
        super(LedgerEntryType.contractCode);
  factory LedgerKeyContractCode.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyContractCode(json.asBytes("hash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hash": hash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"hash": BytesUtils.toHexString(hash, prefix: "0x")};
  }
}

class LedgerKeyConfigSetting extends LedgerKey {
  final ConfigSettingId configSettingId;
  const LedgerKeyConfigSetting(this.configSettingId)
      : super(LedgerEntryType.configSetting);
  factory LedgerKeyConfigSetting.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyConfigSetting(
        ConfigSettingId.fromValue(json.as("configSettingId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "configSettingId"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"configSettingId": configSettingId.value};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"configSettingId": configSettingId.name};
  }
}

class LedgerKeyTTL extends LedgerKey {
  final List<int> keyHash;
  LedgerKeyTTL(List<int> keyHash)
      : keyHash = keyHash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "keyHash"),
        super(LedgerEntryType.ttl);
  factory LedgerKeyTTL.fromStruct(Map<String, dynamic> json) {
    return LedgerKeyTTL(json.asBytes("keyHash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "keyHash")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"keyHash": keyHash};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"keyHash": BytesUtils.toHexString(keyHash, prefix: "0x")};
  }
}

class LedgerFootprint extends XDRSerialization {
  final List<LedgerKey> readOnly;
  final List<LedgerKey> readWrite;
  LedgerFootprint(
      {required List<LedgerKey> readOnly, required List<LedgerKey> readWrite})
      : readOnly = readOnly.immutable,
        readWrite = readWrite.immutable;
  factory LedgerFootprint.fromStruct(Map<String, dynamic> json) {
    return LedgerFootprint(
      readOnly: json
          .asListOfMap("readOnly")!
          .map((e) => LedgerKey.fromStruct(e))
          .toList(),
      readWrite: json
          .asListOfMap("readWrite")!
          .map((e) => LedgerKey.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(LedgerKey.layout(), property: "readOnly"),
      LayoutConst.xdrVec(LedgerKey.layout(), property: "readWrite"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "readOnly": readOnly.map((e) => e.toVariantLayoutStruct()).toList(),
      "readWrite": readWrite.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "readOnly": readOnly.map((e) => e.toJson()).toList(),
      "readWrite": readWrite.map((e) => e.toJson()).toList(),
    };
  }
}

class SorobanResources extends XDRSerialization {
  final LedgerFootprint footprint;
  final int instructions;
  final int readBytes;
  final int writeBytes;
  SorobanResources(
      {required this.footprint,
      required int instructions,
      required int readBytes,
      required int writeBytes})
      : instructions = instructions.asUint32,
        readBytes = readBytes.asUint32,
        writeBytes = writeBytes.asUint32;
  factory SorobanResources.fromStruct(Map<String, dynamic> json) {
    return SorobanResources(
        footprint: LedgerFootprint.fromStruct(json.asMap("footprint")),
        instructions: json.as("instructions"),
        readBytes: json.as("readBytes"),
        writeBytes: json.as("writeBytes"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LedgerFootprint.layout(property: "footprint"),
      LayoutConst.u32be(property: "instructions"),
      LayoutConst.u32be(property: "readBytes"),
      LayoutConst.u32be(property: "writeBytes"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "footprint": footprint.toLayoutStruct(),
      "instructions": instructions,
      "readBytes": readBytes,
      "writeBytes": writeBytes
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "footprint": footprint.toJson(),
      "instructions": instructions,
      "readBytes": readBytes,
      "writeBytes": writeBytes
    };
  }
}

class SorobanTransactionData extends XDRSerialization {
  final ExtentionPointVoid ext;
  final SorobanResources resources;
  final BigInt resourceFee;
  SorobanTransactionData(
      {required this.resources,
      required BigInt resourceFee,
      this.ext = const ExtentionPointVoid()})
      : resourceFee = resourceFee.asInt64;

  factory SorobanTransactionData.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return SorobanTransactionData.fromStruct(decode);
  }
  factory SorobanTransactionData.fromStruct(Map<String, dynamic> json) {
    return SorobanTransactionData(
        resources: SorobanResources.fromStruct(json.asMap("resources")),
        resourceFee: json.as("resourceFee"),
        ext: ExtentionPointVoid.fromStruct(json.as("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      SorobanResources.layout(property: "resources"),
      LayoutConst.s64be(property: "resourceFee"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ext": ext.toVariantLayoutStruct(),
      "resources": resources.toLayoutStruct(),
      "resourceFee": resourceFee
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "resources": resources.toJson(),
      "resourceFee": resourceFee.toString()
    };
  }
}

class CryptoKeyType {
  final String name;
  final int value;

  const CryptoKeyType._({required this.name, required this.value});

  static const ed25519 = CryptoKeyType._(name: 'Ed25519', value: 0);
  static const preAuthTx = CryptoKeyType._(name: 'PreAuthTx', value: 1);
  static const hashX = CryptoKeyType._(name: 'HashX', value: 2);
  static const ed25519SignedPayload =
      CryptoKeyType._(name: 'Ed25519SignedPayload', value: 3);
  static const muxedEd25519 = CryptoKeyType._(name: 'MuxedEd25519', value: 256);
  static const List<CryptoKeyType> values = [
    ed25519,
    preAuthTx,
    hashX,
    ed25519SignedPayload,
    muxedEd25519
  ];
  static CryptoKeyType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("Asset type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "CryptoKeyType.$name";
  }
}

abstract class MuxedAccount extends XDRVariantSerialization {
  final CryptoKeyType type;
  const MuxedAccount._(this.type);
  StellarAddress get address;
  factory MuxedAccount(StellarAddress address) {
    if (address.type == XlmAddrTypes.muxed) {
      address as StellarMuxedAddress;
      return MuxedAccountMed25519(
          id: address.accountId, ed25519: address.keyBytes());
    } else if (address.type != XlmAddrTypes.pubKey) {
      throw DartStellarPlugingException(
          "Only Stellar ED25519 public key address (XlmAddrTypes.pubKey, XlmAddrTypes.muxed) can be converted to muxed account.",
          details: {"type": address.type.name});
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
    final type = CryptoKeyType.fromName(decode.variantName);
    switch (type) {
      case CryptoKeyType.ed25519:
        return MuxedAccountEd25519.fromStruct(decode.value);
      case CryptoKeyType.muxedEd25519:
        return MuxedAccountMed25519.fromStruct(decode.value);
      default:
        throw DartStellarPlugingException("Invalid MuxedAccount type.",
            details: {"type": type});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.lazyEnumU32Be([
        LazyVariantModel(
            index: CryptoKeyType.ed25519.value,
            layout: MuxedAccountEd25519.layout,
            property: CryptoKeyType.ed25519.name),
        LazyVariantModel(
            index: CryptoKeyType.muxedEd25519.value,
            layout: MuxedAccountMed25519.layout,
            property: CryptoKeyType.muxedEd25519.name),
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
  final List<int> ed25519;
  MuxedAccountMed25519({required BigInt id, required List<int> ed25519})
      : id = id.asUint64,
        ed25519 = ed25519.asImmutableBytes,
        super._(CryptoKeyType.muxedEd25519);

  factory MuxedAccountMed25519.fromStruct(Map<String, dynamic> json) {
    return MuxedAccountMed25519(
        id: json.as("id"), ed25519: json.asBytes("ed25519"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.struct([
        LayoutConst.u64be(property: "id"),
        LayoutConst.fixedBlob32(property: "ed25519"),
      ], property: property);

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"id": id, "ed25519": ed25519};
  }

  @override
  StellarMuxedAddress get address =>
      StellarMuxedAddress.fromPublicKey(publicKey: ed25519, accountId: id);
}

class MuxedAccountEd25519 extends MuxedAccount {
  final List<int> ed25519;
  MuxedAccountEd25519(List<int> ed25519)
      : ed25519 = ed25519.asImmutableBytes,
        super._(CryptoKeyType.ed25519);
  factory MuxedAccountEd25519.fromStruct(Map<String, dynamic> json) {
    return MuxedAccountEd25519(json.asBytes("ed25519"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.struct([
        LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "ed25519")
      ], property: property);
  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ed25519": ed25519};
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
      orElse: () => throw DartStellarPlugingException(
          "Precondition type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

class TimeBounds extends XDRSerialization {
  final BigInt minTime;
  final BigInt maxTime;
  TimeBounds({required BigInt minTime, required BigInt maxTime})
      : minTime = minTime.asUint64,
        maxTime = maxTime.asUint64;
  factory TimeBounds.fromStruct(Map<String, dynamic> json) {
    return TimeBounds(minTime: json.as("minTime"), maxTime: json.as("maxTime"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "minTime"),
      LayoutConst.u64be(property: "maxTime")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"minTime": minTime, "maxTime": maxTime};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"minTime": minTime.toString(), "maxTime": maxTime.toString()};
  }
}

class LedgerBounds extends XDRSerialization {
  final int minLedger;
  final int maxLedger;
  LedgerBounds({required int minLedger, required int maxLedger})
      : minLedger = minLedger.asUint32,
        maxLedger = maxLedger.asUint32;
  factory LedgerBounds.fromStruct(Map<String, dynamic> json) {
    return LedgerBounds(
        minLedger: json.as("minLedger"), maxLedger: json.as("maxLedger"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "minLedger"),
      LayoutConst.u32be(property: "maxLedger")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"minLedger": minLedger, "maxLedger": maxLedger};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"minLedger": minLedger, "maxLedger": maxLedger};
  }
}

class PreconditionsV2 extends XDRSerialization {
  final TimeBounds? timeBounds;
  final LedgerBounds? ledgerBounds;
  final BigInt? minSeqNum;
  final BigInt minSeqAge;
  final int minSeqLedgerGap;
  final List<SignerKey> extraSigners;
  PreconditionsV2(
      {this.timeBounds,
      this.ledgerBounds,
      BigInt? minSeqNum,
      required BigInt minSeqAge,
      required int minSeqLedgerGap,
      required List<SignerKey> extraSigners})
      : minSeqNum = minSeqNum?.asInt64,
        minSeqAge = minSeqAge.asUint64,
        minSeqLedgerGap = minSeqLedgerGap.asUint32,
        extraSigners = extraSigners.immutable.max(2, name: "extraSigners");
  factory PreconditionsV2.fromStruct(Map<String, dynamic> json) {
    return PreconditionsV2(
        timeBounds: json.mybeAs<TimeBounds, Map<String, dynamic>>(
            key: "timeBounds", onValue: (e) => TimeBounds.fromStruct(e)),
        ledgerBounds: json.mybeAs<LedgerBounds, Map<String, dynamic>>(
            key: "ledgerBounds", onValue: (e) => LedgerBounds.fromStruct(e)),
        minSeqNum: json.as("minSeqNum"),
        minSeqAge: json.as("minSeqAge"),
        minSeqLedgerGap: json.as("minSeqLedgerGap"),
        extraSigners: json
            .asListOfMap("extraSigners")!
            .map((e) => SignerKey.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(TimeBounds.layout(), property: "timeBounds"),
      LayoutConst.optionalU32Be(LedgerBounds.layout(),
          property: "ledgerBounds"),
      LayoutConst.optionalU32Be(LayoutConst.s64be(), property: "minSeqNum"),
      LayoutConst.u64be(property: "minSeqAge"),
      LayoutConst.u32be(property: "minSeqLedgerGap"),
      LayoutConst.xdrVec(SignerKey.layout(), property: "extraSigners")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "timeBounds": timeBounds?.toLayoutStruct(),
      "ledgerBounds": ledgerBounds?.toLayoutStruct(),
      "minSeqNum": minSeqNum,
      "minSeqAge": minSeqAge,
      "minSeqLedgerGap": minSeqLedgerGap,
      "extraSigners":
          extraSigners.map((e) => e.toVariantLayoutStruct()).toList()
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
        throw DartStellarPlugingException("Invalid Precondition type.",
            details: {"type": type.name});
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: PreconditionType.none.value,
          layout: PrecondNone.layout,
          property: PreconditionType.none.name),
      LazyVariantModel(
          index: PreconditionType.time.value,
          layout: PrecondTime.layout,
          property: PreconditionType.time.name),
      LazyVariantModel(
          index: PreconditionType.v2.value,
          layout: PrecondV2.layout,
          property: PreconditionType.v2.name)
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
    return PrecondTime(TimeBounds.fromStruct(json.asMap("timeBounds")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([TimeBounds.layout(property: "timeBounds")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"timeBounds": timeBounds.toLayoutStruct()};
  }
}

class PrecondV2 extends Preconditions {
  final PreconditionsV2 preconditionsV2;
  const PrecondV2(this.preconditionsV2) : super(PreconditionType.v2);
  factory PrecondV2.fromStruct(Map<String, dynamic> json) {
    return PrecondV2(PreconditionsV2.fromStruct(json.asMap("preconditionsV2")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [PreconditionsV2.layout(property: "preconditionsV2")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"preconditionsV2": preconditionsV2.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"preconditionsV2": preconditionsV2.toJson()};
  }
}

abstract class AssetCode extends XDRVariantSerialization {
  final AssetType type;
  final List<int> code;
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
        throw DartStellarPlugingException("Invalid AssetCode type",
            details: {"type": type});
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.enum32Be([
      LayoutConst.none(),
      AssetCode4.layout(property: AssetType.creditAlphanum4.name),
      AssetCode12.layout(property: AssetType.creditAlphanum12.name),
      LayoutConst.none(),
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
            code: code.asImmutableBytes.exc(codeLength, name: "Asset code"));
  factory AssetCode4.fromString(String code) {
    return AssetCode4(
        StellarHelper.toAlphanumAssetCode(code: code, length: codeLength));
  }
  factory AssetCode4.fromStruct(Map<String, dynamic> json) {
    return AssetCode4(json.asBytes("code"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(codeLength, property: "code"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"code": code};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"code": StellarHelper.toAssetsCode(code)};
  }
}

class AssetCode12 extends AssetCode {
  static const int codeLength = 12;
  AssetCode12(List<int> code)
      : super(
            type: AssetType.creditAlphanum12,
            code: code.asImmutableBytes.exc(codeLength, name: "Asset code"));
  factory AssetCode12.fromString(String code) {
    return AssetCode12(
        StellarHelper.toAlphanumAssetCode(code: code, length: codeLength));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(codeLength, property: "code"),
    ], property: property);
  }

  factory AssetCode12.fromStruct(Map<String, dynamic> json) {
    return AssetCode12(json.asBytes("code"));
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"code": code};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"code": StellarHelper.toAssetsCode(code)};
  }
}

class RevokeSponsorshipType {
  final String name;
  final int value;
  const RevokeSponsorshipType._({required this.name, required this.value});
  static const RevokeSponsorshipType ledgerEntry =
      RevokeSponsorshipType._(name: "LedgerEntry", value: 0);
  static const RevokeSponsorshipType signer =
      RevokeSponsorshipType._(name: "Signer", value: 1);

  static const List<RevokeSponsorshipType> values = [ledgerEntry, signer];
  static RevokeSponsorshipType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "RevokeSponsorship type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "RevokeSponsorshipType.$name";
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
        throw DartStellarPlugingException("Invalid RevokeSponsorship type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: RevokeSponsorshipType.ledgerEntry.value,
          layout: RevokeSponsorshipLedgerKey.layout,
          property: RevokeSponsorshipType.ledgerEntry.name),
      LazyVariantModel(
          index: RevokeSponsorshipType.signer.value,
          layout: RevokeSponsorshipSigner.layout,
          property: RevokeSponsorshipType.signer.name),
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
  const RevokeSponsorshipSigner(
      {required this.accountId, required this.signerKey})
      : super(RevokeSponsorshipType.signer);
  factory RevokeSponsorshipSigner.fromStruct(Map<String, dynamic> json) {
    return RevokeSponsorshipSigner(
        accountId: StellarPublicKey.fromStruct(json.asMap("accountId")),
        signerKey: SignerKey.fromStruct(json.asMap("signerKey")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      SignerKey.layout(property: "signerKey")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "accountId": accountId.toLayoutStruct(),
      "signerKey": signerKey.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "accountId": accountId.toAddress().toString(),
      "signerKey": signerKey.toJson(),
    };
  }
}

class RevokeSponsorshipLedgerKey extends RevokeSponsorship {
  final LedgerKey ledgerKey;
  const RevokeSponsorshipLedgerKey(this.ledgerKey)
      : super(RevokeSponsorshipType.ledgerEntry);
  factory RevokeSponsorshipLedgerKey.fromStruct(Map<String, dynamic> json) {
    return RevokeSponsorshipLedgerKey(
        LedgerKey.fromStruct(json.asMap("ledgerKey")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LedgerKey.layout(property: "ledgerKey"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "ledgerKey": ledgerKey.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {"ledgerKey": ledgerKey.toJson()};
  }
}

class HostFunctionType {
  final String name;
  final int value;

  const HostFunctionType._({required this.name, required this.value});

  static const invokeContract =
      HostFunctionType._(name: 'InvokeContract', value: 0);
  static const createContract =
      HostFunctionType._(name: 'CreateContract', value: 1);
  static const uploadContractWasm =
      HostFunctionType._(name: 'UploadContractWasm', value: 2);
  static const List<HostFunctionType> values = [
    invokeContract,
    createContract,
    uploadContractWasm
  ];
  static HostFunctionType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "HostFunction type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "HostFunctionType.$name";
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
      default:
        throw DartStellarPlugingException("Invalid HostFunction type.",
            details: {"type": type.name});
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: HostFunctionType.invokeContract.value,
          layout: HostFunctionTypeInvokeContract.layout,
          property: HostFunctionType.invokeContract.name),
      LazyVariantModel(
          index: HostFunctionType.createContract.value,
          layout: HostFunctionTypeCreateContract.layout,
          property: HostFunctionType.createContract.name),
      LazyVariantModel(
          index: HostFunctionType.uploadContractWasm.value,
          layout: HostFunctionTypeUploadContractWasm.layout,
          property: HostFunctionType.uploadContractWasm.name),
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
        InvokeContractArgs.fromStruct(json.asMap("args")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([InvokeContractArgs.layout(property: "args")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "args": args.toLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {"args": args.toJson()};
  }
}

class ContractIdPreimageType {
  final String name;
  final int value;

  const ContractIdPreimageType._({required this.name, required this.value});

  static const fromAddress =
      ContractIdPreimageType._(name: 'FromAddress', value: 0);
  static const fromAsset =
      ContractIdPreimageType._(name: 'FromAsset', value: 1);

  static const List<ContractIdPreimageType> values = [fromAddress, fromAsset];
  static ContractIdPreimageType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ContractIdPreimage type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "ContractIdPreimageType.$name";
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
        throw DartStellarPlugingException("Invalid ContractIdPreimage type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ContractIdPreimageType.fromAddress.value,
          layout: ContractIdPreimageFromAddress.layout,
          property: ContractIdPreimageType.fromAddress.name),
      LazyVariantModel(
          index: ContractIdPreimageType.fromAsset.value,
          layout: ContractIdPreimageFromAsset.layout,
          property: ContractIdPreimageType.fromAsset.name),
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
  final List<int> salt;
  ContractIdPreimageFromAddress(
      {required this.address, required List<int> salt})
      : salt = salt.immutable.exc(StellarConst.hash256Length, name: "salt"),
        super(ContractIdPreimageType.fromAddress);
  factory ContractIdPreimageFromAddress.fromStruct(Map<String, dynamic> json) {
    return ContractIdPreimageFromAddress(
      address: ScAddress.fromStruct(json.asMap("address")),
      salt: json.asBytes("salt"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: "address"),
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "salt")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"address": address.toVariantLayoutStruct(), "salt": salt};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "address": address.address.toString(),
      "salt": BytesUtils.toHexString(salt, prefix: "0x")
    };
  }
}

class ContractIdPreimageFromAsset extends ContractIdPreimage {
  final StellarAsset asset;
  ContractIdPreimageFromAsset(this.asset)
      : super(ContractIdPreimageType.fromAsset);
  factory ContractIdPreimageFromAsset.fromStruct(Map<String, dynamic> json) {
    return ContractIdPreimageFromAsset(
      StellarAsset.fromStruct(json.asMap("asset")),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "asset"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"asset": asset.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"asset": asset.toJson()};
  }
}

class CreateContractArgs extends XDRSerialization {
  final ContractIdPreimage contractIdPreimage;
  final ContractExecutable executable;
  const CreateContractArgs(
      {required this.contractIdPreimage, required this.executable});
  factory CreateContractArgs.fromStruct(Map<String, dynamic> json) {
    return CreateContractArgs(
        contractIdPreimage:
            ContractIdPreimage.fromStruct(json.as("contractIdPreimage")),
        executable: ContractExecutable.fromStruct(json.as("executable")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ContractIdPreimage.layout(property: "contractIdPreimage"),
      ContractExecutable.layout(property: "executable"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "contractIdPreimage": contractIdPreimage.toVariantLayoutStruct(),
      "executable": executable.toVariantLayoutStruct(),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "contractIdPreimage": contractIdPreimage.toJson(),
      "executable": executable.toJson(),
    };
  }
}

class HostFunctionTypeCreateContract extends HostFunction {
  final CreateContractArgs args;
  const HostFunctionTypeCreateContract(this.args)
      : super(HostFunctionType.createContract);
  factory HostFunctionTypeCreateContract.fromStruct(Map<String, dynamic> json) {
    return HostFunctionTypeCreateContract(
        CreateContractArgs.fromStruct(json.asMap("args")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgs.layout(property: "args"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"args": args.toLayoutStruct()};
  }
}

class HostFunctionTypeUploadContractWasm extends HostFunction {
  final List<int> wasm;
  HostFunctionTypeUploadContractWasm(List<int> wasm)
      : wasm = wasm.asImmutableBytes,
        super(HostFunctionType.uploadContractWasm);
  factory HostFunctionTypeUploadContractWasm.fromStruct(
      Map<String, dynamic> json) {
    return HostFunctionTypeUploadContractWasm(json.asBytes("wasm"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVecBytes(property: "wasm"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"wasm": wasm};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"wasm": BytesUtils.toHexString(wasm)};
  }
}

class SorobanCredentialsType {
  final String name;
  final int value;

  const SorobanCredentialsType._({required this.name, required this.value});

  static const sourceAccount =
      SorobanCredentialsType._(name: 'SourceAccount', value: 0);
  static const address = SorobanCredentialsType._(name: 'Address', value: 1);
  static const List<SorobanCredentialsType> values = [sourceAccount, address];
  static SorobanCredentialsType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "SorobanCredentials type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "SorobanCredentialsType.$name";
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
      case SorobanCredentialsType.sourceAccount:
        return SorobanCredentialsSourceAccount.fromStruct(decode.value);
      default:
        throw DartStellarPlugingException("Invalid SorobanCredentials type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: SorobanCredentialsType.sourceAccount.value,
          layout: SorobanCredentialsSourceAccount.layout,
          property: SorobanCredentialsType.sourceAccount.name),
      LazyVariantModel(
          index: SorobanCredentialsType.address.value,
          layout: SorobanAddressCredentials.layout,
          property: SorobanCredentialsType.address.name),
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
  SorobanAddressCredentials(
      {required this.address,
      required BigInt nonce,
      required int signatureExpirationLedger,
      required this.signature})
      : nonce = nonce.asInt64,
        signatureExpirationLedger = signatureExpirationLedger.asUint32,
        super(SorobanCredentialsType.address);
  factory SorobanAddressCredentials.fromStruct(Map<String, dynamic> json) {
    return SorobanAddressCredentials(
        address: ScAddress.fromStruct(json.asMap("address")),
        nonce: json.as("nonce"),
        signatureExpirationLedger: json.as("signatureExpirationLedger"),
        signature: ScVal.fromStruct(json.asMap("signature")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: "address"),
      LayoutConst.s64be(property: "nonce"),
      LayoutConst.u32be(property: "signatureExpirationLedger"),
      ScVal.layout(property: "signature")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "address": address.toVariantLayoutStruct(),
      "nonce": nonce,
      "signatureExpirationLedger": signatureExpirationLedger,
      "signature": signature.toVariantLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "address": address.address.toString(),
      "nonce": nonce.toString(),
      "signatureExpirationLedger": signatureExpirationLedger,
      "signature": signature.toJson()
    };
  }
}

class SorobanCredentialsSourceAccount extends SorobanCredentials {
  const SorobanCredentialsSourceAccount()
      : super(SorobanCredentialsType.sourceAccount);
  factory SorobanCredentialsSourceAccount.fromStruct(
      Map<String, dynamic> json) {
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

  const SorobanAuthorizedFunctionType._(
      {required this.name, required this.value});

  static const contractFn =
      SorobanAuthorizedFunctionType._(name: 'ContractFn', value: 0);
  static const createContractHostFn =
      SorobanAuthorizedFunctionType._(name: 'CreateContractHostFn', value: 1);
  static const List<SorobanAuthorizedFunctionType> values = [
    contractFn,
    createContractHostFn
  ];
  static SorobanAuthorizedFunctionType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "SorobanAuthorizedFunction type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "SorobanAuthorizedFunctionType.$name";
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
            decode.value);
      case SorobanAuthorizedFunctionType.createContractHostFn:
        return SorobanAuthorizedFunctionTypeCreateContractHostFunction
            .fromStruct(decode.value);
      default:
        throw DartStellarPlugingException(
            "Invalid SorobanAuthorizedFunction type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: SorobanAuthorizedFunctionType.contractFn.value,
          layout: SorobanAuthorizedFunctionTypeContractFunction.layout,
          property: SorobanAuthorizedFunctionType.contractFn.name),
      LazyVariantModel(
          index: SorobanAuthorizedFunctionType.createContractHostFn.value,
          layout:
              SorobanAuthorizedFunctionTypeCreateContractHostFunction.layout,
          property: SorobanAuthorizedFunctionType.createContractHostFn.name),
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
  InvokeContractArgs(
      {required this.contractAddress,
      required this.functionName,
      required List<ScVal> args})
      : args = args.immutable;
  factory InvokeContractArgs.fromStruct(Map<String, dynamic> json) {
    return InvokeContractArgs(
        contractAddress: ScAddress.fromStruct(json.asMap("contractAddress")),
        functionName: ScValSymbol.fromStruct(json.asMap("functionName")),
        args:
            json.asListOfMap("args")!.map((e) => ScVal.fromStruct(e)).toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScAddress.layout(property: "contractAddress"),
      ScValSymbol.layout(property: "functionName"),
      LayoutConst.xdrVec(ScVal.layout(), property: "args")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "contractAddress": contractAddress.address.toString(),
      "functionName": functionName.value,
      "args": args.map((e) => e.toJson()).toList()
    };
  }

  /// should be test
  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "contractAddress": contractAddress.toVariantLayoutStruct(),
      "functionName": functionName.toLayoutStruct(),
      "args": args.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }
}

class SorobanAuthorizedFunctionTypeContractFunction
    extends SorobanAuthorizedFunction {
  final InvokeContractArgs args;
  const SorobanAuthorizedFunctionTypeContractFunction(this.args)
      : super(SorobanAuthorizedFunctionType.contractFn);
  factory SorobanAuthorizedFunctionTypeContractFunction.fromStruct(
      Map<String, dynamic> json) {
    return SorobanAuthorizedFunctionTypeContractFunction(
        InvokeContractArgs.fromStruct(json.asMap("args")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      InvokeContractArgs.layout(property: "args"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"args": args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"args": args.toJson()};
  }
}

class SorobanAuthorizedFunctionTypeCreateContractHostFunction
    extends SorobanAuthorizedFunction {
  final CreateContractArgs args;
  const SorobanAuthorizedFunctionTypeCreateContractHostFunction(this.args)
      : super(SorobanAuthorizedFunctionType.createContractHostFn);

  factory SorobanAuthorizedFunctionTypeCreateContractHostFunction.fromStruct(
      Map<String, dynamic> json) {
    return SorobanAuthorizedFunctionTypeCreateContractHostFunction(
        CreateContractArgs.fromStruct(json.asMap("args")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      CreateContractArgs.layout(property: "args"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"args": args.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"args": args.toJson()};
  }
}

class SorobanAuthorizedInvocation extends XDRSerialization {
  final SorobanAuthorizedFunction function;
  final List<SorobanAuthorizedInvocation> subInvocations;
  SorobanAuthorizedInvocation(
      {required this.function,
      required List<SorobanAuthorizedInvocation> subInvocations})
      : subInvocations = subInvocations.immutable;
  factory SorobanAuthorizedInvocation.fromStruct(Map<String, dynamic> json) {
    return SorobanAuthorizedInvocation(
        function: SorobanAuthorizedFunction.fromStruct(json.asMap("function")),
        subInvocations: json
            .asListOfMap("subInvocations")!
            .map((e) => SorobanAuthorizedInvocation.fromStruct(e))
            .toList());
  }
  static Layout _selfVector({String? property}) {
    return LayoutConst.xdrVec(SorobanAuthorizedInvocation.layout(),
        property: property);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyStruct([
      const LazyLayout(
          layout: SorobanAuthorizedFunction.layout, property: "function"),
      const LazyLayout(layout: _selfVector, property: "subInvocations")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "function": function.toVariantLayoutStruct(),
      "subInvocations": subInvocations.map((e) => e.toLayoutStruct()).toList()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "function": function.toJson(),
      "subInvocations": subInvocations.map((e) => e.toJson()).toList()
    };
  }
}

class SorobanAuthorizationEntry extends XDRSerialization {
  final SorobanCredentials credentials;
  final SorobanAuthorizedInvocation rootInvocation;
  const SorobanAuthorizationEntry(
      {required this.credentials, required this.rootInvocation});
  factory SorobanAuthorizationEntry.fromXdr(List<int> bytes,
      {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return SorobanAuthorizationEntry.fromStruct(decode);
  }
  factory SorobanAuthorizationEntry.fromStruct(Map<String, dynamic> json) {
    return SorobanAuthorizationEntry(
        credentials: SorobanCredentials.fromStruct(json.asMap("credentials")),
        rootInvocation: SorobanAuthorizedInvocation.fromStruct(
            json.asMap("rootInvocation")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      SorobanCredentials.layout(property: "credentials"),
      SorobanAuthorizedInvocation.layout(property: "rootInvocation")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "rootInvocation": rootInvocation.toLayoutStruct(),
      "credentials": credentials.toVariantLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "rootInvocation": rootInvocation.toJson(),
      "credentials": credentials.toJson()
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
    authorizedToMaintainLiabilitiesFlag
  ];
  @override
  String toString() {
    return "TrustLineFlag.$name";
  }

  static TrustLineFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse: () => throw DartStellarPlugingException(
          "TrustLineFlag not found.",
          details: {
            "flag": flag,
            "values": values.map((e) => e.name).join(", ")
          }),
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
    authorizedToMaintainLiabilities
  ];

  @override
  String toString() {
    return "TrustAuthFlag.$name";
  }

  static TrustAuthFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse: () => throw DartStellarPlugingException(
          "TrustAuthFlag not found.",
          details: {
            "flag": flag,
            "values": values.map((e) => e.name).join(", ")
          }),
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
  static const clawbackEnabledFlag =
      AuthFlag._(name: 'ClawbackEnabledFlag', value: 8);
  static const List<AuthFlag> values = [
    requiredFlag,
    revocableFlag,
    immutableFlag,
    clawbackEnabledFlag
  ];
  @override
  String toString() {
    return "AuthFlag.$name";
  }

  static AuthFlag fromValue(int? flag) {
    return values.firstWhere(
      (e) => e.value == flag,
      orElse: () => throw DartStellarPlugingException("AuthFlag not found.",
          details: {
            "flag": flag,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

class SorobanTransactionDataExt extends XDRVariantSerialization {
  final SorobanTransactionData? sorobanTransactionData;
  const SorobanTransactionDataExt({this.sorobanTransactionData});
  factory SorobanTransactionDataExt.fromXdr(List<int> bytes,
      {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
            sorobanTransactionData:
                SorobanTransactionData.fromStruct(decode.value));
      default:
        throw const DartStellarPlugingException(
            "Invalid SorobanTransactionData extension.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ExtensionPointType.extVoid.value,
          layout: LayoutConst.noArgs,
          property: ExtensionPointType.extVoid.name),
      LazyVariantModel(
          index: ExtensionPointType.extArgs1.value,
          layout: SorobanTransactionData.layout,
          property: ExtensionPointType.extArgs1.name)
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
    return {"sorobanTransactionData": sorobanTransactionData?.toJson()};
  }
}

class ExtensionPointType {
  final String name;
  final int value;
  const ExtensionPointType._({required this.name, required this.value});
  static const ExtensionPointType extVoid =
      ExtensionPointType._(name: "extVoid", value: 0);
  static const ExtensionPointType extArgs1 =
      ExtensionPointType._(name: "extArgs1", value: 1);
  static const ExtensionPointType extArgs2 =
      ExtensionPointType._(name: "extArgs2", value: 2);
  static const ExtensionPointType extArgs3 =
      ExtensionPointType._(name: "extArgs3", value: 2);
  static const List<ExtensionPointType> values = [
    extVoid,
    extArgs1,
    extArgs2,
    extArgs3
  ];
  static ExtensionPointType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("Asset type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
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

  StellarTransactionV1(
      {required this.sourceAccount,
      required int fee,
      required BigInt seqNum,
      this.cond = const PrecondNone(),
      this.memo = const StellarMemoNone(),
      List<Operation> operations = const [],
      this.sorobanData = const SorobanTransactionDataExt()})
      : operations = operations.immutable.max(
            StellarConst.maxTransactionOperationLength,
            name: "operations"),
        fee = fee.asUint32,
        seqNum = seqNum.asInt64,
        super(EnvelopeType.tx);

  factory StellarTransactionV1.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return StellarTransactionV1.fromStruct(decode);
  }
  factory StellarTransactionV1.fromStruct(Map<String, dynamic> json) {
    return StellarTransactionV1(
        sourceAccount: MuxedAccount.fromStruct(json.asMap("sourceAccount")),
        fee: json.as("fee"),
        seqNum: json.as("seqNum"),
        cond: Preconditions.fromStruct(json.asMap("cond")),
        memo: StellarMemo.fromStruct(json.asMap("memo")),
        operations: json
            .asListOfMap("operations")!
            .map((e) => Operation.fromStruct(e))
            .toList(),
        sorobanData:
            SorobanTransactionDataExt.fromStruct(json.asMap("sorobanData")));
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
      MuxedAccount.layout(property: "sourceAccount"),
      LayoutConst.u32be(property: "fee"),
      LayoutConst.s64be(property: "seqNum"),
      Preconditions.layout(property: "cond"),
      StellarMemo.layout(property: "memo"),
      LayoutConst.xdrVec(Operation.layout(), property: "operations"),
      SorobanTransactionDataExt.layout(property: "sorobanData")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sourceAccount": sourceAccount.toVariantLayoutStruct(),
      "fee": fee,
      "seqNum": seqNum,
      "cond": cond.toVariantLayoutStruct(),
      "memo": memo.toVariantLayoutStruct(),
      "operations": operations.map((e) => e.toLayoutStruct()).toList(),
      "sorobanData": sorobanData.toVariantLayoutStruct()
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

  StellarTransactionV0(
      {required this.sourceAccount,
      required int fee,
      required BigInt seqNum,
      this.timeBounds,
      this.memo = const StellarMemoNone(),
      List<Operation> operations = const [],
      this.ext = const ExtentionPointVoid()})
      : operations = operations.immutable.max(
            StellarConst.maxTransactionOperationLength,
            name: "operations"),
        fee = fee.asUint32,
        seqNum = seqNum.asInt64,
        super(EnvelopeType.txV0);

  factory StellarTransactionV0.fromStruct(Map<String, dynamic> json) {
    return StellarTransactionV0(
        sourceAccount:
            StellarPublicKey.fromPublicBytes(json.asBytes("sourceAccount")),
        fee: json.as("fee"),
        seqNum: json.as("seqNum"),
        timeBounds: json.mybeAs<TimeBounds, Map<String, dynamic>>(
            key: "timeBounds", onValue: (e) => TimeBounds.fromStruct(e)),
        memo: StellarMemo.fromStruct(json.asMap("memo")),
        operations: json
            .asListOfMap("operations")!
            .map((e) => Operation.fromStruct(e))
            .toList(),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "sourceAccount"),
      LayoutConst.u32be(property: "fee"),
      LayoutConst.s64be(property: "seqNum"),
      LayoutConst.optionalU32Be(TimeBounds.layout(), property: "timeBounds"),
      StellarMemo.layout(property: "memo"),
      LayoutConst.xdrVec(Operation.layout(), property: "operations"),
      ExtentionPointVoid.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sourceAccount": sourceAccount.toBytes(),
      "fee": fee,
      "seqNum": seqNum,
      "timeBounds": timeBounds?.toLayoutStruct(),
      "memo": memo.toVariantLayoutStruct(),
      "operations": operations.map((e) => e.toLayoutStruct()).toList(),
      "ext": ext.toVariantLayoutStruct()
    };
  }
}

class DecoratedSignature extends XDRSerialization {
  final List<int> hint;
  final List<int> signature;
  DecoratedSignature({required List<int> hint, required List<int> signature})
      : hint = hint.asImmutableBytes
            .exc(StellarConst.pubkeyHintBytesLength, name: "hint"),
        signature = signature.asImmutableBytes
            .max(StellarConst.ed25519SignatureLength, name: "signature");

  factory DecoratedSignature.fromStruct(Map<String, dynamic> json) {
    return DecoratedSignature(
      hint: json.asBytes("hint"),
      signature: json.asBytes("signature"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.pubkeyHintBytesLength,
          property: "hint"),
      LayoutConst.xdrVecBytes(property: "signature"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hint": hint, "signature": signature};
  }
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
  static const EnvelopeType poolRevokeOpId =
      EnvelopeType._('poolRevokeOpId', 7);
  static const EnvelopeType contractId = EnvelopeType._('contractId', 8);
  static const EnvelopeType sorobanAuthorization =
      EnvelopeType._('sorobanAuthorization', 9);

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
      orElse: () => throw DartStellarPlugingException(
          "Envelope type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "EnvelopeType.$name";
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
                  property: type.name);
            case EnvelopeType.txV0:
              return LazyVariantModel(
                  index: type.value,
                  layout: TransactionV0Envelope.layout,
                  property: type.name);
            case EnvelopeType.tx:
              return LazyVariantModel(
                  index: type.value,
                  layout: TransactionV1Envelope.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ({property}) => throw DartStellarPlugingException(
                      "Envlop type does not supported.",
                      details: {"type": type.name, "property": property}),
                  property: type.name);
          }
        }),
        property: property);
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
        throw DartStellarPlugingException("Envelope does not supported.",
            details: {"type": type.name});
    }
    if (envlope is! Envelope<T>) {
      throw DartStellarPlugingException("Envelope casting failed.", details: {
        "excepted": "Envelope<$T>",
        "envelope": envlope.runtimeType.toString()
      });
    }
    return envlope;
  }
  factory Envelope.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
      throw DartStellarPlugingException("Incorrect Envelope casting.",
          details: {"excepted": "$T", "type": "$runtimeType"});
    }
    return this as E;
  }
}

class TransactionV0Envelope extends Envelope<StellarTransactionV0> {
  @override
  final StellarTransactionV0 tx;
  @override
  final List<DecoratedSignature> signatures;
  TransactionV0Envelope(
      {required this.tx, required List<DecoratedSignature> signatures})
      : signatures = signatures.immutable
            .max(StellarConst.envlopSignaturesLength, name: "signatures"),
        super(EnvelopeType.txV0);

  factory TransactionV0Envelope.fromStruct(Map<String, dynamic> json) {
    return TransactionV0Envelope(
      tx: StellarTransactionV0.fromStruct(json.asMap("tx")),
      signatures: json
          .asListOfMap("signatures")!
          .map((e) => DecoratedSignature.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarTransactionV0.layout(property: "tx"),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: "signatures"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "tx": tx.toLayoutStruct(),
      "signatures": signatures.map((e) => e.toLayoutStruct()).toList()
    };
  }

  @override
  TransactionV0Envelope copyWith(
      {StellarTransactionV0? tx, List<DecoratedSignature>? signatures}) {
    return TransactionV0Envelope(
        tx: tx ?? this.tx, signatures: signatures ?? this.signatures);
  }
}

class TransactionV1Envelope extends Envelope<StellarTransactionV1> {
  @override
  final StellarTransactionV1 tx;
  @override
  final List<DecoratedSignature> signatures;
  TransactionV1Envelope(
      {required this.tx, required List<DecoratedSignature> signatures})
      : signatures = signatures.immutable
            .max(StellarConst.envlopSignaturesLength, name: "signatures"),
        super(EnvelopeType.tx);
  factory TransactionV1Envelope.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return TransactionV1Envelope.fromStruct(decode);
  }
  factory TransactionV1Envelope.fromStruct(Map<String, dynamic> json) {
    return TransactionV1Envelope(
      tx: StellarTransactionV1.fromStruct(json.asMap("tx")),
      signatures: json
          .asListOfMap("signatures")!
          .map((e) => DecoratedSignature.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarTransactionV1.layout(property: "tx"),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: "signatures"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "tx": tx.toLayoutStruct(),
      "signatures": signatures.map((e) => e.toLayoutStruct()).toList()
    };
  }

  @override
  TransactionV1Envelope copyWith(
      {StellarTransactionV1? tx, List<DecoratedSignature>? signatures}) {
    return TransactionV1Envelope(
        tx: tx ?? this.tx, signatures: signatures ?? this.signatures);
  }
}

class StellarFeeBumpTransaction extends StellarTransaction {
  final MuxedAccount feeSource;
  final BigInt fee;
  final TransactionV1Envelope innerTx;
  final ExtentionPointVoid ext;
  StellarFeeBumpTransaction(
      {required this.feeSource,
      required BigInt fee,
      required this.innerTx,
      this.ext = const ExtentionPointVoid()})
      : fee = fee.asInt64,
        super(EnvelopeType.txFeeBump);
  factory StellarFeeBumpTransaction.fromStruct(Map<String, dynamic> json) {
    return StellarFeeBumpTransaction(
        feeSource: MuxedAccount.fromStruct(json.asMap("feeSource")),
        fee: json.as("fee"),
        innerTx: Envelope.fromStruct(json.asMap("innerTx")).cast(),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedAccount.layout(property: "feeSource"),
      LayoutConst.s64be(property: "fee"),
      Envelope.layout(property: "innerTx"),
      ExtentionPointVoid.layout(property: "ext")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "feeSource": feeSource.toVariantLayoutStruct(),
      "fee": fee,
      "innerTx": innerTx.toVariantLayoutStruct(),
      "ext": ext.toVariantLayoutStruct()
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
  FeeBumpTransactionEnvelope(
      {required this.tx, required List<DecoratedSignature> signatures})
      : signatures = signatures.immutable
            .max(StellarConst.envlopSignaturesLength, name: "signatures"),
        super(EnvelopeType.txFeeBump);

  factory FeeBumpTransactionEnvelope.fromStruct(Map<String, dynamic> json) {
    return FeeBumpTransactionEnvelope(
      tx: StellarFeeBumpTransaction.fromStruct(json.asMap("tx")),
      signatures: json
          .asListOfMap("signatures")!
          .map((e) => DecoratedSignature.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarFeeBumpTransaction.layout(property: "tx"),
      LayoutConst.xdrVec(DecoratedSignature.layout(), property: "signatures"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "tx": tx.toLayoutStruct(),
      "signatures": signatures.map((e) => e.toLayoutStruct()).toList()
    };
  }

  @override
  FeeBumpTransactionEnvelope copyWith(
      {StellarFeeBumpTransaction? tx, List<DecoratedSignature>? signatures}) {
    return FeeBumpTransactionEnvelope(
        tx: tx ?? this.tx, signatures: signatures ?? this.signatures);
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
        bytes: bytes, layout: layout(property: property));
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
                  property: type.name);
            case EnvelopeType.tx:
              return LazyVariantModel(
                  index: type.value,
                  layout: StellarTransactionV1.layout,
                  property: type.name);
            case EnvelopeType.txV0:
              return LazyVariantModel(
                  index: type.value,
                  layout: StellarTransactionV0.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ({property}) => throw DartStellarPlugingException(
                      "Transaction type does not supported.",
                      details: {"type": type.name, "property": property}),
                  property: type.name);
          }
        }),
        property: property);
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
        throw DartStellarPlugingException(
            "Transaction type does not supported.",
            details: {"type": type.name});
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
      throw DartStellarPlugingException("Incorrect StellarTransaction casting.",
          details: {"excepted": "$T", "type": "$runtimeType"});
    }
    return this as T;
  }
}

class TransactionSignaturePayload extends XDRSerialization {
  final List<int> networkId;
  final StellarTransaction taggedTransaction;
  TransactionSignaturePayload({
    required List<int> networkId,
    required this.taggedTransaction,
  }) : networkId = networkId.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "networkId");
  factory TransactionSignaturePayload.fromXdr(List<int> bytes,
      {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return TransactionSignaturePayload.fromStruct(decode);
  }
  factory TransactionSignaturePayload.fromStruct(Map<String, dynamic> json) {
    return TransactionSignaturePayload(
        networkId: json.asBytes("networkId"),
        taggedTransaction:
            StellarTransaction.fromStruct(json.asMap("taggedTransaction")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "networkId"),
      StellarTransaction.layout(property: "taggedTransaction"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "networkId": networkId,
      "taggedTransaction": taggedTransaction.toVariantLayoutStruct()
    };
  }

  List<int> txHash() {
    return QuickCrypto.sha256Hash(toXDR());
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
      orElse: () => throw DartStellarPlugingException("Asset type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "MemoType.$name";
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
        throw DartStellarPlugingException("Invalid Memo type.",
            details: {"type": type.name});
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: MemoType.none.value,
          layout: StellarMemoNone.layout,
          property: MemoType.none.name),
      LazyVariantModel(
          index: MemoType.text.value,
          layout: StellarMemoText.layout,
          property: MemoType.text.name),
      LazyVariantModel(
          index: MemoType.id.value,
          layout: StellarMemoID.layout,
          property: MemoType.id.name),
      LazyVariantModel(
          index: MemoType.hash.value,
          layout: StellarMemoHash.layout,
          property: MemoType.hash.name),
      LazyVariantModel(
          index: MemoType.returnHash.value,
          layout: StellarMemoReturnHash.layout,
          property: MemoType.returnHash.name),
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
      throw DartStellarPlugingException("Stellar Memo Casting failed.",
          details: {"excepted": "$T", "type": runtimeType.toString()});
    }
    return this as T;
  }
}

class StellarMemoReturnHash extends StellarMemo {
  final List<int> hash;
  StellarMemoReturnHash(List<int> hash)
      : hash = hash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "StellarMemoReturnHash"),
        super(type: MemoType.returnHash);
  factory StellarMemoReturnHash.fromStruct(Map<String, dynamic> json) {
    return StellarMemoReturnHash(json.asBytes("hash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hash": hash};
  }
}

class StellarMemoHash extends StellarMemo {
  final List<int> hash;
  StellarMemoHash(List<int> hash)
      : hash = hash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "StellarMemoHash"),
        super(type: MemoType.hash);
  factory StellarMemoHash.fromStruct(Map<String, dynamic> json) {
    return StellarMemoHash(json.asBytes("hash"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "hash"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hash": hash};
  }
}

class StellarMemoID extends StellarMemo {
  final BigInt id;
  StellarMemoID(BigInt id)
      : id = id.asUint64,
        super(type: MemoType.id);
  factory StellarMemoID.fromStruct(Map<String, dynamic> json) {
    return StellarMemoID(json.as("id"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u64be(property: "id"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"id": id};
  }
}

class StellarMemoText extends StellarMemo {
  final String text;
  StellarMemoText(String text)
      : text = text.max(28),
        super(type: MemoType.text);

  factory StellarMemoText.fromStruct(Map<String, dynamic> json) {
    return StellarMemoText(json.as("text"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: "text"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"text": text};
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

  static const SignerKeyType ed25519 =
      SignerKeyType._(name: 'ed25519', value: 0);
  static const SignerKeyType preAuthTx =
      SignerKeyType._(name: 'preAuthTx', value: 1);
  static const SignerKeyType hashX = SignerKeyType._(name: 'hashX', value: 2);
  static const SignerKeyType ed25519SignedPayload =
      SignerKeyType._(name: 'ed25519SignedPayload', value: 3);
  static const List<SignerKeyType> values = [
    ed25519,
    preAuthTx,
    hashX,
    ed25519SignedPayload
  ];
  static SignerKeyType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "SignerKey type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "SignerKeyType.$name";
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
        throw UnimplementedError("Invalid SignerKeyType.");
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
                  property: type.name);
            case SignerKeyType.hashX:
              return LazyVariantModel(
                  index: type.value,
                  layout: SignerKeyHashX.layout,
                  property: type.name);
            case SignerKeyType.preAuthTx:
              return LazyVariantModel(
                  index: type.value,
                  layout: SignerKeyPreAuthTx.layout,
                  property: type.name);
            case SignerKeyType.ed25519SignedPayload:
              return LazyVariantModel(
                  index: type.value,
                  layout: SignerKeyEd25519.layout,
                  property: type.name);
            default:
              throw UnimplementedError("Invalid SignerKeyType.");
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class SignerKeyEd25519SignedPayload extends SignerKey {
  final List<int> ed25519;
  final List<int> payload;
  SignerKeyEd25519SignedPayload(
      {required List<int> ed25519, required List<int> payload})
      : ed25519 = ed25519.asImmutableBytes
            .exc(StellarConst.ed25519PubKeyLength, name: "ed25519"),
        payload = payload.asImmutableBytes
            .max(StellarConst.payloadLength, name: "payload"),
        super(type: SignerKeyType.ed25519SignedPayload);

  factory SignerKeyEd25519SignedPayload.fromStruct(Map<String, dynamic> json) {
    return SignerKeyEd25519SignedPayload(
        ed25519: json.asBytes("ed25519"), payload: json.asBytes("payload"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "ed25519"),
      LayoutConst.xdrVecBytes(property: "payload"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ed25519": ed25519, "payload": payload};
  }
}

class SignerKeyEd25519 extends SignerKey {
  final List<int> ed25519;
  SignerKeyEd25519(List<int> ed25519)
      : ed25519 = ed25519.asImmutableBytes
            .exc(StellarConst.ed25519PubKeyLength, name: "ed25519"),
        super(type: SignerKeyType.ed25519);

  factory SignerKeyEd25519.fromStruct(Map<String, dynamic> json) {
    return SignerKeyEd25519(json.asBytes("ed25519"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "ed25519")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ed25519": ed25519};
  }
}

class SignerKeyPreAuthTx extends SignerKey {
  final List<int> preAuthTx;
  SignerKeyPreAuthTx(List<int> preAuthTx)
      : preAuthTx = preAuthTx.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "preAuthTx"),
        super(type: SignerKeyType.preAuthTx);

  factory SignerKeyPreAuthTx.fromStruct(Map<String, dynamic> json) {
    return SignerKeyPreAuthTx(json.asBytes("preAuthTx"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "preAuthTx")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"preAuthTx": preAuthTx};
  }
}

class SignerKeyHashX extends SignerKey {
  final List<int> hashX;
  SignerKeyHashX(List<int> hashX)
      : hashX = hashX.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "KeyHashX"),
        super(type: SignerKeyType.hashX);

  factory SignerKeyHashX.fromStruct(Map<String, dynamic> json) {
    return SignerKeyHashX(json.asBytes("hashX"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "hashX")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"hashX": hashX};
  }
}

class Signer extends XDRSerialization {
  final SignerKey key;
  final int weight;
  Signer({required this.key, required int weight}) : weight = weight.asUint32;
  factory Signer.fromStruct(Map<String, dynamic> json) {
    return Signer(
        key: SignerKey.fromStruct(json.asMap("key")),
        weight: json.as("weight"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      SignerKey.layout(property: "key"),
      LayoutConst.u32be(property: "weight")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"key": key.toVariantLayoutStruct(), "weight": weight};
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

  static const AssetType native = AssetType._(value: 0, name: "Native");
  static const AssetType creditAlphanum4 =
      AssetType._(name: "CreditAlphanum4", value: 1);
  static const AssetType creditAlphanum12 =
      AssetType._(value: 2, name: "CreditAlphanum12");
  static const AssetType poolShare = AssetType._(value: 3, name: "PoolShare");

  static const List<AssetType> values = [
    native,
    creditAlphanum4,
    creditAlphanum12,
    poolShare
  ];
  bool get isNative => this == native;

  @override
  String toString() {
    return "AssetType.$name";
  }

  static AssetType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("Asset type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
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
        throw const DartStellarPlugingException("Invalid AssetType.");
    }
  }
  factory StellarAsset.fromXdr(List<int> bytes, {String? property}) {
    final json = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
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
                  property: type.name);
            case AssetType.creditAlphanum12:
              return LazyVariantModel(
                  index: type.value,
                  layout: StellarAssetCreditAlphanum12.layout,
                  property: type.name);
            case AssetType.creditAlphanum4:
              return LazyVariantModel(
                  index: type.value,
                  layout: StellarAssetCreditAlphanum4.layout,
                  property: type.name);
            case AssetType.poolShare:
              return LazyVariantModel(
                  index: type.value,
                  layout: StellarAssetPoolShare.layout,
                  property: type.name);
            default:
              throw const DartStellarPlugingException("Invalid AssetType.");
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;

  T cast<T extends StellarAsset>() {
    if (this is! T) {
      throw DartStellarPlugingException("Stellar asset casting failed.",
          details: {"excepted": "$T", "asset": runtimeType.toString()});
    }
    return this as T;
  }
}

class StellarAssetCreditAlphanum4 extends StellarAsset {
  final StellarPublicKey issuer;
  final String code;
  StellarAssetCreditAlphanum4._({required this.issuer, required this.code})
      : super(type: AssetType.creditAlphanum4);
  factory StellarAssetCreditAlphanum4(
      {required StellarPublicKey issuer, required String code}) {
    return StellarAssetCreditAlphanum4._(
        issuer: issuer,
        code: StellarValidator.validateAssetCode(code,
            length: _StellarAssetConst.creditAlphanum4Length));
  }
  factory StellarAssetCreditAlphanum4.fromStruct(Map<String, dynamic> json) {
    final code = StellarHelper.toAssetsCode(json.asBytes("code"));
    return StellarAssetCreditAlphanum4(
        issuer: StellarPublicKey.fromStruct(json.asMap("issuer")), code: code);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(_StellarAssetConst.creditAlphanum4Length,
          property: "code"),
      StellarPublicKey.layout(property: "issuer"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "issuer": issuer.toLayoutStruct(),
      "code": StellarHelper.toAlphanumAssetCode(
          code: code, length: _StellarAssetConst.creditAlphanum4Length)
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {"issuer": issuer.toAddress().toString(), "name": code};
  }

  @override
  operator ==(other) {
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
  factory StellarAssetCreditAlphanum12(
      {required StellarPublicKey issuer, required String code}) {
    return StellarAssetCreditAlphanum12._(
        issuer: issuer,
        code: StellarValidator.validateAssetCode(code,
            length: _StellarAssetConst.creditAlphanum12Length));
  }
  factory StellarAssetCreditAlphanum12.fromStruct(Map<String, dynamic> json) {
    return StellarAssetCreditAlphanum12(
        issuer: StellarPublicKey.fromStruct(json.asMap("issuer")),
        code: StellarHelper.toAssetsCode(json.asBytes("code")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(_StellarAssetConst.creditAlphanum12Length,
          property: "code"),
      StellarPublicKey.layout(property: "issuer"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "issuer": issuer.toLayoutStruct(),
      "code": StellarHelper.toAlphanumAssetCode(
          code: code, length: _StellarAssetConst.creditAlphanum12Length)
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {"issuer": issuer.toAddress().toString(), "name": code};
  }

  @override
  operator ==(other) {
    if (other is! StellarAssetCreditAlphanum12) return false;
    return code == other.code && issuer == other.issuer;
  }

  @override
  int get hashCode => code.hashCode ^ issuer.hashCode ^ type.hashCode;
}

class StellarAssetNative extends StellarAsset {
  final String code = "XLM";
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
    return {"name": code};
  }

  @override
  operator ==(other) {
    if (other is! StellarAssetNative) return false;
    return true;
  }

  @override
  int get hashCode => code.hashCode ^ type.hashCode;
}

/// should not be used in some models
class StellarAssetPoolShare extends StellarAsset {
  final List<int> poolID;
  StellarAssetPoolShare(List<int> poolID)
      : poolID = poolID.asImmutableBytes
            .max(StellarConst.hash256Length, name: "poolID"),
        super(type: AssetType.poolShare);
  factory StellarAssetPoolShare.fromStruct(Map<String, dynamic> json) {
    return StellarAssetPoolShare(json.asBytes("poolId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "poolId")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"poolId": poolID};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"poolId": BytesUtils.toHexString(poolID, prefix: "0x")};
  }

  @override
  operator ==(other) {
    if (other is! StellarAssetPoolShare) return false;
    return BytesUtils.bytesEqual(poolID, other.poolID);
  }

  @override
  int get hashCode =>
      poolID.fold<int>(0, (p, c) => p ^ c).hashCode ^ type.hashCode;
}
