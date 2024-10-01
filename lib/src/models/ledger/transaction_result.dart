import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/keypair/crypto/public_key.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/models/operations/operation.dart';
import 'package:stellar_dart/src/serialization/serialization.dart';
import 'package:stellar_dart/src/utils/validator.dart';

class ClaimAtomType {
  static const ClaimAtomType claimAtomTypeV0 =
      ClaimAtomType._('CLAIM_ATOM_TYPE_V0', 0);

  static const ClaimAtomType claimAtomTypeOrderBook =
      ClaimAtomType._('CLAIM_ATOM_TYPE_ORDER_BOOK', 1);

  static const ClaimAtomType claimAtomTypeLiquidityPool =
      ClaimAtomType._('CLAIM_ATOM_TYPE_LIQUIDITY_POOL', 2);

  final String name;
  final int value;

  const ClaimAtomType._(this.name, this.value);

  static List<ClaimAtomType> get values => [
        claimAtomTypeV0,
        claimAtomTypeOrderBook,
        claimAtomTypeLiquidityPool,
      ];
  static ClaimAtomType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClaimAtom type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ClaimAtom extends XDRVariantSerialization {
  final ClaimAtomType type;
  const ClaimAtom(this.type);
  factory ClaimAtom.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ClaimAtomType.fromName(decode.variantName);
    switch (type) {
      case ClaimAtomType.claimAtomTypeV0:
        return ClaimOfferAtomV0.fromStruct(decode.value);
      case ClaimAtomType.claimAtomTypeOrderBook:
        return ClaimOfferAtom.fromStruct(decode.value);
      case ClaimAtomType.claimAtomTypeLiquidityPool:
        return ClaimLiquidityAtom.fromStruct(decode.value);
      default:
        throw DartStellarPlugingException("Invalid ClaimAtom type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be([
      LazyVariantModel(
          index: ClaimAtomType.claimAtomTypeV0.value,
          layout: ClaimOfferAtomV0.layout,
          property: ClaimAtomType.claimAtomTypeV0.name),
      LazyVariantModel(
          index: ClaimAtomType.claimAtomTypeOrderBook.value,
          layout: ClaimOfferAtom.layout,
          property: ClaimAtomType.claimAtomTypeOrderBook.name),
      LazyVariantModel(
          index: ClaimAtomType.claimAtomTypeLiquidityPool.value,
          layout: ClaimLiquidityAtom.layout,
          property: ClaimAtomType.claimAtomTypeLiquidityPool.name)
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ClaimOfferAtomV0 extends ClaimAtom {
  final List<int> sellerEd25519;
  final BigInt offerID;
  final StellarAsset assetSold;
  final BigInt amountSold;
  final StellarAsset assetBought;
  final BigInt amountBought;
  ClaimOfferAtomV0(
      {required List<int> sellerEd25519,
      required BigInt offerID,
      required this.assetSold,
      required BigInt amountSold,
      required this.assetBought,
      required BigInt amountBought})
      : sellerEd25519 = sellerEd25519.asImmutableBytes
            .exc(StellarConst.ed25519PubKeyLength, name: "sellerEd25519"),
        offerID = offerID.asInt64,
        amountSold = amountSold.asInt64,
        amountBought = amountBought.asInt64,
        super(ClaimAtomType.claimAtomTypeV0);

  factory ClaimOfferAtomV0.fromStruct(Map<String, dynamic> json) {
    return ClaimOfferAtomV0(
        sellerEd25519: json.asBytes("sellerEd25519"),
        offerID: json.as("offerID"),
        assetSold: StellarAsset.fromStruct(json.asMap("assetSold")),
        amountSold: json.as("amountSold"),
        assetBought: StellarAsset.fromStruct(json.asMap("assetBought")),
        amountBought: json.as("amountBought"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "sellerEd25519"),
      LayoutConst.s64be(property: "offerID"),
      StellarAsset.layout(property: "assetSold"),
      LayoutConst.s64be(property: "amountSold"),
      StellarAsset.layout(property: "assetBought"),
      LayoutConst.s64be(property: "amountBought"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sellerEd25519": sellerEd25519,
      "offerID": offerID,
      "assetSold": assetSold.toVariantLayoutStruct(),
      "amountSold": amountSold,
      "assetBought": assetBought.toVariantLayoutStruct(),
      "amountBought": amountBought
    };
  }
}

class ClaimOfferAtom extends ClaimAtom {
  final StellarPublicKey accountId;
  final BigInt offerID;
  final StellarAsset assetSold;
  final BigInt amountSold;
  final StellarAsset assetBought;
  final BigInt amountBought;
  ClaimOfferAtom(
      {required this.accountId,
      required BigInt offerID,
      required this.assetSold,
      required BigInt amountSold,
      required this.assetBought,
      required BigInt amountBought})
      : offerID = offerID.asInt64,
        amountSold = amountSold.asInt64,
        amountBought = amountBought.asInt64,
        super(ClaimAtomType.claimAtomTypeOrderBook);

  factory ClaimOfferAtom.fromStruct(Map<String, dynamic> json) {
    return ClaimOfferAtom(
        accountId: StellarPublicKey.fromStruct(json.asMap("accountId")),
        offerID: json.as("offerID"),
        assetSold: StellarAsset.fromStruct(json.asMap("assetSold")),
        amountSold: json.as("amountSold"),
        assetBought: StellarAsset.fromStruct(json.asMap("assetBought")),
        amountBought: json.as("amountBought"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "accountId"),
      LayoutConst.s64be(property: "offerID"),
      StellarAsset.layout(property: "assetSold"),
      LayoutConst.s64be(property: "amountSold"),
      StellarAsset.layout(property: "assetBought"),
      LayoutConst.s64be(property: "amountBought"),
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
      "offerID": offerID,
      "assetSold": assetSold.toVariantLayoutStruct(),
      "amountSold": amountSold,
      "assetBought": assetBought.toVariantLayoutStruct(),
      "amountBought": amountBought
    };
  }
}

class ClaimLiquidityAtom extends ClaimAtom {
  final List<int> liquidityPoolID;
  final StellarAsset assetSold;
  final BigInt amountSold;
  final StellarAsset assetBought;
  final BigInt amountBought;
  ClaimLiquidityAtom(
      {required List<int> liquidityPoolID,
      required this.assetSold,
      required BigInt amountSold,
      required this.assetBought,
      required BigInt amountBought})
      : liquidityPoolID = liquidityPoolID.asImmutableBytes
            .exc(StellarConst.ed25519PubKeyLength, name: "liquidityPoolID"),
        amountSold = amountSold.asInt64,
        amountBought = amountBought.asInt64,
        super(ClaimAtomType.claimAtomTypeLiquidityPool);

  factory ClaimLiquidityAtom.fromStruct(Map<String, dynamic> json) {
    return ClaimLiquidityAtom(
        liquidityPoolID: json.asBytes("liquidityPoolID"),
        assetSold: StellarAsset.fromStruct(json.asMap("assetSold")),
        amountSold: json.as("amountSold"),
        assetBought: StellarAsset.fromStruct(json.asMap("assetBought")),
        amountBought: json.as("amountBought"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.ed25519PubKeyLength,
          property: "liquidityPoolID"),
      StellarAsset.layout(property: "assetSold"),
      LayoutConst.s64be(property: "amountSold"),
      StellarAsset.layout(property: "assetBought"),
      LayoutConst.s64be(property: "amountBought"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "liquidityPoolID": liquidityPoolID,
      "assetSold": assetSold.toVariantLayoutStruct(),
      "amountSold": amountSold,
      "assetBought": assetBought.toVariantLayoutStruct(),
      "amountBought": amountBought
    };
  }
}

abstract class OperationInner extends XDRVariantSerialization {
  final OperationType type;
  const OperationInner(this.type);
}

class CreateAccountResultCode {
  static const CreateAccountResultCode createAccountSuccess =
      CreateAccountResultCode._('CREATE_ACCOUNT_SUCCESS', 0);

  static const CreateAccountResultCode createAccountMalformed =
      CreateAccountResultCode._('CREATE_ACCOUNT_MALFORMED', -1);

  static const CreateAccountResultCode createAccountUnderfunded =
      CreateAccountResultCode._('CREATE_ACCOUNT_UNDERFUNDED', -2);

  static const CreateAccountResultCode createAccountLowReserve =
      CreateAccountResultCode._('CREATE_ACCOUNT_LOW_RESERVE', -3);

  static const CreateAccountResultCode createAccountAlreadyExist =
      CreateAccountResultCode._('CREATE_ACCOUNT_ALREADY_EXIST', -4);

  final String name;
  final int value;

  const CreateAccountResultCode._(this.name, this.value);

  static List<CreateAccountResultCode> get values => [
        createAccountSuccess,
        createAccountMalformed,
        createAccountUnderfunded,
        createAccountLowReserve,
        createAccountAlreadyExist,
      ];
  static CreateAccountResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "CreateAccountResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class CreateAccountResult extends OperationInner {
  final CreateAccountResultCode code;
  const CreateAccountResult(this.code) : super(OperationType.createAccount);
  factory CreateAccountResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = CreateAccountResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return CreateAccountResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(CreateAccountResultCode.values.length, (index) {
          final type = CreateAccountResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreateAccountResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class CreateAccountResultVoid extends CreateAccountResult {
  CreateAccountResultVoid(CreateAccountResultCode code) : super(code);
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

class PaymentResultCode {
  static const PaymentResultCode paymentSuccess =
      PaymentResultCode._('PAYMENT_SUCCESS', 0);

  static const PaymentResultCode paymentMalformed =
      PaymentResultCode._('PAYMENT_MALFORMED', -1);

  static const PaymentResultCode paymentUnderfunded =
      PaymentResultCode._('PAYMENT_UNDERFUNDED', -2);

  static const PaymentResultCode paymentSrcNoTrust =
      PaymentResultCode._('PAYMENT_SRC_NO_TRUST', -3);

  static const PaymentResultCode paymentSrcNotAuthorized =
      PaymentResultCode._('PAYMENT_SRC_NOT_AUTHORIZED', -4);

  static const PaymentResultCode paymentNoDestination =
      PaymentResultCode._('PAYMENT_NO_DESTINATION', -5);

  static const PaymentResultCode paymentNoTrust =
      PaymentResultCode._('PAYMENT_NO_TRUST', -6);

  static const PaymentResultCode paymentNotAuthorized =
      PaymentResultCode._('PAYMENT_NOT_AUTHORIZED', -7);

  static const PaymentResultCode paymentLineFull =
      PaymentResultCode._('PAYMENT_LINE_FULL', -8);

  static const PaymentResultCode paymentNoIssuer =
      PaymentResultCode._('PAYMENT_NO_ISSUER', -9);

  final String name;
  final int value;

  const PaymentResultCode._(this.name, this.value);

  static List<PaymentResultCode> get values => [
        paymentSuccess,
        paymentMalformed,
        paymentUnderfunded,
        paymentSrcNoTrust,
        paymentSrcNotAuthorized,
        paymentNoDestination,
        paymentNoTrust,
        paymentNotAuthorized,
        paymentLineFull,
        paymentNoIssuer,
      ];
  static PaymentResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "PaymentResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class PaymentResult extends OperationInner {
  final PaymentResultCode code;
  const PaymentResult(this.code) : super(OperationType.payment);
  factory PaymentResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = PaymentResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return PaymentResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(PaymentResultCode.values.length, (index) {
          final type = PaymentResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: PaymentResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class PaymentResultVoid extends PaymentResult {
  PaymentResultVoid(PaymentResultCode code) : super(code);
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

class PathPaymentStrictReceiveResultCode {
  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveSuccess = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_SUCCESS', 0);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveMalformed = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_MALFORMED', -1);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveUnderfunded =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_UNDERFUNDED', -2);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveSrcNoTrust = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_SRC_NO_TRUST', -3);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveSrcNotAuthorized =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_SRC_NOT_AUTHORIZED', -4);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveNoDestination =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_NO_DESTINATION', -5);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveNoTrust = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_NO_TRUST', -6);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveNotAuthorized =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_NOT_AUTHORIZED', -7);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveLineFull = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_LINE_FULL', -8);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveNoIssuer = PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_NO_ISSUER', -9);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveTooFewOffers =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_TOO_FEW_OFFERS', -10);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveOfferCrossSelf =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_OFFER_CROSS_SELF', -11);

  static const PathPaymentStrictReceiveResultCode
      pathPaymentStrictReceiveOverSendMax =
      PathPaymentStrictReceiveResultCode._(
          'PATH_PAYMENT_STRICT_RECEIVE_OVER_SENDMAX', -12);

  final String name;
  final int value;

  const PathPaymentStrictReceiveResultCode._(this.name, this.value);

  static List<PathPaymentStrictReceiveResultCode> get values => [
        pathPaymentStrictReceiveSuccess,
        pathPaymentStrictReceiveMalformed,
        pathPaymentStrictReceiveUnderfunded,
        pathPaymentStrictReceiveSrcNoTrust,
        pathPaymentStrictReceiveSrcNotAuthorized,
        pathPaymentStrictReceiveNoDestination,
        pathPaymentStrictReceiveNoTrust,
        pathPaymentStrictReceiveNotAuthorized,
        pathPaymentStrictReceiveLineFull,
        pathPaymentStrictReceiveNoIssuer,
        pathPaymentStrictReceiveTooFewOffers,
        pathPaymentStrictReceiveOfferCrossSelf,
        pathPaymentStrictReceiveOverSendMax,
      ];
  static PathPaymentStrictReceiveResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AllowTrustResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class PathPaymentStrictReceiveResult extends OperationInner {
  final PathPaymentStrictReceiveResultCode code;
  const PathPaymentStrictReceiveResult(this.code)
      : super(OperationType.pathPaymentStrictReceive);
  factory PathPaymentStrictReceiveResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code =
        PathPaymentStrictReceiveResultCode.fromName(decode.variantName);
    switch (code) {
      case PathPaymentStrictReceiveResultCode.pathPaymentStrictReceiveSuccess:
        return PathPaymentStrictReceiveResultSuccesss.fromStruct(decode.value);
      case PathPaymentStrictReceiveResultCode.pathPaymentStrictReceiveNoIssuer:
        return PathPaymentStrictReceiveResultNoIssuer.fromStruct(decode.value);
      default:
        return PathPaymentStrictReceiveResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(PathPaymentStrictReceiveResultCode.values.length,
            (index) {
          final type =
              PathPaymentStrictReceiveResultCode.values.elementAt(index);
          switch (type) {
            case PathPaymentStrictReceiveResultCode
                  .pathPaymentStrictReceiveSuccess:
              return LazyVariantModel(
                  layout: PathPaymentStrictReceiveResultSuccesss.layout,
                  property: type.name,
                  index: type.value);
            case PathPaymentStrictReceiveResultCode
                  .pathPaymentStrictReceiveNoIssuer:
              return LazyVariantModel(
                  layout: PathPaymentStrictReceiveResultNoIssuer.layout,
                  property: type.name,
                  index: type.value);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: PathPaymentStrictReceiveResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class SimplePaymentResult extends XDRSerialization {
  final StellarPublicKey destination;
  final StellarAsset asset;
  final BigInt amount;
  SimplePaymentResult(
      {required this.destination, required this.asset, required BigInt amount})
      : amount = amount.asInt64;

  factory SimplePaymentResult.fromStruct(Map<String, dynamic> json) {
    return SimplePaymentResult(
      destination: StellarPublicKey.fromStruct(json.asMap("destination")),
      asset: StellarAsset.fromStruct(json.asMap("asset")),
      amount: json.as("amount"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "destination"),
      StellarAsset.layout(property: "asset"),
      LayoutConst.s64be(property: "amount"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "destination": destination.toLayoutStruct(),
      "asset": asset.toVariantLayoutStruct(),
      "amount": amount
    };
  }
}

class PathPaymentStrictReceiveResultSuccesss
    extends PathPaymentStrictReceiveResult {
  final List<ClaimAtom> offers;
  final SimplePaymentResult last;
  PathPaymentStrictReceiveResultSuccesss(
      {required List<ClaimAtom> offers, required this.last})
      : offers = offers.immutable,
        super(
            PathPaymentStrictReceiveResultCode.pathPaymentStrictReceiveSuccess);
  factory PathPaymentStrictReceiveResultSuccesss.fromStruct(
      Map<String, dynamic> json) {
    return PathPaymentStrictReceiveResultSuccesss(
        offers: json
            .asListOfMap("offers")!
            .map((e) => ClaimAtom.fromStruct(e))
            .toList(),
        last: SimplePaymentResult.fromStruct(json.asMap("last")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ClaimAtom.layout(), property: "offers"),
      SimplePaymentResult.layout(property: "last")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "offers": offers.map((e) => e.toVariantLayoutStruct()).toList(),
      "last": last.toLayoutStruct()
    };
  }
}

class PathPaymentStrictReceiveResultNoIssuer
    extends PathPaymentStrictReceiveResult {
  final StellarAsset noIssuer;

  PathPaymentStrictReceiveResultNoIssuer(this.noIssuer)
      : super(PathPaymentStrictReceiveResultCode
            .pathPaymentStrictReceiveNoIssuer);
  factory PathPaymentStrictReceiveResultNoIssuer.fromStruct(
      Map<String, dynamic> json) {
    return PathPaymentStrictReceiveResultNoIssuer(
        StellarAsset.fromStruct(json.asMap("noIssuer")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([StellarAsset.layout(property: "noIssuer")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"noIssuer": noIssuer.toVariantLayoutStruct()};
  }
}

class PathPaymentStrictReceiveResultVoid
    extends PathPaymentStrictReceiveResult {
  PathPaymentStrictReceiveResultVoid(PathPaymentStrictReceiveResultCode code)
      : super(code);
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

class OfferEntryResult extends XDRSerialization {
  final StellarPublicKey sellerID;
  final BigInt offerID;
  final StellarAsset selling;
  final StellarAsset buying;
  final BigInt amount;
  final int flags;
  final ExtentionPointVoid ext;

  OfferEntryResult(
      {required this.sellerID,
      required BigInt offerID,
      required this.selling,
      required this.buying,
      required BigInt amount,
      required int flags,
      this.ext = const ExtentionPointVoid()})
      : offerID = offerID.asInt64,
        amount = amount.asInt64,
        flags = flags.asUint32;
  factory OfferEntryResult.fromStruct(Map<String, dynamic> json) {
    return OfferEntryResult(
        sellerID: StellarPublicKey.fromStruct(json.asMap("sellerID")),
        amount: json.as("amount"),
        buying: StellarAsset.fromStruct(json.asMap("buying")),
        selling: StellarAsset.fromStruct(json.asMap("selling")),
        flags: json.as("flags"),
        offerID: json.as("offerID"),
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "sellerID"),
      LayoutConst.s64be(property: "offerID"),
      StellarAsset.layout(property: "selling"),
      StellarAsset.layout(property: "buying"),
      LayoutConst.s64be(property: "amount"),
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
      "ext": ext.toVariantLayoutStruct(),
      "flags": flags,
      "amount": amount,
      "buying": buying.toVariantLayoutStruct(),
      "selling": selling.toVariantLayoutStruct(),
      "offerID": offerID,
      "sellerID": sellerID.toLayoutStruct(),
    };
  }
}

class ManageOfferEffectType {
  static const ManageOfferEffectType manageOfferCreated =
      ManageOfferEffectType._('MANAGE_OFFER_CREATED', 0);

  static const ManageOfferEffectType manageOfferUpdated =
      ManageOfferEffectType._('MANAGE_OFFER_UPDATED', 1);

  static const ManageOfferEffectType manageOfferDeleted =
      ManageOfferEffectType._('MANAGE_OFFER_DELETED', 2);

  final String name;
  final int value;

  const ManageOfferEffectType._(this.name, this.value);

  static List<ManageOfferEffectType> get values => [
        manageOfferCreated,
        manageOfferUpdated,
        manageOfferDeleted,
      ];
  static ManageOfferEffectType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ManageOfferEffect type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ManageOfferEffect extends XDRVariantSerialization {
  final ManageOfferEffectType type;
  const ManageOfferEffect(this.type);
  factory ManageOfferEffect.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ManageOfferEffectType.fromName(decode.variantName);
    switch (type) {
      case ManageOfferEffectType.manageOfferCreated:
        return ManageOfferEffectCreated.fromStruct(decode.value);
      case ManageOfferEffectType.manageOfferDeleted:
        return ManageOfferEffectDeleted.fromStruct(decode.value);
      case ManageOfferEffectType.manageOfferUpdated:
        return ManageOfferEffectUpdated.fromStruct(decode.value);
      default:
        throw DartStellarPlugingException("Invalid ManageOfferEffect type.",
            details: {"type": type.name});
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
          index: ManageOfferEffectType.manageOfferCreated.value,
          layout: ManageOfferEffectCreated.layout,
          property: ManageOfferEffectType.manageOfferCreated.name),
      LazyVariantModel(
        index: ManageOfferEffectType.manageOfferDeleted.value,
        layout: ManageOfferEffectDeleted.layout,
        property: ManageOfferEffectType.manageOfferDeleted.name,
      ),
      LazyVariantModel(
        index: ManageOfferEffectType.manageOfferUpdated.value,
        layout: ManageOfferEffectUpdated.layout,
        property: ManageOfferEffectType.manageOfferUpdated.name,
      )
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => type.name;
}

class ManageOfferEffectCreated extends ManageOfferEffect {
  ManageOfferEffectCreated() : super(ManageOfferEffectType.manageOfferCreated);
  factory ManageOfferEffectCreated.fromStruct(Map<String, dynamic> json) {
    return ManageOfferEffectCreated();
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

class ManageOfferEffectUpdated extends ManageOfferEffect {
  final OfferEntryResult offerEntry;
  ManageOfferEffectUpdated(this.offerEntry)
      : super(ManageOfferEffectType.manageOfferUpdated);
  factory ManageOfferEffectUpdated.fromStruct(Map<String, dynamic> json) {
    return ManageOfferEffectUpdated(
        OfferEntryResult.fromStruct(json.asMap("offerEntry")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([OfferEntryResult.layout(property: "offerEntry")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"offerEntry": offerEntry.toLayoutStruct()};
  }
}

class ManageOfferEffectDeleted extends ManageOfferEffect {
  ManageOfferEffectDeleted() : super(ManageOfferEffectType.manageOfferDeleted);
  factory ManageOfferEffectDeleted.fromStruct(Map<String, dynamic> json) {
    return ManageOfferEffectDeleted();
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

class ManageSellOfferResultCode {
  static const ManageSellOfferResultCode manageSellOfferSuccess =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_SUCCESS', 0);

  static const ManageSellOfferResultCode manageSellOfferMalformed =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_MALFORMED', -1);

  static const ManageSellOfferResultCode manageSellOfferSellNoTrust =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_SELL_NO_TRUST', -2);

  static const ManageSellOfferResultCode manageSellOfferBuyNoTrust =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_BUY_NO_TRUST', -3);

  static const ManageSellOfferResultCode manageSellOfferSellNotAuthorized =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_SELL_NOT_AUTHORIZED', -4);

  static const ManageSellOfferResultCode manageSellOfferBuyNotAuthorized =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_BUY_NOT_AUTHORIZED', -5);

  static const ManageSellOfferResultCode manageSellOfferLineFull =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_LINE_FULL', -6);

  static const ManageSellOfferResultCode manageSellOfferUnderfunded =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_UNDERFUNDED', -7);

  static const ManageSellOfferResultCode manageSellOfferCrossSelf =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_CROSS_SELF', -8);

  static const ManageSellOfferResultCode manageSellOfferSellNoIssuer =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_SELL_NO_ISSUER', -9);

  static const ManageSellOfferResultCode manageSellOfferBuyNoIssuer =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_BUY_NO_ISSUER', -10);

  static const ManageSellOfferResultCode manageSellOfferNotFound =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_NOT_FOUND', -11);

  static const ManageSellOfferResultCode manageSellOfferLowReserve =
      ManageSellOfferResultCode._('MANAGE_SELL_OFFER_LOW_RESERVE', -12);

  final String name;
  final int value;

  const ManageSellOfferResultCode._(this.name, this.value);

  static List<ManageSellOfferResultCode> get values => [
        manageSellOfferSuccess,
        manageSellOfferMalformed,
        manageSellOfferSellNoTrust,
        manageSellOfferBuyNoTrust,
        manageSellOfferSellNotAuthorized,
        manageSellOfferBuyNotAuthorized,
        manageSellOfferLineFull,
        manageSellOfferUnderfunded,
        manageSellOfferCrossSelf,
        manageSellOfferSellNoIssuer,
        manageSellOfferBuyNoIssuer,
        manageSellOfferNotFound,
        manageSellOfferLowReserve,
      ];
  static ManageSellOfferResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AllowTrustResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ManageSellOfferResult extends OperationInner {
  final ManageSellOfferResultCode code;
  const ManageSellOfferResult(this.code) : super(OperationType.manageSellOffer);
  factory ManageSellOfferResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ManageSellOfferResultCode.fromName(decode.variantName);
    switch (code) {
      case ManageSellOfferResultCode.manageSellOfferSuccess:
        return ManageSellOfferResultSuccess.fromStruct(decode.value);
      default:
        return ManageSellOfferResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ManageSellOfferResultCode.values.length, (index) {
          final type = ManageSellOfferResultCode.values.elementAt(index);
          switch (type) {
            case ManageSellOfferResultCode.manageSellOfferSuccess:
              return LazyVariantModel(
                  layout: ManageSellOfferResultSuccess.layout,
                  property: type.name,
                  index: index);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ManageSellOfferResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ManageOfferSuccessResult extends XDRSerialization {
  final List<ClaimAtom> offersClaimed;
  final ManageOfferEffect offer;
  ManageOfferSuccessResult(
      {required List<ClaimAtom> offersClaimed, required this.offer})
      : offersClaimed = offersClaimed.immutable;
  factory ManageOfferSuccessResult.fromStruct(Map<String, dynamic> json) {
    return ManageOfferSuccessResult(
      offersClaimed: json
          .asListOfMap("offersClaimed")!
          .map((e) => ClaimAtom.fromStruct(e))
          .toList(),
      offer: ManageOfferEffect.fromStruct(json.asMap("offer")),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ClaimAtom.layout(), property: "offersClaimed"),
      ManageOfferEffect.layout(property: "offer")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "offersClaimed":
          offersClaimed.map((e) => e.toVariantLayoutStruct()).toList(),
      "offer": offer.toVariantLayoutStruct()
    };
  }
}

class ManageSellOfferResultSuccess extends ManageSellOfferResult {
  final ManageOfferSuccessResult success;
  ManageSellOfferResultSuccess(this.success)
      : super(ManageSellOfferResultCode.manageSellOfferSuccess);
  factory ManageSellOfferResultSuccess.fromStruct(Map<String, dynamic> json) {
    return ManageSellOfferResultSuccess(
        ManageOfferSuccessResult.fromStruct(json.asMap("success")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ManageOfferSuccessResult.layout(property: "success")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"success": success.toLayoutStruct()};
  }
}

class ManageSellOfferResultVoid extends ManageSellOfferResult {
  ManageSellOfferResultVoid(ManageSellOfferResultCode code) : super(code);
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

abstract class CreatePassiveSellOfferResult extends OperationInner {
  final ManageSellOfferResultCode code;
  const CreatePassiveSellOfferResult(this.code)
      : super(OperationType.createPassiveSellOffer);
  factory CreatePassiveSellOfferResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ManageSellOfferResultCode.fromName(decode.variantName);
    switch (code) {
      case ManageSellOfferResultCode.manageSellOfferSuccess:
        return CreatePassiveSellOfferResult.fromStruct(decode.value);
      default:
        return CreatePassiveSellOfferResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ManageSellOfferResultCode.values.length, (index) {
          final type = ManageSellOfferResultCode.values.elementAt(index);
          switch (type) {
            case ManageSellOfferResultCode.manageSellOfferSuccess:
              return LazyVariantModel(
                  layout: CreatePassiveSellOfferResultSuccess.layout,
                  property: type.name,
                  index: index);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreatePassiveSellOfferResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class CreatePassiveSellOfferResultSuccess extends CreatePassiveSellOfferResult {
  final ManageOfferSuccessResult success;
  CreatePassiveSellOfferResultSuccess(this.success)
      : super(ManageSellOfferResultCode.manageSellOfferSuccess);
  factory CreatePassiveSellOfferResultSuccess.fromStruct(
      Map<String, dynamic> json) {
    return CreatePassiveSellOfferResultSuccess(
        ManageOfferSuccessResult.fromStruct(json.asMap("success")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ManageOfferSuccessResult.layout(property: "success")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"success": success.toLayoutStruct()};
  }
}

class CreatePassiveSellOfferResultVoid extends CreatePassiveSellOfferResult {
  CreatePassiveSellOfferResultVoid(ManageSellOfferResultCode code)
      : super(code);
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

class SetOptionsResultCode {
  static const SetOptionsResultCode setOptionsSuccess =
      SetOptionsResultCode._('SET_OPTIONS_SUCCESS', 0);

  static const SetOptionsResultCode setOptionsLowReserve =
      SetOptionsResultCode._('SET_OPTIONS_LOW_RESERVE', -1);

  static const SetOptionsResultCode setOptionsTooManySigners =
      SetOptionsResultCode._('SET_OPTIONS_TOO_MANY_SIGNERS', -2);

  static const SetOptionsResultCode setOptionsBadFlags =
      SetOptionsResultCode._('SET_OPTIONS_BAD_FLAGS', -3);

  static const SetOptionsResultCode setOptionsInvalidInflation =
      SetOptionsResultCode._('SET_OPTIONS_INVALID_INFLATION', -4);

  static const SetOptionsResultCode setOptionsCantChange =
      SetOptionsResultCode._('SET_OPTIONS_CANT_CHANGE', -5);

  static const SetOptionsResultCode setOptionsUnknownFlag =
      SetOptionsResultCode._('SET_OPTIONS_UNKNOWN_FLAG', -6);

  static const SetOptionsResultCode setOptionsThresholdOutOfRange =
      SetOptionsResultCode._('SET_OPTIONS_THRESHOLD_OUT_OF_RANGE', -7);

  static const SetOptionsResultCode setOptionsBadSigner =
      SetOptionsResultCode._('SET_OPTIONS_BAD_SIGNER', -8);

  static const SetOptionsResultCode setOptionsInvalidHomeDomain =
      SetOptionsResultCode._('SET_OPTIONS_INVALID_HOME_DOMAIN', -9);

  static const SetOptionsResultCode setOptionsAuthRevocableRequired =
      SetOptionsResultCode._('SET_OPTIONS_AUTH_REVOCABLE_REQUIRED', -10);

  final String name;
  final int value;

  const SetOptionsResultCode._(this.name, this.value);

  static List<SetOptionsResultCode> get values => [
        setOptionsSuccess,
        setOptionsLowReserve,
        setOptionsTooManySigners,
        setOptionsBadFlags,
        setOptionsInvalidInflation,
        setOptionsCantChange,
        setOptionsUnknownFlag,
        setOptionsThresholdOutOfRange,
        setOptionsBadSigner,
        setOptionsInvalidHomeDomain,
        setOptionsAuthRevocableRequired,
      ];

  static SetOptionsResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AllowTrustResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class SetOptionsResult extends OperationInner {
  final SetOptionsResultCode code;
  const SetOptionsResult(this.code) : super(OperationType.setOptions);
  factory SetOptionsResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = SetOptionsResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return SetOptionsResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(SetOptionsResultCode.values.length, (index) {
          final type = SetOptionsResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: SetOptionsResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class SetOptionsResultVoid extends SetOptionsResult {
  SetOptionsResultVoid(SetOptionsResultCode code) : super(code);
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

class ChangeTrustResultCode {
  static const ChangeTrustResultCode changeTrustSuccess =
      ChangeTrustResultCode._('CHANGE_TRUST_SUCCESS', 0);

  static const ChangeTrustResultCode changeTrustMalformed =
      ChangeTrustResultCode._('CHANGE_TRUST_MALFORMED', -1);

  static const ChangeTrustResultCode changeTrustNoIssuer =
      ChangeTrustResultCode._('CHANGE_TRUST_NO_ISSUER', -2);

  static const ChangeTrustResultCode changeTrustInvalidLimit =
      ChangeTrustResultCode._('CHANGE_TRUST_INVALID_LIMIT', -3);

  static const ChangeTrustResultCode changeTrustLowReserve =
      ChangeTrustResultCode._('CHANGE_TRUST_LOW_RESERVE', -4);

  static const ChangeTrustResultCode changeTrustSelfNotAllowed =
      ChangeTrustResultCode._('CHANGE_TRUST_SELF_NOT_ALLOWED', -5);

  static const ChangeTrustResultCode changeTrustTrustLineMissing =
      ChangeTrustResultCode._('CHANGE_TRUST_TRUST_LINE_MISSING', -6);

  static const ChangeTrustResultCode changeTrustCannotDelete =
      ChangeTrustResultCode._('CHANGE_TRUST_CANNOT_DELETE', -7);

  static const ChangeTrustResultCode changeTrustNotAuthMaintainLiabilities =
      ChangeTrustResultCode._('CHANGE_TRUST_NOT_AUTH_MAINTAIN_LIABILITIES', -8);

  final String name;
  final int value;

  const ChangeTrustResultCode._(this.name, this.value);

  static List<ChangeTrustResultCode> get values => [
        changeTrustSuccess,
        changeTrustMalformed,
        changeTrustNoIssuer,
        changeTrustInvalidLimit,
        changeTrustLowReserve,
        changeTrustSelfNotAllowed,
        changeTrustTrustLineMissing,
        changeTrustCannotDelete,
        changeTrustNotAuthMaintainLiabilities,
      ];
  static ChangeTrustResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AllowTrustResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ChangeTrustResult extends OperationInner {
  final ChangeTrustResultCode code;
  const ChangeTrustResult(this.code) : super(OperationType.changeTrust);
  factory ChangeTrustResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ChangeTrustResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ChangeTrustResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ChangeTrustResultCode.values.length, (index) {
          final type = ChangeTrustResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ChangeTrustResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ChangeTrustResultVoid extends ChangeTrustResult {
  ChangeTrustResultVoid(ChangeTrustResultCode code) : super(code);
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

class AllowTrustResultCode {
  static const AllowTrustResultCode allowTrustSuccess =
      AllowTrustResultCode._('ALLOW_TRUST_SUCCESS', 0);

  static const AllowTrustResultCode allowTrustMalformed =
      AllowTrustResultCode._('ALLOW_TRUST_MALFORMED', -1);

  static const AllowTrustResultCode allowTrustNoTrustLine =
      AllowTrustResultCode._('ALLOW_TRUST_NO_TRUST_LINE', -2);

  static const AllowTrustResultCode allowTrustTrustNotRequired =
      AllowTrustResultCode._('ALLOW_TRUST_TRUST_NOT_REQUIRED', -3);

  static const AllowTrustResultCode allowTrustCantRevoke =
      AllowTrustResultCode._('ALLOW_TRUST_CANT_REVOKE', -4);

  static const AllowTrustResultCode allowTrustSelfNotAllowed =
      AllowTrustResultCode._('ALLOW_TRUST_SELF_NOT_ALLOWED', -5);

  static const AllowTrustResultCode allowTrustLowReserve =
      AllowTrustResultCode._('ALLOW_TRUST_LOW_RESERVE', -6);

  final String name;
  final int value;

  const AllowTrustResultCode._(this.name, this.value);

  static List<AllowTrustResultCode> get values => [
        allowTrustSuccess,
        allowTrustMalformed,
        allowTrustNoTrustLine,
        allowTrustTrustNotRequired,
        allowTrustCantRevoke,
        allowTrustSelfNotAllowed,
        allowTrustLowReserve,
      ];
  static AllowTrustResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AllowTrustResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class AllowTrustResult extends OperationInner {
  final AllowTrustResultCode code;
  const AllowTrustResult(this.code) : super(OperationType.allowTrust);
  factory AllowTrustResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = AllowTrustResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return AllowTrustResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(AllowTrustResultCode.values.length, (index) {
          final type = AllowTrustResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: AllowTrustResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class AllowTrustResultVoid extends AllowTrustResult {
  AllowTrustResultVoid(AllowTrustResultCode code) : super(code);
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

class AccountMergeResultCode {
  static const AccountMergeResultCode accountMergeSuccess =
      AccountMergeResultCode._('ACCOUNT_MERGE_SUCCESS', 0);

  static const AccountMergeResultCode accountMergeMalformed =
      AccountMergeResultCode._('ACCOUNT_MERGE_MALFORMED', -1);

  static const AccountMergeResultCode accountMergeNoAccount =
      AccountMergeResultCode._('ACCOUNT_MERGE_NO_ACCOUNT', -2);

  static const AccountMergeResultCode accountMergeImmutableSet =
      AccountMergeResultCode._('ACCOUNT_MERGE_IMMUTABLE_SET', -3);

  static const AccountMergeResultCode accountMergeHasSubEntries =
      AccountMergeResultCode._('ACCOUNT_MERGE_HAS_SUB_ENTRIES', -4);

  static const AccountMergeResultCode accountMergeSeqnumTooFar =
      AccountMergeResultCode._('ACCOUNT_MERGE_SEQNUM_TOO_FAR', -5);

  static const AccountMergeResultCode accountMergeDestFull =
      AccountMergeResultCode._('ACCOUNT_MERGE_DEST_FULL', -6);

  static const AccountMergeResultCode accountMergeIsSponsor =
      AccountMergeResultCode._('ACCOUNT_MERGE_IS_SPONSOR', -7);

  final String name;
  final int value;

  const AccountMergeResultCode._(this.name, this.value);

  static List<AccountMergeResultCode> get values => [
        accountMergeSuccess,
        accountMergeMalformed,
        accountMergeNoAccount,
        accountMergeImmutableSet,
        accountMergeHasSubEntries,
        accountMergeSeqnumTooFar,
        accountMergeDestFull,
        accountMergeIsSponsor,
      ];
  static AccountMergeResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "AccountMergeResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class AccountMergeResult extends OperationInner {
  final AccountMergeResultCode code;
  const AccountMergeResult(this.code) : super(OperationType.accountMerge);
  factory AccountMergeResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = AccountMergeResultCode.fromName(decode.variantName);
    switch (code) {
      case AccountMergeResultCode.accountMergeSuccess:
        return AccountMergeResultSuccess.fromStruct(decode.value);
      default:
        return AccountMergeResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(AccountMergeResultCode.values.length, (index) {
          final type = AccountMergeResultCode.values.elementAt(index);
          switch (type) {
            case AccountMergeResultCode.accountMergeSuccess:
              return LazyVariantModel(
                layout: AccountMergeResultSuccess.layout,
                property: type.name,
                index: type.value,
              );
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: AccountMergeResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class AccountMergeResultVoid extends AccountMergeResult {
  AccountMergeResultVoid(AccountMergeResultCode code) : super(code);
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

class AccountMergeResultSuccess extends AccountMergeResult {
  final BigInt sourceAccountBalance;
  AccountMergeResultSuccess(BigInt sourceAccountBalance)
      : sourceAccountBalance = sourceAccountBalance.asInt64,
        super(AccountMergeResultCode.accountMergeSuccess);
  factory AccountMergeResultSuccess.fromStruct(Map<String, dynamic> json) {
    return AccountMergeResultSuccess(json.as("sourceAccountBalance"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.s64be(property: "sourceAccountBalance")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"sourceAccountBalance": sourceAccountBalance};
  }
}

class InflationResultCode {
  static const InflationResultCode inflationSuccess =
      InflationResultCode._('INFLATION_SUCCESS', 0);

  static const InflationResultCode inflationNotTime =
      InflationResultCode._('INFLATION_NOT_TIME', -1);

  final String name;
  final int value;

  const InflationResultCode._(this.name, this.value);

  static List<InflationResultCode> get values => [
        inflationSuccess,
        inflationNotTime,
      ];
  static InflationResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "InflationResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class InflationResult extends OperationInner {
  final InflationResultCode code;
  const InflationResult(this.code) : super(OperationType.inflation);
  factory InflationResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = InflationResultCode.fromName(decode.variantName);
    switch (code) {
      case InflationResultCode.inflationSuccess:
        return InflationResultSuccess.fromStruct(decode.value);
      default:
        return InflationResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(InflationResultCode.values.length, (index) {
          final type = InflationResultCode.values.elementAt(index);
          switch (type) {
            case InflationResultCode.inflationSuccess:
              return LazyVariantModel(
                  index: type.value,
                  layout: InflationResultSuccess.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: InflationResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class InflationPayout extends XDRSerialization {
  final StellarPublicKey destination;
  final BigInt amount;
  InflationPayout({required this.destination, required BigInt amount})
      : amount = amount.asInt64;
  factory InflationPayout.fromStruct(Map<String, dynamic> json) {
    return InflationPayout(
        destination: StellarPublicKey.fromStruct(json.asMap("destination")),
        amount: json.as("amount"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "destination"),
      LayoutConst.s64be(property: "amount")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"destination": destination.toLayoutStruct(), "amount": amount};
  }
}

class InflationResultVoid extends InflationResult {
  InflationResultVoid(InflationResultCode code) : super(code);
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

class InflationResultSuccess extends InflationResult {
  final List<InflationPayout> payouts;
  InflationResultSuccess(List<InflationPayout> payouts)
      : payouts = payouts.immutable,
        super(InflationResultCode.inflationSuccess);
  factory InflationResultSuccess.fromStruct(Map<String, dynamic> json) {
    return InflationResultSuccess(json
        .asListOfMap("payouts")!
        .map((e) => InflationPayout.fromStruct(e))
        .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [LayoutConst.xdrVec(InflationPayout.layout(), property: "payouts")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"payouts": payouts.map((e) => e.toLayoutStruct()).toList()};
  }
}

class ManageDataResultCode {
  static const ManageDataResultCode manageDataSuccess =
      ManageDataResultCode._('MANAGE_DATA_SUCCESS', 0);

  static const ManageDataResultCode manageDataNotSupportedYet =
      ManageDataResultCode._('MANAGE_DATA_NOT_SUPPORTED_YET', -1);

  static const ManageDataResultCode manageDataNameNotFound =
      ManageDataResultCode._('MANAGE_DATA_NAME_NOT_FOUND', -2);

  static const ManageDataResultCode manageDataLowReserve =
      ManageDataResultCode._('MANAGE_DATA_LOW_RESERVE', -3);

  static const ManageDataResultCode manageDataInvalidName =
      ManageDataResultCode._('MANAGE_DATA_INVALID_NAME', -4);

  final String name;
  final int value;

  const ManageDataResultCode._(this.name, this.value);

  static List<ManageDataResultCode> get values => [
        manageDataSuccess,
        manageDataNotSupportedYet,
        manageDataNameNotFound,
        manageDataLowReserve,
        manageDataInvalidName,
      ];
  static ManageDataResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "BumpSequenceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ManageDataResult extends OperationInner {
  final ManageDataResultCode code;
  const ManageDataResult(this.code) : super(OperationType.manageData);
  factory ManageDataResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ManageDataResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ManageDataResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ManageDataResultCode.values.length, (index) {
          final type = ManageDataResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ManageDataResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ManageDataResultVoid extends ManageDataResult {
  ManageDataResultVoid(ManageDataResultCode code) : super(code);
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

class BumpSequenceResultCode {
  static const BumpSequenceResultCode bumpSequenceSuccess =
      BumpSequenceResultCode._('BUMP_SEQUENCE_SUCCESS', 0);

  static const BumpSequenceResultCode bumpSequenceBadSeq =
      BumpSequenceResultCode._('BUMP_SEQUENCE_BAD_SEQ', -1);

  final String name;
  final int value;

  const BumpSequenceResultCode._(this.name, this.value);

  static List<BumpSequenceResultCode> get values => [
        bumpSequenceSuccess,
        bumpSequenceBadSeq,
      ];
  static BumpSequenceResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "BumpSequenceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class BumpSequenceResult extends OperationInner {
  final BumpSequenceResultCode code;
  const BumpSequenceResult(this.code) : super(OperationType.bumpSequence);
  factory BumpSequenceResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = BumpSequenceResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return BumpSequenceResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(BumpSequenceResultCode.values.length, (index) {
          final type = BumpSequenceResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: BumpSequenceResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class BumpSequenceResultVoid extends BumpSequenceResult {
  BumpSequenceResultVoid(BumpSequenceResultCode code) : super(code);
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

class ManageBuyOfferResultCode {
  static const ManageBuyOfferResultCode manageBuyOfferSuccess =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_SUCCESS', 0);

  static const ManageBuyOfferResultCode manageBuyOfferMalformed =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_MALFORMED', -1);

  static const ManageBuyOfferResultCode manageBuyOfferSellNoTrust =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_SELL_NO_TRUST', -2);

  static const ManageBuyOfferResultCode manageBuyOfferBuyNoTrust =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_BUY_NO_TRUST', -3);

  static const ManageBuyOfferResultCode manageBuyOfferSellNotAuthorized =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_SELL_NOT_AUTHORIZED', -4);

  static const ManageBuyOfferResultCode manageBuyOfferBuyNotAuthorized =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_BUY_NOT_AUTHORIZED', -5);

  static const ManageBuyOfferResultCode manageBuyOfferLineFull =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_LINE_FULL', -6);

  static const ManageBuyOfferResultCode manageBuyOfferUnderfunded =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_UNDERFUNDED', -7);

  static const ManageBuyOfferResultCode manageBuyOfferCrossSelf =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_CROSS_SELF', -8);

  static const ManageBuyOfferResultCode manageBuyOfferSellNoIssuer =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_SELL_NO_ISSUER', -9);

  static const ManageBuyOfferResultCode manageBuyOfferBuyNoIssuer =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_BUY_NO_ISSUER', -10);

  static const ManageBuyOfferResultCode manageBuyOfferNotFound =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_NOT_FOUND', -11);

  static const ManageBuyOfferResultCode manageBuyOfferLowReserve =
      ManageBuyOfferResultCode._('MANAGE_BUY_OFFER_LOW_RESERVE', -12);

  final String name;
  final int value;

  const ManageBuyOfferResultCode._(this.name, this.value);

  static List<ManageBuyOfferResultCode> get values => [
        manageBuyOfferSuccess,
        manageBuyOfferMalformed,
        manageBuyOfferSellNoTrust,
        manageBuyOfferBuyNoTrust,
        manageBuyOfferSellNotAuthorized,
        manageBuyOfferBuyNotAuthorized,
        manageBuyOfferLineFull,
        manageBuyOfferUnderfunded,
        manageBuyOfferCrossSelf,
        manageBuyOfferSellNoIssuer,
        manageBuyOfferBuyNoIssuer,
        manageBuyOfferNotFound,
        manageBuyOfferLowReserve,
      ];
  static ManageBuyOfferResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ManageBuyOfferResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ManageBuyOfferResult extends OperationInner {
  final ManageBuyOfferResultCode code;
  const ManageBuyOfferResult(this.code) : super(OperationType.manageBuyOffer);
  factory ManageBuyOfferResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ManageBuyOfferResultCode.fromName(decode.variantName);
    switch (code) {
      case ManageBuyOfferResultCode.manageBuyOfferSuccess:
        return ManageBuyOfferResultSuccess.fromStruct(decode.result);
      default:
        return ManageBuyOfferResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ManageBuyOfferResultCode.values.length, (index) {
          final type = ManageBuyOfferResultCode.values.elementAt(index);
          switch (type) {
            case ManageBuyOfferResultCode.manageBuyOfferSuccess:
              return LazyVariantModel(
                  layout: ManageBuyOfferResultSuccess.layout,
                  index: type.value,
                  property: type.name);
            default:
              return LazyVariantModel(
                index: type.value,
                property: type.name,
                layout: ManageBuyOfferResultVoid.layout,
              );
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ManageBuyOfferResultSuccess extends ManageBuyOfferResult {
  final ManageOfferSuccessResult success;
  ManageBuyOfferResultSuccess(this.success)
      : super(ManageBuyOfferResultCode.manageBuyOfferSuccess);
  factory ManageBuyOfferResultSuccess.fromStruct(Map<String, dynamic> json) {
    return ManageBuyOfferResultSuccess(
        ManageOfferSuccessResult.fromStruct(json.asMap("success")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ManageOfferSuccessResult.layout(property: "success")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"success": success.toLayoutStruct()};
  }
}

class ManageBuyOfferResultVoid extends ManageBuyOfferResult {
  ManageBuyOfferResultVoid(ManageBuyOfferResultCode code) : super(code);
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

class PathPaymentStrictSendResultCode {
  static const PathPaymentStrictSendResultCode pathPaymentStrictSendSuccess =
      PathPaymentStrictSendResultCode._('PATH_PAYMENT_STRICT_SEND_SUCCESS', 0);

  static const PathPaymentStrictSendResultCode pathPaymentStrictSendMalformed =
      PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_MALFORMED', -1);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendUnderfunded = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_UNDERFUNDED', -2);

  static const PathPaymentStrictSendResultCode pathPaymentStrictSendSrcNoTrust =
      PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_SRC_NO_TRUST', -3);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendSrcNotAuthorized = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_SRC_NOT_AUTHORIZED', -4);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendNoDestination = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_NO_DESTINATION', -5);

  static const PathPaymentStrictSendResultCode pathPaymentStrictSendNoTrust =
      PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_NO_TRUST', -6);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendNotAuthorized = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_NOT_AUTHORIZED', -7);

  static const PathPaymentStrictSendResultCode pathPaymentStrictSendLineFull =
      PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_LINE_FULL', -8);

  static const PathPaymentStrictSendResultCode pathPaymentStrictSendNoIssuer =
      PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_NO_ISSUER', -9);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendTooFewOffers = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_TOO_FEW_OFFERS', -10);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendOfferCrossSelf = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_OFFER_CROSS_SELF', -11);

  static const PathPaymentStrictSendResultCode
      pathPaymentStrictSendUnderDestMin = PathPaymentStrictSendResultCode._(
          'PATH_PAYMENT_STRICT_SEND_UNDER_DESTMIN', -12);

  final String name;
  final int value;

  const PathPaymentStrictSendResultCode._(this.name, this.value);

  static List<PathPaymentStrictSendResultCode> get values => [
        pathPaymentStrictSendSuccess,
        pathPaymentStrictSendMalformed,
        pathPaymentStrictSendUnderfunded,
        pathPaymentStrictSendSrcNoTrust,
        pathPaymentStrictSendSrcNotAuthorized,
        pathPaymentStrictSendNoDestination,
        pathPaymentStrictSendNoTrust,
        pathPaymentStrictSendNotAuthorized,
        pathPaymentStrictSendLineFull,
        pathPaymentStrictSendNoIssuer,
        pathPaymentStrictSendTooFewOffers,
        pathPaymentStrictSendOfferCrossSelf,
        pathPaymentStrictSendUnderDestMin,
      ];
  static PathPaymentStrictSendResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "CreateClaimableBalanceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class PathPaymentStrictSendResult extends OperationInner {
  final PathPaymentStrictSendResultCode code;
  const PathPaymentStrictSendResult(this.code)
      : super(OperationType.pathPaymentStrictSend);
  factory PathPaymentStrictSendResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = PathPaymentStrictSendResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return PathPaymentStrictSendResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(PathPaymentStrictSendResultCode.values.length, (index) {
          final type = PathPaymentStrictSendResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: PathPaymentStrictSendResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class PathPaymentStrictSendResultVoid extends PathPaymentStrictSendResult {
  PathPaymentStrictSendResultVoid(PathPaymentStrictSendResultCode code)
      : super(code);
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

class CreateClaimableBalanceResultCode {
  static const CreateClaimableBalanceResultCode createClaimableBalanceSuccess =
      CreateClaimableBalanceResultCode._('CREATE_CLAIMABLE_BALANCE_SUCCESS', 0);
  static const CreateClaimableBalanceResultCode
      createClaimableBalanceMalformed = CreateClaimableBalanceResultCode._(
          'CREATE_CLAIMABLE_BALANCE_MALFORMED', -1);
  static const CreateClaimableBalanceResultCode
      createClaimableBalanceLowReserve = CreateClaimableBalanceResultCode._(
          'CREATE_CLAIMABLE_BALANCE_LOW_RESERVE', -2);
  static const CreateClaimableBalanceResultCode createClaimableBalanceNoTrust =
      CreateClaimableBalanceResultCode._(
          'CREATE_CLAIMABLE_BALANCE_NO_TRUST', -3);
  static const CreateClaimableBalanceResultCode
      createClaimableBalanceNotAuthorized = CreateClaimableBalanceResultCode._(
          'CREATE_CLAIMABLE_BALANCE_NOT_AUTHORIZED', -4);
  static const CreateClaimableBalanceResultCode
      createClaimableBalanceUnderfunded = CreateClaimableBalanceResultCode._(
          'CREATE_CLAIMABLE_BALANCE_UNDERFUNDED', -5);

  final String name;
  final int value;

  const CreateClaimableBalanceResultCode._(this.name, this.value);

  static List<CreateClaimableBalanceResultCode> get values => [
        createClaimableBalanceSuccess,
        createClaimableBalanceMalformed,
        createClaimableBalanceLowReserve,
        createClaimableBalanceNoTrust,
        createClaimableBalanceNotAuthorized,
        createClaimableBalanceUnderfunded,
      ];
  static CreateClaimableBalanceResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "CreateClaimableBalanceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class CreateClaimableBalanceResult extends OperationInner {
  final CreateClaimableBalanceResultCode code;
  const CreateClaimableBalanceResult(this.code)
      : super(OperationType.createClaimableBalance);
  factory CreateClaimableBalanceResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = CreateClaimableBalanceResultCode.fromName(decode.variantName);
    switch (code) {
      case CreateClaimableBalanceResultCode.createClaimableBalanceSuccess:
        return CreateClaimableBalanceResultSuccess.fromStruct(decode.value);
      default:
        return CreateClaimableBalanceResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(CreateClaimableBalanceResultCode.values.length, (index) {
          final type = CreateClaimableBalanceResultCode.values.elementAt(index);
          switch (type) {
            case CreateClaimableBalanceResultCode.createClaimableBalanceSuccess:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreateClaimableBalanceResultSuccess.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreateClaimableBalanceResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class CreateClaimableBalanceResultVoid extends CreateClaimableBalanceResult {
  CreateClaimableBalanceResultVoid(CreateClaimableBalanceResultCode code)
      : super(code);
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

class CreateClaimableBalanceResultSuccess extends CreateClaimableBalanceResult {
  final ClaimableBalanceId balanceId;
  CreateClaimableBalanceResultSuccess(this.balanceId)
      : super(CreateClaimableBalanceResultCode.createClaimableBalanceSuccess);
  factory CreateClaimableBalanceResultSuccess.fromStruct(
      Map<String, dynamic> json) {
    return CreateClaimableBalanceResultSuccess(
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
    return {"balanceId": balanceId.toVariantLayoutStruct()};
  }
}

class ClaimClaimableBalanceResultCode {
  static const ClaimClaimableBalanceResultCode claimClaimableBalanceSuccess =
      ClaimClaimableBalanceResultCode._('CLAIM_CLAIMABLE_BALANCE_SUCCESS', 0);
  static const ClaimClaimableBalanceResultCode
      claimClaimableBalanceDoesNotExist = ClaimClaimableBalanceResultCode._(
          'CLAIM_CLAIMABLE_BALANCE_DOES_NOT_EXIST', -1);
  static const ClaimClaimableBalanceResultCode
      claimClaimableBalanceCannotClaim = ClaimClaimableBalanceResultCode._(
          'CLAIM_CLAIMABLE_BALANCE_CANNOT_CLAIM', -2);
  static const ClaimClaimableBalanceResultCode claimClaimableBalanceLineFull =
      ClaimClaimableBalanceResultCode._(
          'CLAIM_CLAIMABLE_BALANCE_LINE_FULL', -3);
  static const ClaimClaimableBalanceResultCode claimClaimableBalanceNoTrust =
      ClaimClaimableBalanceResultCode._('CLAIM_CLAIMABLE_BALANCE_NO_TRUST', -4);
  static const ClaimClaimableBalanceResultCode
      claimClaimableBalanceNotAuthorized = ClaimClaimableBalanceResultCode._(
          'CLAIM_CLAIMABLE_BALANCE_NOT_AUTHORIZED', -5);

  final String name;
  final int value;

  const ClaimClaimableBalanceResultCode._(this.name, this.value);

  static List<ClaimClaimableBalanceResultCode> get values => [
        claimClaimableBalanceSuccess,
        claimClaimableBalanceDoesNotExist,
        claimClaimableBalanceCannotClaim,
        claimClaimableBalanceLineFull,
        claimClaimableBalanceNoTrust,
        claimClaimableBalanceNotAuthorized,
      ];
  static ClaimClaimableBalanceResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClaimClaimableBalanceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ClaimClaimableBalanceResult extends OperationInner {
  final ClaimClaimableBalanceResultCode code;
  const ClaimClaimableBalanceResult(this.code)
      : super(OperationType.claimClaimableBalance);
  factory ClaimClaimableBalanceResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ClaimClaimableBalanceResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ClaimClaimableBalanceResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ClaimClaimableBalanceResultCode.values.length, (index) {
          final type = ClaimClaimableBalanceResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimClaimableBalanceResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ClaimClaimableBalanceResultVoid extends ClaimClaimableBalanceResult {
  ClaimClaimableBalanceResultVoid(ClaimClaimableBalanceResultCode code)
      : super(code);
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

class EndSponsoringFutureReservesResultCode {
  static const EndSponsoringFutureReservesResultCode
      endSponsoringFutureReservesSuccess =
      EndSponsoringFutureReservesResultCode._(
          'END_SPONSORING_FUTURE_RESERVES_SUCCESS', 0);
  static const EndSponsoringFutureReservesResultCode
      endSponsoringFutureReservesNotSponsored =
      EndSponsoringFutureReservesResultCode._(
          'END_SPONSORING_FUTURE_RESERVES_NOT_SPONSORED', -1);

  final String name;
  final int value;

  const EndSponsoringFutureReservesResultCode._(this.name, this.value);

  static List<EndSponsoringFutureReservesResultCode> get values => [
        endSponsoringFutureReservesSuccess,
        endSponsoringFutureReservesNotSponsored,
      ];
  static EndSponsoringFutureReservesResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "EndSponsoringFutureReservesResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class EndSponsoringFutureReservesResult extends OperationInner {
  final EndSponsoringFutureReservesResultCode code;
  const EndSponsoringFutureReservesResult(this.code)
      : super(OperationType.endSponsoringFutureReserves);
  factory EndSponsoringFutureReservesResult.fromStruct(
      Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code =
        EndSponsoringFutureReservesResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return EndSponsoringFutureReservesResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(EndSponsoringFutureReservesResultCode.values.length,
            (index) {
          final type =
              EndSponsoringFutureReservesResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: EndSponsoringFutureReservesResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class EndSponsoringFutureReservesResultVoid
    extends EndSponsoringFutureReservesResult {
  EndSponsoringFutureReservesResultVoid(
      EndSponsoringFutureReservesResultCode code)
      : super(code);
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

class RevokeSponsorshipResultCode {
  static const RevokeSponsorshipResultCode revokeSponsorshipSuccess =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_SUCCESS', 0);
  static const RevokeSponsorshipResultCode revokeSponsorshipDoesNotExist =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_DOES_NOT_EXIST', -1);
  static const RevokeSponsorshipResultCode revokeSponsorshipNotSponsor =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_NOT_SPONSOR', -2);
  static const RevokeSponsorshipResultCode revokeSponsorshipLowReserve =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_LOW_RESERVE', -3);
  static const RevokeSponsorshipResultCode revokeSponsorshipOnlyTransferable =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_ONLY_TRANSFERABLE', -4);
  static const RevokeSponsorshipResultCode revokeSponsorshipMalformed =
      RevokeSponsorshipResultCode._('REVOKE_SPONSORSHIP_MALFORMED', -5);

  final String name;
  final int value;

  const RevokeSponsorshipResultCode._(this.name, this.value);

  static List<RevokeSponsorshipResultCode> get values => [
        revokeSponsorshipSuccess,
        revokeSponsorshipDoesNotExist,
        revokeSponsorshipNotSponsor,
        revokeSponsorshipLowReserve,
        revokeSponsorshipOnlyTransferable,
        revokeSponsorshipMalformed,
      ];
  static RevokeSponsorshipResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "RevokeSponsorshipResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class RevokeSponsorshipResult extends OperationInner {
  final RevokeSponsorshipResultCode code;
  const RevokeSponsorshipResult(this.code)
      : super(OperationType.revokeSponsorship);
  factory RevokeSponsorshipResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = RevokeSponsorshipResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return RevokeSponsorshipResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(RevokeSponsorshipResultCode.values.length, (index) {
          final type = RevokeSponsorshipResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: RevokeSponsorshipResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class RevokeSponsorshipResultVoid extends RevokeSponsorshipResult {
  RevokeSponsorshipResultVoid(RevokeSponsorshipResultCode code) : super(code);
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

class ClawbackResultCode {
  static const ClawbackResultCode clawbackSuccess =
      ClawbackResultCode._('CLAWBACK_SUCCESS', 0);
  static const ClawbackResultCode clawbackMalformed =
      ClawbackResultCode._('CLAWBACK_MALFORMED', -1);
  static const ClawbackResultCode clawbackNotClawbackEnabled =
      ClawbackResultCode._('CLAWBACK_NOT_CLAWBACK_ENABLED', -2);
  static const ClawbackResultCode clawbackNoTrust =
      ClawbackResultCode._('CLAWBACK_NO_TRUST', -3);
  static const ClawbackResultCode clawbackUnderfunded =
      ClawbackResultCode._('CLAWBACK_UNDERFUNDED', -4);

  final String name;
  final int value;

  const ClawbackResultCode._(this.name, this.value);

  static List<ClawbackResultCode> get values => [
        clawbackSuccess,
        clawbackMalformed,
        clawbackNotClawbackEnabled,
        clawbackNoTrust,
        clawbackUnderfunded,
      ];
  static ClawbackResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClawbackResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ClawbackResult extends OperationInner {
  final ClawbackResultCode code;
  const ClawbackResult(this.code) : super(OperationType.clawback);
  factory ClawbackResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ClawbackResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ClawbackResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ClawbackResultCode.values.length, (index) {
          final type = ClawbackResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClawbackResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ClawbackResultVoid extends ClawbackResult {
  ClawbackResultVoid(ClawbackResultCode code) : super(code);
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

class ClawbackClaimableBalanceResultCode {
  static const ClawbackClaimableBalanceResultCode
      clawbackClaimableBalanceSuccess = ClawbackClaimableBalanceResultCode._(
          'CLAWBACK_CLAIMABLE_BALANCE_SUCCESS', 0);
  static const ClawbackClaimableBalanceResultCode
      clawbackClaimableBalanceDoesNotExist =
      ClawbackClaimableBalanceResultCode._(
          'CLAWBACK_CLAIMABLE_BALANCE_DOES_NOT_EXIST', -1);
  static const ClawbackClaimableBalanceResultCode
      clawbackClaimableBalanceNotIssuer = ClawbackClaimableBalanceResultCode._(
          'CLAWBACK_CLAIMABLE_BALANCE_NOT_ISSUER', -2);
  static const ClawbackClaimableBalanceResultCode
      clawbackClaimableBalanceNotClawbackEnabled =
      ClawbackClaimableBalanceResultCode._(
          'CLAWBACK_CLAIMABLE_BALANCE_NOT_CLAWBACK_ENABLED', -3);

  final String name;
  final int value;

  const ClawbackClaimableBalanceResultCode._(this.name, this.value);

  static List<ClawbackClaimableBalanceResultCode> get values => [
        clawbackClaimableBalanceSuccess,
        clawbackClaimableBalanceDoesNotExist,
        clawbackClaimableBalanceNotIssuer,
        clawbackClaimableBalanceNotClawbackEnabled,
      ];
  static ClawbackClaimableBalanceResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "ClawbackClaimableBalanceResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ClawbackClaimableBalanceResult extends OperationInner {
  final ClawbackClaimableBalanceResultCode code;
  const ClawbackClaimableBalanceResult(this.code)
      : super(OperationType.clawbackClaimableBalance);
  factory ClawbackClaimableBalanceResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code =
        ClawbackClaimableBalanceResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ClawbackClaimableBalanceResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ClawbackClaimableBalanceResultCode.values.length,
            (index) {
          final type =
              ClawbackClaimableBalanceResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClawbackClaimableBalanceResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ClawbackClaimableBalanceResultVoid
    extends ClawbackClaimableBalanceResult {
  ClawbackClaimableBalanceResultVoid(ClawbackClaimableBalanceResultCode code)
      : super(code);
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

class SetTrustLineFlagsResultCode {
  static const SetTrustLineFlagsResultCode setTrustLineFlagsSuccess =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_SUCCESS', 0);
  static const SetTrustLineFlagsResultCode setTrustLineFlagsMalformed =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_MALFORMED', -1);
  static const SetTrustLineFlagsResultCode setTrustLineFlagsNoTrustLine =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_NO_TRUST_LINE', -2);
  static const SetTrustLineFlagsResultCode setTrustLineFlagsCantRevoke =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_CANT_REVOKE', -3);
  static const SetTrustLineFlagsResultCode setTrustLineFlagsInvalidState =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_INVALID_STATE', -4);
  static const SetTrustLineFlagsResultCode setTrustLineFlagsLowReserve =
      SetTrustLineFlagsResultCode._('SET_TRUST_LINE_FLAGS_LOW_RESERVE', -5);

  final String name;
  final int value;

  const SetTrustLineFlagsResultCode._(this.name, this.value);

  static List<SetTrustLineFlagsResultCode> get values => [
        setTrustLineFlagsSuccess,
        setTrustLineFlagsMalformed,
        setTrustLineFlagsNoTrustLine,
        setTrustLineFlagsCantRevoke,
        setTrustLineFlagsInvalidState,
        setTrustLineFlagsLowReserve,
      ];
  static SetTrustLineFlagsResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "SetTrustLineFlagsResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class SetTrustLineFlagsResult extends OperationInner {
  final SetTrustLineFlagsResultCode code;
  const SetTrustLineFlagsResult(this.code)
      : super(OperationType.setTrustLineFlags);
  factory SetTrustLineFlagsResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = SetTrustLineFlagsResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return SetTrustLineFlagsResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(SetTrustLineFlagsResultCode.values.length, (index) {
          final type = SetTrustLineFlagsResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: SetTrustLineFlagsResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class SetTrustLineFlagsResultVoid extends SetTrustLineFlagsResult {
  SetTrustLineFlagsResultVoid(SetTrustLineFlagsResultCode code) : super(code);
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

class LiquidityPoolDepositResultCode {
  static const LiquidityPoolDepositResultCode liquidityPoolDepositSuccess =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_SUCCESS', 0);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositMalformed =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_MALFORMED', -1);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositNoTrust =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_NO_TRUST', -2);
  static const LiquidityPoolDepositResultCode
      liquidityPoolDepositNotAuthorized = LiquidityPoolDepositResultCode._(
          'LIQUIDITY_POOL_DEPOSIT_NOT_AUTHORIZED', -3);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositUnderfunded =
      LiquidityPoolDepositResultCode._(
          'LIQUIDITY_POOL_DEPOSIT_UNDERFUNDED', -4);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositLineFull =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_LINE_FULL', -5);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositBadPrice =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_BAD_PRICE', -6);
  static const LiquidityPoolDepositResultCode liquidityPoolDepositPoolFull =
      LiquidityPoolDepositResultCode._('LIQUIDITY_POOL_DEPOSIT_POOL_FULL', -7);

  final String name;
  final int value;

  const LiquidityPoolDepositResultCode._(this.name, this.value);

  static List<LiquidityPoolDepositResultCode> get values => [
        liquidityPoolDepositSuccess,
        liquidityPoolDepositMalformed,
        liquidityPoolDepositNoTrust,
        liquidityPoolDepositNotAuthorized,
        liquidityPoolDepositUnderfunded,
        liquidityPoolDepositLineFull,
        liquidityPoolDepositBadPrice,
        liquidityPoolDepositPoolFull,
      ];
  static LiquidityPoolDepositResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "LiquidityPoolDepositResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class LiquidityPoolDepositResult extends OperationInner {
  final LiquidityPoolDepositResultCode code;
  const LiquidityPoolDepositResult(this.code)
      : super(OperationType.liquidityPoolDeposit);
  factory LiquidityPoolDepositResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = LiquidityPoolDepositResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return LiquidityPoolDepositResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(LiquidityPoolDepositResultCode.values.length, (index) {
          final type = LiquidityPoolDepositResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: LiquidityPoolDepositResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class LiquidityPoolDepositResultVoid extends LiquidityPoolDepositResult {
  LiquidityPoolDepositResultVoid(LiquidityPoolDepositResultCode code)
      : super(code);
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

class LiquidityPoolWithdrawResultCode {
  static const LiquidityPoolWithdrawResultCode liquidityPoolWithdrawSuccess =
      LiquidityPoolWithdrawResultCode._('LIQUIDITY_POOL_WITHDRAW_SUCCESS', 0);
  static const LiquidityPoolWithdrawResultCode liquidityPoolWithdrawMalformed =
      LiquidityPoolWithdrawResultCode._(
          'LIQUIDITY_POOL_WITHDRAW_MALFORMED', -1);
  static const LiquidityPoolWithdrawResultCode liquidityPoolWithdrawNoTrust =
      LiquidityPoolWithdrawResultCode._('LIQUIDITY_POOL_WITHDRAW_NO_TRUST', -2);
  static const LiquidityPoolWithdrawResultCode
      liquidityPoolWithdrawUnderfunded = LiquidityPoolWithdrawResultCode._(
          'LIQUIDITY_POOL_WITHDRAW_UNDERFUNDED', -3);
  static const LiquidityPoolWithdrawResultCode liquidityPoolWithdrawLineFull =
      LiquidityPoolWithdrawResultCode._(
          'LIQUIDITY_POOL_WITHDRAW_LINE_FULL', -4);
  static const LiquidityPoolWithdrawResultCode
      liquidityPoolWithdrawUnderMinimum = LiquidityPoolWithdrawResultCode._(
          'LIQUIDITY_POOL_WITHDRAW_UNDER_MINIMUM', -5);

  final String name;
  final int value;

  const LiquidityPoolWithdrawResultCode._(this.name, this.value);

  static List<LiquidityPoolWithdrawResultCode> get values => [
        liquidityPoolWithdrawSuccess,
        liquidityPoolWithdrawMalformed,
        liquidityPoolWithdrawNoTrust,
        liquidityPoolWithdrawUnderfunded,
        liquidityPoolWithdrawLineFull,
        liquidityPoolWithdrawUnderMinimum,
      ];
  static LiquidityPoolWithdrawResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "LiquidityPoolWithdrawResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class LiquidityPoolWithdrawResult extends OperationInner {
  final LiquidityPoolWithdrawResultCode code;
  const LiquidityPoolWithdrawResult(this.code)
      : super(OperationType.liquidityPoolWithdraw);
  factory LiquidityPoolWithdrawResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = LiquidityPoolWithdrawResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return LiquidityPoolWithdrawResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(LiquidityPoolWithdrawResultCode.values.length, (index) {
          final type = LiquidityPoolWithdrawResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: LiquidityPoolWithdrawResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class LiquidityPoolWithdrawResultVoid extends LiquidityPoolWithdrawResult {
  LiquidityPoolWithdrawResultVoid(LiquidityPoolWithdrawResultCode code)
      : super(code);
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

class InvokeHostFunctionResultCode {
  static const InvokeHostFunctionResultCode invokeHostFunctionSuccess =
      InvokeHostFunctionResultCode._('INVOKE_HOST_FUNCTION_SUCCESS', 0);
  static const InvokeHostFunctionResultCode invokeHostFunctionMalformed =
      InvokeHostFunctionResultCode._('INVOKE_HOST_FUNCTION_MALFORMED', -1);
  static const InvokeHostFunctionResultCode invokeHostFunctionTrapped =
      InvokeHostFunctionResultCode._('INVOKE_HOST_FUNCTION_TRAPPED', -2);
  static const InvokeHostFunctionResultCode
      invokeHostFunctionResourceLimitExceeded = InvokeHostFunctionResultCode._(
          'INVOKE_HOST_FUNCTION_RESOURCE_LIMIT_EXCEEDED', -3);
  static const InvokeHostFunctionResultCode invokeHostFunctionEntryArchived =
      InvokeHostFunctionResultCode._('INVOKE_HOST_FUNCTION_ENTRY_ARCHIVED', -4);
  static const InvokeHostFunctionResultCode
      invokeHostFunctionInsufficientRefundableFee =
      InvokeHostFunctionResultCode._(
          'INVOKE_HOST_FUNCTION_INSUFFICIENT_REFUNDABLE_FEE', -5);

  final String name;
  final int value;

  const InvokeHostFunctionResultCode._(this.name, this.value);

  static List<InvokeHostFunctionResultCode> get values => [
        invokeHostFunctionSuccess,
        invokeHostFunctionMalformed,
        invokeHostFunctionTrapped,
        invokeHostFunctionResourceLimitExceeded,
        invokeHostFunctionEntryArchived,
        invokeHostFunctionInsufficientRefundableFee,
      ];
  static InvokeHostFunctionResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "InvokeHostFunctionResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class InvokeHostFunctionResult extends OperationInner {
  final InvokeHostFunctionResultCode code;
  const InvokeHostFunctionResult(this.code)
      : super(OperationType.invokeHostFunction);
  factory InvokeHostFunctionResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = InvokeHostFunctionResultCode.fromName(decode.variantName);
    switch (code) {
      case InvokeHostFunctionResultCode.invokeHostFunctionSuccess:
        return InvokeHostFunctionResultSuccess.fromStruct(decode.value);
      default:
        return InvokeHostFunctionResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(InvokeHostFunctionResultCode.values.length, (index) {
          final type = InvokeHostFunctionResultCode.values.elementAt(index);
          switch (type) {
            case InvokeHostFunctionResultCode.invokeHostFunctionSuccess:
              return LazyVariantModel(
                  index: type.value,
                  layout: InvokeHostFunctionResultSuccess.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: InvokeHostFunctionResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class InvokeHostFunctionResultVoid extends InvokeHostFunctionResult {
  InvokeHostFunctionResultVoid(InvokeHostFunctionResultCode code) : super(code);
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

class InvokeHostFunctionResultSuccess extends InvokeHostFunctionResult {
  final List<int> success;
  InvokeHostFunctionResultSuccess(List<int> success)
      : success = success.asImmutableBytes.exc(StellarConst.hash256Length,
            name: "InvokeHostFunctionResultSuccess"),
        super(InvokeHostFunctionResultCode.invokeHostFunctionSuccess);
  factory InvokeHostFunctionResultSuccess.fromStruct(
      Map<String, dynamic> json) {
    return InvokeHostFunctionResultSuccess(json.asBytes("success"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length, property: "success")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"success": success};
  }
}

class ExtendFootprintTTLResultCode {
  static const ExtendFootprintTTLResultCode extendFootprintTtlSuccess =
      ExtendFootprintTTLResultCode._('EXTEND_FOOTPRINT_TTL_SUCCESS', 0);
  static const ExtendFootprintTTLResultCode extendFootprintTtlMalformed =
      ExtendFootprintTTLResultCode._('EXTEND_FOOTPRINT_TTL_MALFORMED', -1);
  static const ExtendFootprintTTLResultCode
      extendFootprintTtlResourceLimitExceeded = ExtendFootprintTTLResultCode._(
          'EXTEND_FOOTPRINT_TTL_RESOURCE_LIMIT_EXCEEDED', -2);
  static const ExtendFootprintTTLResultCode
      extendFootprintTtlInsufficientRefundableFee =
      ExtendFootprintTTLResultCode._(
          'EXTEND_FOOTPRINT_TTL_INSUFFICIENT_REFUNDABLE_FEE', -3);

  final String name;
  final int value;

  const ExtendFootprintTTLResultCode._(this.name, this.value);

  static List<ExtendFootprintTTLResultCode> get values => [
        extendFootprintTtlSuccess,
        extendFootprintTtlMalformed,
        extendFootprintTtlResourceLimitExceeded,
        extendFootprintTtlInsufficientRefundableFee,
      ];
  static ExtendFootprintTTLResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "OperationResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class ExtendFootprintTTLResult extends OperationInner {
  final ExtendFootprintTTLResultCode code;
  const ExtendFootprintTTLResult(this.code)
      : super(OperationType.extendFootprintTtl);
  factory ExtendFootprintTTLResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = ExtendFootprintTTLResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return ExtendFootprintTTLResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ExtendFootprintTTLResultCode.values.length, (index) {
          final type = ExtendFootprintTTLResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: ExtendFootprintTTLResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class ExtendFootprintTTLResultVoid extends ExtendFootprintTTLResult {
  ExtendFootprintTTLResultVoid(ExtendFootprintTTLResultCode code) : super(code);
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

class RestoreFootprintResultCode {
  static const RestoreFootprintResultCode restoreFootprintSuccess =
      RestoreFootprintResultCode._('RESTORE_FOOTPRINT_SUCCESS', 0);
  static const RestoreFootprintResultCode restoreFootprintMalformed =
      RestoreFootprintResultCode._('RESTORE_FOOTPRINT_MALFORMED', -1);
  static const RestoreFootprintResultCode
      restoreFootprintResourceLimitExceeded = RestoreFootprintResultCode._(
          'RESTORE_FOOTPRINT_RESOURCE_LIMIT_EXCEEDED', -2);
  static const RestoreFootprintResultCode
      restoreFootprintInsufficientRefundableFee = RestoreFootprintResultCode._(
          'RESTORE_FOOTPRINT_INSUFFICIENT_REFUNDABLE_FEE', -3);

  final String name;
  final int value;

  const RestoreFootprintResultCode._(this.name, this.value);

  static List<RestoreFootprintResultCode> get values => [
        restoreFootprintSuccess,
        restoreFootprintMalformed,
        restoreFootprintResourceLimitExceeded,
        restoreFootprintInsufficientRefundableFee,
      ];
  static RestoreFootprintResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "OperationResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class RestoreFootprintResult extends OperationInner {
  final RestoreFootprintResultCode code;
  const RestoreFootprintResult(this.code)
      : super(OperationType.restoreFootprint);
  factory RestoreFootprintResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = RestoreFootprintResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return RestoreFootprintResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(RestoreFootprintResultCode.values.length, (index) {
          final type = RestoreFootprintResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: RestoreFootprintResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class RestoreFootprintResultVoid extends RestoreFootprintResult {
  RestoreFootprintResultVoid(RestoreFootprintResultCode code) : super(code);
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

class BeginSponsoringFutureReservesResultCode {
  static const BeginSponsoringFutureReservesResultCode
      beginSponsoringFutureReservesSuccess =
      BeginSponsoringFutureReservesResultCode._(
          'BEGIN_SPONSORING_FUTURE_RESERVES_SUCCESS', 0);
  static const BeginSponsoringFutureReservesResultCode
      beginSponsoringFutureReservesMalformed =
      BeginSponsoringFutureReservesResultCode._(
          'BEGIN_SPONSORING_FUTURE_RESERVES_MALFORMED', -1);
  static const BeginSponsoringFutureReservesResultCode
      beginSponsoringFutureReservesSponsored =
      BeginSponsoringFutureReservesResultCode._(
          'BEGIN_SPONSORING_FUTURE_RESERVES_ALREADY_SPONSORED', -2);
  static const BeginSponsoringFutureReservesResultCode
      beginSponsoringFutureReservesRecursive =
      BeginSponsoringFutureReservesResultCode._(
          'BEGIN_SPONSORING_FUTURE_RESERVES_RECURSIVE', -3);

  final String name;
  final int value;

  const BeginSponsoringFutureReservesResultCode._(this.name, this.value);

  static List<BeginSponsoringFutureReservesResultCode> get values => [
        beginSponsoringFutureReservesSuccess,
        beginSponsoringFutureReservesMalformed,
        beginSponsoringFutureReservesSponsored,
        beginSponsoringFutureReservesRecursive,
      ];
  static BeginSponsoringFutureReservesResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "BeginSponsoringFutureReservesResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class BeginSponsoringFutureReservesResult extends OperationInner {
  final BeginSponsoringFutureReservesResultCode code;
  const BeginSponsoringFutureReservesResult(this.code)
      : super(OperationType.beginSponsoringFutureReserves);
  factory BeginSponsoringFutureReservesResult.fromStruct(
      Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code =
        BeginSponsoringFutureReservesResultCode.fromName(decode.variantName);
    switch (code) {
      default:
        return BeginSponsoringFutureReservesResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(ExtendFootprintTTLResultCode.values.length, (index) {
          final type = ExtendFootprintTTLResultCode.values.elementAt(index);
          switch (type) {
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: BeginSponsoringFutureReservesResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class BeginSponsoringFutureReservesResultVoid
    extends BeginSponsoringFutureReservesResult {
  BeginSponsoringFutureReservesResultVoid(
      BeginSponsoringFutureReservesResultCode code)
      : super(code);
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

class TransactionResultType {
  static const TransactionResultType txFeeBumpInnerSuccess =
      TransactionResultType._('txFEE_BUMP_INNER_SUCCESS', 1);
  static const TransactionResultType txSuccess =
      TransactionResultType._('txSUCCESS', 0);
  static const TransactionResultType txFailed =
      TransactionResultType._('txFAILED', -1);
  static const TransactionResultType txTooEarly =
      TransactionResultType._('txTOO_EARLY', -2);
  static const TransactionResultType txTooLate =
      TransactionResultType._('txTOO_LATE', -3);
  static const TransactionResultType txMissingOperation =
      TransactionResultType._('txMISSING_OPERATION', -4);
  static const TransactionResultType txBadSeq =
      TransactionResultType._('txBAD_SEQ', -5);
  static const TransactionResultType txBadAuth =
      TransactionResultType._('txBAD_AUTH', -6);
  static const TransactionResultType txInsufficientBalance =
      TransactionResultType._('txINSUFFICIENT_BALANCE', -7);
  static const TransactionResultType txNoAccount =
      TransactionResultType._('txNO_ACCOUNT', -8);
  static const TransactionResultType txInsufficientFee =
      TransactionResultType._('txINSUFFICIENT_FEE', -9);
  static const TransactionResultType txBadAuthExtra =
      TransactionResultType._('txBAD_AUTH_EXTRA', -10);
  static const TransactionResultType txInternalError =
      TransactionResultType._('txINTERNAL_ERROR', -11);
  static const TransactionResultType txNotSupported =
      TransactionResultType._('txNOT_SUPPORTED', -12);
  static const TransactionResultType txFeeBumpInnerFailed =
      TransactionResultType._('txFEE_BUMP_INNER_FAILED', -13);
  static const TransactionResultType txBadSponsorship =
      TransactionResultType._('txBAD_SPONSORSHIP', -14);
  static const TransactionResultType txBadMinSeqAgeOrGap =
      TransactionResultType._('txBAD_MIN_SEQ_AGE_OR_GAP', -15);
  static const TransactionResultType txMalformed =
      TransactionResultType._('txMALFORMED', -16);
  static const TransactionResultType txSorobanInvalid =
      TransactionResultType._('txSOROBAN_INVALID', -17);

  final String name;
  final int value;

  const TransactionResultType._(this.name, this.value);

  static List<TransactionResultType> get values => [
        txFeeBumpInnerSuccess,
        txSuccess,
        txFailed,
        txTooEarly,
        txTooLate,
        txMissingOperation,
        txBadSeq,
        txBadAuth,
        txInsufficientBalance,
        txNoAccount,
        txInsufficientFee,
        txBadAuthExtra,
        txInternalError,
        txNotSupported,
        txFeeBumpInnerFailed,
        txBadSponsorship,
        txBadMinSeqAgeOrGap,
        txMalformed,
        txSorobanInvalid,
      ];
  static TransactionResultType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "TransactionResultType not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  @override
  String toString() {
    return "TransactionResultType.$name";
  }
}

class OperationResultCode {
  static const OperationResultCode opInner =
      OperationResultCode._('opINNER', 0);
  static const OperationResultCode opBadAuth =
      OperationResultCode._('opBAD_AUTH', -1);
  static const OperationResultCode opNoAccount =
      OperationResultCode._('opNO_ACCOUNT', -2);
  static const OperationResultCode opNotSupported =
      OperationResultCode._('opNOT_SUPPORTED', -3);
  static const OperationResultCode opTooManySubentries =
      OperationResultCode._('opTOO_MANY_SUBENTRIES', -4);
  static const OperationResultCode opExceededWorkLimit =
      OperationResultCode._('opEXCEEDED_WORK_LIMIT', -5);
  static const OperationResultCode opTooManySponsoring =
      OperationResultCode._('opTOO_MANY_SPONSORING', -6);

  final String name;
  final int value;

  const OperationResultCode._(this.name, this.value);

  static List<OperationResultCode> get values => [
        opInner,
        opBadAuth,
        opNoAccount,
        opNotSupported,
        opTooManySubentries,
        opExceededWorkLimit,
        opTooManySponsoring,
      ];
  static OperationResultCode fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "OperationResultCode not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

abstract class OperationResult extends XDRVariantSerialization {
  final OperationResultCode code;
  const OperationResult(this.code);
  factory OperationResult.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = OperationResultCode.fromName(decode.variantName);
    switch (code) {
      case OperationResultCode.opInner:
        return OperationResultOpInner.fromStruct(decode.value);
      default:
        return OperationResultVoid(code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(RestoreFootprintResultCode.values.length, (index) {
          final type = OperationResultCode.values.elementAt(index);
          switch (type) {
            case OperationResultCode.opInner:
              return LazyVariantModel(
                  index: type.value,
                  layout: OperationResultOpInner.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: OperationResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class OperationResultOpInner extends OperationResult {
  final OperationInner opInner;
  OperationResultOpInner(this.opInner) : super(OperationResultCode.opInner);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be(
        List.generate(OperationType.values.length, (index) {
          final type = OperationType.values.elementAt(index);
          switch (type) {
            case OperationType.payment:
              return LazyVariantModel(
                  index: type.value,
                  layout: PaymentResult.layout,
                  property: type.name);
            case OperationType.setOptions:
              return LazyVariantModel(
                  index: type.value,
                  layout: SetOptionsResult.layout,
                  property: type.name);
            case OperationType.pathPaymentStrictReceive:
              return LazyVariantModel(
                  index: type.value,
                  layout: PathPaymentStrictReceiveResult.layout,
                  property: type.name);
            case OperationType.createAccount:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreateAccountResult.layout,
                  property: type.name);
            case OperationType.manageSellOffer:
              return LazyVariantModel(
                  index: type.value,
                  layout: ManageSellOfferResult.layout,
                  property: type.name);
            case OperationType.createPassiveSellOffer:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreatePassiveSellOfferResult.layout,
                  property: type.name);
            case OperationType.changeTrust:
              return LazyVariantModel(
                  index: type.value,
                  layout: ChangeTrustResult.layout,
                  property: type.name);
            case OperationType.allowTrust:
              return LazyVariantModel(
                  index: type.value,
                  layout: AllowTrustResult.layout,
                  property: type.name);
            case OperationType.accountMerge:
              return LazyVariantModel(
                  index: type.value,
                  layout: AccountMergeResult.layout,
                  property: type.name);
            case OperationType.inflation:
              return LazyVariantModel(
                  index: type.value,
                  layout: InflationResult.layout,
                  property: type.name);
            case OperationType.manageData:
              return LazyVariantModel(
                  index: type.value,
                  layout: ManageDataResult.layout,
                  property: type.name);
            case OperationType.bumpSequence:
              return LazyVariantModel(
                  index: type.value,
                  layout: BumpSequenceResult.layout,
                  property: type.name);
            case OperationType.manageBuyOffer:
              return LazyVariantModel(
                  index: type.value,
                  layout: ManageBuyOfferResult.layout,
                  property: type.name);
            case OperationType.pathPaymentStrictSend:
              return LazyVariantModel(
                  index: type.value,
                  layout: PathPaymentStrictSendResult.layout,
                  property: type.name);
            case OperationType.createClaimableBalance:
              return LazyVariantModel(
                  index: type.value,
                  layout: CreateClaimableBalanceResult.layout,
                  property: type.name);

            case OperationType.claimClaimableBalance:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClaimClaimableBalanceResult.layout,
                  property: type.name);
            case OperationType.beginSponsoringFutureReserves:
              return LazyVariantModel(
                  index: type.value,
                  layout: BeginSponsoringFutureReservesResult.layout,
                  property: type.name);

            case OperationType.endSponsoringFutureReserves:
              return LazyVariantModel(
                  index: type.value,
                  layout: EndSponsoringFutureReservesResult.layout,
                  property: type.name);

            case OperationType.revokeSponsorship:
              return LazyVariantModel(
                  index: type.value,
                  layout: RevokeSponsorshipResult.layout,
                  property: type.name);
            case OperationType.clawback:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClawbackResult.layout,
                  property: type.name);
            case OperationType.clawbackClaimableBalance:
              return LazyVariantModel(
                  index: type.value,
                  layout: ClawbackClaimableBalanceResult.layout,
                  property: type.name);
            case OperationType.setTrustLineFlags:
              return LazyVariantModel(
                  index: type.value,
                  layout: SetTrustLineFlagsResult.layout,
                  property: type.name);
            case OperationType.liquidityPoolDeposit:
              return LazyVariantModel(
                  index: type.value,
                  layout: LiquidityPoolDepositResult.layout,
                  property: type.name);
            case OperationType.liquidityPoolWithdraw:
              return LazyVariantModel(
                  index: type.value,
                  layout: LiquidityPoolWithdrawResult.layout,
                  property: type.name);
            case OperationType.invokeHostFunction:
              return LazyVariantModel(
                  index: type.value,
                  layout: InvokeHostFunctionResult.layout,
                  property: type.name);
            case OperationType.extendFootprintTtl:
              return LazyVariantModel(
                  index: type.value,
                  layout: ExtendFootprintTTLResult.layout,
                  property: type.name);
            case OperationType.restoreFootprint:
              return LazyVariantModel(
                  index: type.value,
                  layout: RestoreFootprintResult.layout,
                  property: type.name);
            default:
              throw const DartStellarPlugingException(
                  "Invalid Operation type.");
          }
        }),
        property: property);
  }

  factory OperationResultOpInner.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = OperationType.fromName(decode.variantName);
    final OperationInner inner;
    switch (type) {
      case OperationType.payment:
        inner = PaymentResult.fromStruct(decode.value);
        break;
      case OperationType.setOptions:
        inner = SetOptionsResult.fromStruct(decode.value);
        break;
      case OperationType.pathPaymentStrictReceive:
        inner = PathPaymentStrictReceiveResult.fromStruct(decode.value);
        break;
      case OperationType.createAccount:
        inner = CreateAccountResult.fromStruct(decode.value);
        break;
      case OperationType.manageSellOffer:
        inner = ManageSellOfferResult.fromStruct(decode.value);
        break;
      case OperationType.createPassiveSellOffer:
        inner = CreatePassiveSellOfferResult.fromStruct(decode.value);
        break;
      case OperationType.changeTrust:
        inner = ChangeTrustResult.fromStruct(decode.value);
        break;
      case OperationType.allowTrust:
        inner = AllowTrustResult.fromStruct(decode.value);
        break;
      case OperationType.accountMerge:
        inner = AccountMergeResult.fromStruct(decode.value);
        break;
      case OperationType.inflation:
        inner = InflationResult.fromStruct(decode.value);
        break;
      case OperationType.manageData:
        inner = ManageDataResult.fromStruct(decode.value);
        break;
      case OperationType.bumpSequence:
        inner = BumpSequenceResult.fromStruct(decode.value);
        break;
      case OperationType.manageBuyOffer:
        inner = ManageBuyOfferResult.fromStruct(decode.value);
        break;
      case OperationType.pathPaymentStrictSend:
        inner = PathPaymentStrictSendResult.fromStruct(decode.value);
        break;
      case OperationType.createClaimableBalance:
        inner = CreateClaimableBalanceResult.fromStruct(decode.value);
        break;
      case OperationType.claimClaimableBalance:
        inner = ClaimClaimableBalanceResult.fromStruct(decode.value);
        break;
      case OperationType.beginSponsoringFutureReserves:
        inner = BeginSponsoringFutureReservesResult.fromStruct(decode.value);
        break;
      case OperationType.endSponsoringFutureReserves:
        inner = EndSponsoringFutureReservesResult.fromStruct(decode.value);
        break;
      case OperationType.revokeSponsorship:
        inner = RevokeSponsorshipResult.fromStruct(decode.value);
        break;
      case OperationType.clawback:
        inner = ClawbackResult.fromStruct(decode.value);
        break;
      case OperationType.clawbackClaimableBalance:
        inner = ClawbackClaimableBalanceResult.fromStruct(decode.value);
        break;
      case OperationType.setTrustLineFlags:
        inner = SetTrustLineFlagsResult.fromStruct(decode.value);
        break;
      case OperationType.liquidityPoolDeposit:
        inner = LiquidityPoolDepositResult.fromStruct(decode.value);
        break;
      case OperationType.liquidityPoolWithdraw:
        inner = LiquidityPoolWithdrawResult.fromStruct(decode.value);
        break;
      case OperationType.invokeHostFunction:
        inner = InvokeHostFunctionResult.fromStruct(decode.value);
        break;
      case OperationType.extendFootprintTtl:
        inner = ExtendFootprintTTLResult.fromStruct(decode.value);
        break;
      case OperationType.restoreFootprint:
        inner = RestoreFootprintResult.fromStruct(decode.value);
        break;
      default:
        throw const DartStellarPlugingException("Invalid Operation type.");
    }
    return OperationResultOpInner(inner);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {opInner.type.name: opInner.toVariantLayoutStruct()};
  }
}

class OperationResultVoid extends OperationResult {
  OperationResultVoid(OperationResultCode code) : super(code);
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

class InnerTransactionResultPair extends TransactionResultCode {
  final List<int> transactionHash;
  final TransactionResult result;
  InnerTransactionResultPair({
    required this.result,
    required List<int> transactionHash,
  })  : transactionHash = transactionHash.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "transactionHash"),
        super(code: TransactionResultType.txFeeBumpInnerFailed);
  factory InnerTransactionResultPair.fromStruct(Map<String, dynamic> json) {
    return InnerTransactionResultPair(
      result: TransactionResult.fromStruct(json.asMap("result")),
      transactionHash: json.asBytes("transactionHash"),
    );
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "transactionHash"),
      TransactionResult.layout(property: "result")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "transactionHash": transactionHash,
      "result": result.toLayoutStruct(),
    };
  }
}

abstract class TransactionResultCode extends XDRVariantSerialization {
  final TransactionResultType code;
  const TransactionResultCode({required this.code});
  factory TransactionResultCode.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRVariantSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));

    return TransactionResultCode.fromStruct(decode);
  }
  factory TransactionResultCode.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final code = TransactionResultType.fromName(decode.variantName);
    switch (code) {
      case TransactionResultType.txSuccess:
        return TransactionResultTxSuccess.fromStruct(decode.value);
      case TransactionResultType.txFailed:
        return TransactionResultTxFailed.fromStruct(decode.value);
      case TransactionResultType.txFeeBumpInnerFailed:
        return InnerTransactionResultPair.fromStruct(decode.value);
      default:
        return TransactionResultVoid(code: code);
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumS32Be(
        List.generate(TransactionResultType.values.length, (index) {
          final type = TransactionResultType.values.elementAt(index);
          switch (type) {
            case TransactionResultType.txFeeBumpInnerFailed:
              return LazyVariantModel(
                  index: type.value,
                  layout: InnerTransactionResultPair.layout,
                  property: type.name);
            case TransactionResultType.txFailed:
              return LazyVariantModel(
                  index: type.value,
                  layout: TransactionResultTxFailed.layout,
                  property: type.name);
            case TransactionResultType.txSuccess:
              return LazyVariantModel(
                  index: type.value,
                  layout: TransactionResultTxSuccess.layout,
                  property: type.name);
            default:
              return LazyVariantModel(
                  index: type.value,
                  layout: TransactionResultVoid.layout,
                  property: type.name);
          }
        }),
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => code.name;
}

class TransactionResultVoid extends TransactionResultCode {
  TransactionResultVoid({required TransactionResultType code})
      : super(code: code);

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

class TransactionResultTxSuccess extends TransactionResultCode {
  final List<OperationResult> operationResult;
  TransactionResultTxSuccess({
    required List<OperationResult> operationResult,
  })  : operationResult = operationResult.immutable,
        super(code: TransactionResultType.txSuccess);
  factory TransactionResultTxSuccess.fromStruct(Map<String, dynamic> json) {
    return TransactionResultTxSuccess(
        operationResult: json
            .asListOfMap("operationResult")!
            .map((e) => OperationResult.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(OperationResult.layout(), property: "operationResult")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "operationResult":
          operationResult.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }
}

class TransactionResultTxFailed extends TransactionResultCode {
  final List<OperationResult> operationResult;
  TransactionResultTxFailed({
    required List<OperationResult> operationResult,
  })  : operationResult = operationResult.immutable,
        super(code: TransactionResultType.txFailed);
  factory TransactionResultTxFailed.fromStruct(Map<String, dynamic> json) {
    return TransactionResultTxFailed(
        operationResult: json
            .asListOfMap("operationResult")!
            .map((e) => OperationResult.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(OperationResult.layout(), property: "operationResult")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "operationResult":
          operationResult.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }
}

class TransactionResult extends XDRSerialization {
  final BigInt feeCharged;
  final TransactionResultCode code;
  TransactionResult({required this.code, required BigInt feeCharged})
      : feeCharged = feeCharged.asInt64,
        super();
  factory TransactionResult.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return TransactionResult.fromStruct(decode);
  }
  factory TransactionResult.fromStruct(Map<String, dynamic> json) {
    return TransactionResult(
        feeCharged: json.as("feeCharged"),
        code: TransactionResultCode.fromStruct(json.asMap("code")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "feeCharged"),
      TransactionResultCode.layout(property: "code")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"feeCharged": feeCharged, "code": code.toVariantLayoutStruct()};
  }
}
