import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/keypair/keypair.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/serialization/serialization.dart';
import 'package:stellar_dart/src/utils/validator.dart';

class OperationLevel {
  final String name;
  const OperationLevel._(this.name);
  static const OperationLevel low = OperationLevel._("low");
  static const OperationLevel high = OperationLevel._("high");
  static const OperationLevel medium = OperationLevel._("medium");

  @override
  String toString() {
    return name;
  }
}

class OperationType {
  final String name;
  final int value;

  const OperationType._({required this.name, required this.value});

  static const createAccount = OperationType._(name: 'CreateAccount', value: 0);
  static const payment = OperationType._(name: 'Payment', value: 1);
  static const pathPaymentStrictReceive =
      OperationType._(name: 'PathPaymentStrictReceive', value: 2);
  static const manageSellOffer =
      OperationType._(name: 'ManageSellOffer', value: 3);
  static const createPassiveSellOffer =
      OperationType._(name: 'CreatePassiveSellOffer', value: 4);
  static const setOptions = OperationType._(name: 'SetOptions', value: 5);
  static const changeTrust = OperationType._(name: 'ChangeTrust', value: 6);
  static const allowTrust = OperationType._(name: 'AllowTrust', value: 7);
  static const accountMerge = OperationType._(name: 'AccountMerge', value: 8);
  static const inflation = OperationType._(name: 'Inflation', value: 9);
  static const manageData = OperationType._(name: 'ManageData', value: 10);
  static const bumpSequence = OperationType._(name: 'BumpSequence', value: 11);
  static const manageBuyOffer =
      OperationType._(name: 'ManageBuyOffer', value: 12);
  static const pathPaymentStrictSend =
      OperationType._(name: 'PathPaymentStrictSend', value: 13);
  static const createClaimableBalance =
      OperationType._(name: 'CreateClaimableBalance', value: 14);
  static const claimClaimableBalance =
      OperationType._(name: 'ClaimClaimableBalance', value: 15);
  static const beginSponsoringFutureReserves =
      OperationType._(name: 'BeginSponsoringFutureReserves', value: 16);

  static const endSponsoringFutureReserves =
      OperationType._(name: 'EndSponsoringFutureReserves', value: 17);
  static const revokeSponsorship =
      OperationType._(name: 'RevokeSponsorship', value: 18);
  static const clawback = OperationType._(name: 'Clawback', value: 19);
  static const clawbackClaimableBalance =
      OperationType._(name: 'ClawbackClaimableBalance', value: 20);
  static const setTrustLineFlags =
      OperationType._(name: 'SetTrustLineFlags', value: 21);
  static const liquidityPoolDeposit =
      OperationType._(name: 'LiquidityPoolDeposit', value: 22);
  static const liquidityPoolWithdraw =
      OperationType._(name: 'LiquidityPoolWithdraw', value: 23);
  static const invokeHostFunction =
      OperationType._(name: 'InvokeHostFunction', value: 24);
  static const extendFootprintTtl =
      OperationType._(name: 'ExtendFootprintTtl', value: 25);
  static const restoreFootprint =
      OperationType._(name: 'RestoreFootprint', value: 26);
  static const List<OperationType> values = [
    createAccount,
    payment,
    pathPaymentStrictReceive,
    manageSellOffer,
    createPassiveSellOffer,
    setOptions,
    changeTrust,
    allowTrust,
    accountMerge,
    inflation,
    manageData,
    bumpSequence,
    manageBuyOffer,
    pathPaymentStrictSend,
    createClaimableBalance,
    claimClaimableBalance,
    beginSponsoringFutureReserves,
    endSponsoringFutureReserves,
    revokeSponsorship,
    clawback,
    clawbackClaimableBalance,
    setTrustLineFlags,
    liquidityPoolDeposit,
    liquidityPoolWithdraw,
    invokeHostFunction,
    extendFootprintTtl,
    restoreFootprint
  ];
  static OperationType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException(
          "Operation type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }
}

class Operation<T extends OperationBody> extends XDRSerialization {
  final MuxedAccount? sourceAccount;
  final T body;
  const Operation({this.sourceAccount, required this.body});
  factory Operation.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return Operation.fromStruct(decode);
  }
  factory Operation.fromStruct(Map<String, dynamic> json) {
    final body = OperationBody.fromStruct(json.asMap("body"));
    if (body is! T) {
      throw const DartStellarPlugingException("Incorrect operation casting.");
    }
    return Operation(
        body: body,
        sourceAccount: json.mybeAs<MuxedAccount, Map<String, dynamic>>(
            key: "sourceAccount", onValue: (e) => MuxedAccount.fromStruct(e)));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.struct([
        LayoutConst.optionalU32Be(MuxedAccount.layout(),
            property: "sourceAccount"),
        OperationBody.layout(property: "body")
      ], property: property);
  @override
  Map<String, dynamic> toJson() {
    return {
      "body": body.toVariantLayoutStruct(),
      "sourceAccount": sourceAccount?.toVariantLayoutStruct()
    };
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "body": body.toVariantLayoutStruct(),
      "sourceAccount": sourceAccount?.toVariantLayoutStruct()
    };
  }
}

abstract class OperationBody extends XDRVariantSerialization {
  final OperationType operationType;
  OperationLevel get level => OperationLevel.medium;
  const OperationBody(this.operationType);
  @override
  Map<String, dynamic> toJson();
  factory OperationBody.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = OperationType.fromName(decode.variantName);
    switch (type) {
      case OperationType.payment:
        return PaymentOperation.fromStruct(decode.value);
      case OperationType.setOptions:
        return SetOptionsOperation.fromStruct(decode.value);
      case OperationType.pathPaymentStrictReceive:
        return PathPaymentStrictReceiveOperation.fromStruct(decode.value);
      case OperationType.createAccount:
        return CreateAccountOperation.fromStruct(decode.value);
      case OperationType.manageSellOffer:
        return ManageSellOfferOperation.fromStruct(decode.value);
      case OperationType.createPassiveSellOffer:
        return CreatePassiveSellOfferOperation.fromStruct(decode.value);
      case OperationType.changeTrust:
        return ChangeTrustOperation.fromStruct(decode.value);
      case OperationType.allowTrust:
        return AllowTrustOperation.fromStruct(decode.value);
      case OperationType.accountMerge:
        return AccountMergeOperation.fromStruct(decode.value);
      case OperationType.inflation:
        return InflationOperation.fromStruct(decode.value);
      case OperationType.manageData:
        return ManageDataOperation.fromStruct(decode.value);
      case OperationType.bumpSequence:
        return BumpSequenceOperation.fromStruct(decode.value);
      case OperationType.manageBuyOffer:
        return ManageBuyOfferOperation.fromStruct(decode.value);
      case OperationType.pathPaymentStrictSend:
        return PathPaymentStrictSendOperation.fromStruct(decode.value);
      case OperationType.createClaimableBalance:
        return CreateClaimableBalanceOperation.fromStruct(decode.value);
      case OperationType.claimClaimableBalance:
        return ClaimClaimableBalanceOperation.fromStruct(decode.value);
      case OperationType.beginSponsoringFutureReserves:
        return BeginSponsoringFutureReservesOperation.fromStruct(decode.value);
      case OperationType.endSponsoringFutureReserves:
        return EndSponsoringFutureReservesOperation.fromStruct(decode.value);
      case OperationType.revokeSponsorship:
        return RevokeSponsorshipOperation.fromStruct(decode.value);
      case OperationType.clawback:
        return ClawbackOperation.fromStruct(decode.value);
      case OperationType.clawbackClaimableBalance:
        return ClawbackClaimableBalanceOperation.fromStruct(decode.value);
      case OperationType.setTrustLineFlags:
        return SetTrustLineFlagsOperation.fromStruct(decode.value);
      case OperationType.liquidityPoolDeposit:
        return LiquidityPoolDepositOperation.fromStruct(decode.value);

      case OperationType.liquidityPoolWithdraw:
        return LiquidityPoolWithdrawOperation.fromStruct(decode.value);
      case OperationType.invokeHostFunction:
        return InvokeHostFunctionOperation.fromStruct(decode.value);
      case OperationType.extendFootprintTtl:
        return ExtendFootprintTTLOperation.fromStruct(decode.value);
      case OperationType.restoreFootprint:
        return RestoreFootprintOperation.fromStruct(decode.value);
      default:
        throw const DartStellarPlugingException("Invalid Operation type.");
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) =>
      LayoutConst.lazyEnumU32Be(
          List.generate(OperationType.values.length, (i) {
            final type = OperationType.values.elementAt(i);
            switch (type) {
              case OperationType.payment:
                return LazyVariantModel(
                    index: type.value,
                    layout: PaymentOperation.layout,
                    property: type.name);
              case OperationType.setOptions:
                return LazyVariantModel(
                    index: type.value,
                    layout: SetOptionsOperation.layout,
                    property: type.name);
              case OperationType.pathPaymentStrictReceive:
                return LazyVariantModel(
                    index: type.value,
                    layout: PathPaymentStrictReceiveOperation.layout,
                    property: type.name);
              case OperationType.createAccount:
                return LazyVariantModel(
                    index: type.value,
                    layout: CreateAccountOperation.layout,
                    property: type.name);
              case OperationType.manageSellOffer:
                return LazyVariantModel(
                    index: type.value,
                    layout: ManageSellOfferOperation.layout,
                    property: type.name);
              case OperationType.createPassiveSellOffer:
                return LazyVariantModel(
                    index: type.value,
                    layout: CreatePassiveSellOfferOperation.layout,
                    property: type.name);
              case OperationType.changeTrust:
                return LazyVariantModel(
                    index: type.value,
                    layout: ChangeTrustOperation.layout,
                    property: type.name);
              case OperationType.allowTrust:
                return LazyVariantModel(
                    index: type.value,
                    layout: AllowTrustOperation.layout,
                    property: type.name);
              case OperationType.accountMerge:
                return LazyVariantModel(
                    index: type.value,
                    layout: AccountMergeOperation.layout,
                    property: type.name);
              case OperationType.inflation:
                return LazyVariantModel(
                    index: type.value,
                    layout: InflationOperation.layout,
                    property: type.name);
              case OperationType.manageData:
                return LazyVariantModel(
                    index: type.value,
                    layout: ManageDataOperation.layout,
                    property: type.name);
              case OperationType.bumpSequence:
                return LazyVariantModel(
                    index: type.value,
                    layout: BumpSequenceOperation.layout,
                    property: type.name);
              case OperationType.manageBuyOffer:
                return LazyVariantModel(
                    index: type.value,
                    layout: ManageBuyOfferOperation.layout,
                    property: type.name);
              case OperationType.pathPaymentStrictSend:
                return LazyVariantModel(
                    index: type.value,
                    layout: PathPaymentStrictSendOperation.layout,
                    property: type.name);
              case OperationType.createClaimableBalance:
                return LazyVariantModel(
                    index: type.value,
                    layout: CreateClaimableBalanceOperation.layout,
                    property: type.name);

              case OperationType.claimClaimableBalance:
                return LazyVariantModel(
                    index: type.value,
                    layout: ClaimClaimableBalanceOperation.layout,
                    property: type.name);
              case OperationType.beginSponsoringFutureReserves:
                return LazyVariantModel(
                    index: type.value,
                    layout: BeginSponsoringFutureReservesOperation.layout,
                    property: type.name);

              case OperationType.endSponsoringFutureReserves:
                return LazyVariantModel(
                    index: type.value,
                    layout: EndSponsoringFutureReservesOperation.layout,
                    property: type.name);

              case OperationType.revokeSponsorship:
                return LazyVariantModel(
                    index: type.value,
                    layout: RevokeSponsorshipOperation.layout,
                    property: type.name);
              case OperationType.clawback:
                return LazyVariantModel(
                    index: type.value,
                    layout: ClawbackOperation.layout,
                    property: type.name);
              case OperationType.clawbackClaimableBalance:
                return LazyVariantModel(
                    index: type.value,
                    layout: ClawbackClaimableBalanceOperation.layout,
                    property: type.name);
              case OperationType.setTrustLineFlags:
                return LazyVariantModel(
                    index: type.value,
                    layout: SetTrustLineFlagsOperation.layout,
                    property: type.name);
              case OperationType.liquidityPoolDeposit:
                return LazyVariantModel(
                    index: type.value,
                    layout: LiquidityPoolDepositOperation.layout,
                    property: type.name);
              case OperationType.liquidityPoolWithdraw:
                return LazyVariantModel(
                    index: type.value,
                    layout: LiquidityPoolWithdrawOperation.layout,
                    property: type.name);
              case OperationType.invokeHostFunction:
                return LazyVariantModel(
                    index: type.value,
                    layout: InvokeHostFunctionOperation.layout,
                    property: type.name);
              case OperationType.extendFootprintTtl:
                return LazyVariantModel(
                    index: type.value,
                    layout: ExtendFootprintTTLOperation.layout,
                    property: type.name);
              case OperationType.restoreFootprint:
                return LazyVariantModel(
                    index: type.value,
                    layout: RestoreFootprintOperation.layout,
                    property: type.name);
              default:
                throw const DartStellarPlugingException(
                    "Invalid Operation type.");
            }
          }),
          property: property);

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  String get variantName => operationType.name;

  T cast<T extends OperationBody>() {
    if (this is! T) {
      throw DartStellarPlugingException("Operation body casting failed.",
          details: {"excepted": "$T", "body": runtimeType.toString()});
    }
    return this as T;
  }
}

/// Send an amount in specified asset to a destination account.
/// Threshold: med
/// Result: PaymentResult
class PaymentOperation extends OperationBody {
  /// recipient of the payment
  final MuxedAccount destination;

  /// what they end up with
  final StellarAsset asset;

  /// amount they end up with
  final BigInt amount;
  PaymentOperation(
      {required this.destination, required this.asset, required BigInt amount})
      : amount = amount.asInt64,
        super(OperationType.payment);

  factory PaymentOperation.fromStruct(Map<String, dynamic> json) {
    return PaymentOperation(
        destination: MuxedAccount.fromStruct(json.asMap("destination")),
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        amount: json.as("amount"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedAccount.layout(property: "destination"),
      StellarAsset.layout(property: "asset"),
      LayoutConst.s64be(property: "amount")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "destination": destination.toVariantLayoutStruct(),
      "asset": asset.toVariantLayoutStruct(),
      "amount": amount
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "destination": destination.address.toString(),
      "asset": asset.toJson(),
      "amount": amount
    };
  }
}

/// Creates and funds a new account with the specified starting balance.
/// Threshold: med
/// Result: CreateAccountResult
class CreateAccountOperation extends OperationBody {
  /// account to create
  final StellarPublicKey destination;

  /// amount they end up with
  final BigInt startingBalance;
  CreateAccountOperation(
      {required this.destination, required BigInt startingBalance})
      : startingBalance = startingBalance.asInt64,
        super(OperationType.createAccount);

  factory CreateAccountOperation.fromStruct(Map<String, dynamic> json) {
    return CreateAccountOperation(
        destination: StellarPublicKey.fromStruct(json.asMap("destination")),
        startingBalance: json.as("startingBalance"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "destination"),
      LayoutConst.s64be(property: "startingBalance")
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
      "startingBalance": startingBalance
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "destination": destination.toAddress().toString(),
      "startingBalance": startingBalance
    };
  }
}

/// send an amount to a destination account through a path.
/// Threshold: med
/// Result: PathPaymentStrictReceiveResult
class PathPaymentStrictReceiveOperation extends OperationBody {
  /// asset we pay with
  final StellarAsset sendAsset;

  /// the maximum amount of sendAsset
  final BigInt sendMax;

  /// recipient of the payment
  final MuxedAccount destination;

  /// recipient of the payment
  final StellarAsset destAsset;

  /// amount they end up with
  final BigInt destAmount;

  /// additional hops it must go through to get there
  final List<StellarAsset> path;

  factory PathPaymentStrictReceiveOperation.fromStruct(
      Map<String, dynamic> json) {
    return PathPaymentStrictReceiveOperation(
      sendAsset: StellarAsset.fromStruct(json.asMap("sendAsset")),
      sendMax: json.as("sendMax"),
      destination: MuxedAccount.fromStruct(json.asMap("destination")),
      destAsset: StellarAsset.fromStruct(json.asMap("destAsset")),
      destAmount: json.as("destAmount"),
      path: json
          .asListOfMap("path")!
          .map((e) => StellarAsset.fromStruct(e))
          .toList(),
    );
  }
  PathPaymentStrictReceiveOperation(
      {required this.sendAsset,
      required BigInt sendMax,
      required this.destination,
      required this.destAsset,
      required BigInt destAmount,
      List<StellarAsset> path = const []})
      : sendMax = sendMax.asInt64,
        destAmount = destAmount.asInt64,
        path = path.immutable.max(5, name: "Path"),
        super(OperationType.pathPaymentStrictReceive);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "sendAsset"),
      LayoutConst.s64be(property: "sendMax"),
      MuxedAccount.layout(property: "destination"),
      StellarAsset.layout(property: "destAsset"),
      LayoutConst.s64be(property: "destAmount"),
      LayoutConst.xdrVec(StellarAsset.layout(), property: "path")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sendAsset": sendAsset.toVariantLayoutStruct(),
      "sendMax": sendMax,
      "destination": destination.toVariantLayoutStruct(),
      "destAsset": destAsset.toVariantLayoutStruct(),
      "destAmount": destAmount,
      "path": path.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "sendAsset": sendAsset.toJson(),
      "sendMax": sendMax,
      "destination": destination.address.toString(),
      "destAsset": destAsset.toJson(),
      "destAmount": destAmount,
      "path": path.map((e) => e.toJson()).toList()
    };
  }
}

/// Creates, updates or deletes an offer
/// Threshold: med
/// Result: ManageSellOfferResult
class ManageSellOfferOperation extends OperationBody {
  final StellarAsset selling;
  final StellarAsset buying;

  /// amount being sold. if set to 0, delete the offer
  final BigInt amount;

  /// price of thing being sold in terms of what you are buying
  final StellarPrice price;

  /// // 0=create a new offer, otherwise edit an existing offer
  final BigInt offerId;
  ManageSellOfferOperation(
      {required this.selling,
      required this.buying,
      required BigInt amount,
      required this.price,
      required BigInt offerId})
      : amount = amount.asInt64,
        offerId = offerId.asInt64,
        super(OperationType.manageSellOffer);
  factory ManageSellOfferOperation.fromStruct(Map<String, dynamic> json) {
    return ManageSellOfferOperation(
        selling: StellarAsset.fromStruct(json.asMap("selling")),
        buying: StellarAsset.fromStruct(json.asMap("buying")),
        amount: json.as("amount"),
        price: StellarPrice.fromStruct(json.asMap("price")),
        offerId: json.as("offerId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "selling"),
      StellarAsset.layout(property: "buying"),
      LayoutConst.s64be(property: "amount"),
      StellarPrice.layout(property: "price"),
      LayoutConst.s64be(property: "offerId"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "selling": selling.toVariantLayoutStruct(),
      "buying": buying.toVariantLayoutStruct(),
      "amount": amount,
      "price": price.toLayoutStruct(),
      "offerId": offerId
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "selling": selling.toJson(),
      "buying": buying.toJson(),
      "amount": amount,
      "price": price.toPrice(7),
      "offerId": offerId.toString()
    };
  }
}

/// Creates an offer that doesn't take offers of the same price
/// Threshold: med
/// Result: CreatePassiveSellOfferResult
class CreatePassiveSellOfferOperation extends OperationBody {
  /// A
  final StellarAsset selling;

  /// B
  final StellarAsset buying;

  /// amount taker gets
  final BigInt amount;

  /// cost of A in terms of B
  final StellarPrice price;

  CreatePassiveSellOfferOperation({
    required this.selling,
    required this.buying,
    required BigInt amount,
    required this.price,
  })  : amount = amount.asInt64,
        super(OperationType.createPassiveSellOffer);
  factory CreatePassiveSellOfferOperation.fromStruct(
      Map<String, dynamic> json) {
    return CreatePassiveSellOfferOperation(
      selling: StellarAsset.fromStruct(json.asMap("selling")),
      buying: StellarAsset.fromStruct(json.asMap("buying")),
      amount: json.as("amount"),
      price: StellarPrice.fromStruct(json.asMap("price")),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "selling"),
      StellarAsset.layout(property: "buying"),
      LayoutConst.s64be(property: "amount"),
      StellarPrice.layout(property: "price"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "selling": selling.toVariantLayoutStruct(),
      "buying": buying.toVariantLayoutStruct(),
      "amount": amount,
      "price": price.toLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "selling": selling.toJson(),
      "buying": buying.toJson(),
      "amount": amount,
      "price": price.toPrice(7)
    };
  }
}

/// Set Account Options
/// updates "AccountEntry" fields.
/// note: updating thresholds or signers requires high threshold
/// Threshold: med or high
/// Result: SetOptionsResult
class SetOptionsOperation extends OperationBody {
  /// sets the inflation destinationf
  final StellarPublicKey? inflationDest;

  /// which flags to clear
  final AuthFlag? clearFlags;

  /// which flags to set
  final AuthFlag? setFlags;

  /// account threshold manipulation
  final int? masterWeight;
  final int? lowThreshold;
  final int? medThreshold;
  final int? highThreshold;

  /// sets the home domain
  final String? homeDomain;

  /// Add, update or remove a signer for the account
  /// signer is deleted if the weight is 0
  final Signer? signer;
  factory SetOptionsOperation.fromStruct(Map<String, dynamic> json) {
    return SetOptionsOperation(
        inflationDest: json.mybeAs<StellarPublicKey, Map<String, dynamic>>(
            key: "inflationDest",
            onValue: (e) => StellarPublicKey.fromStruct(e)),
        clearFlags: json.mybeAs<AuthFlag, int>(
            key: "clearFlags", onValue: (e) => AuthFlag.fromValue(e)),
        setFlags: json.mybeAs<AuthFlag, int>(
            key: "setFlags", onValue: (e) => AuthFlag.fromValue(e)),
        masterWeight: json.as("masterWeight"),
        highThreshold: json.as("highThreshold"),
        lowThreshold: json.as("lowThreshold"),
        medThreshold: json.as("medThreshold"),
        homeDomain: json.as("homeDomain"),
        signer: json.mybeAs<Signer, Map<String, dynamic>>(
            key: "signer", onValue: (e) => Signer.fromStruct(e)));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.optionalU32Be(StellarPublicKey.layout(),
          property: "inflationDest"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "clearFlags"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "setFlags"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "masterWeight"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "lowThreshold"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "medThreshold"),
      LayoutConst.optionalU32Be(LayoutConst.u32be(), property: "highThreshold"),
      LayoutConst.optionalU32Be(LayoutConst.xdrString(),
          property: "homeDomain"),
      LayoutConst.optionalU32Be(Signer.layout(), property: "signer"),
    ], property: property);
  }

  SetOptionsOperation(
      {this.inflationDest,
      this.clearFlags,
      this.setFlags,
      int? masterWeight,
      int? lowThreshold,
      int? medThreshold,
      int? highThreshold,
      this.homeDomain,
      this.signer})
      : masterWeight = masterWeight?.asUint32,
        lowThreshold = lowThreshold?.asUint32,
        medThreshold = medThreshold?.asUint32,
        highThreshold = highThreshold?.asUint32,
        super(OperationType.setOptions);

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "inflationDest": inflationDest?.toLayoutStruct(),
      "clearFlags": clearFlags?.value,
      "setFlags": setFlags?.value,
      "masterWeight": masterWeight,
      "lowThreshold": lowThreshold,
      "medThreshold": medThreshold,
      "highThreshold": highThreshold,
      "homeDomain": homeDomain,
      "signer": signer?.toLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "inflationDest": inflationDest?.toAddress().toString(),
      "clearFlags": clearFlags?.value,
      "setFlags": setFlags?.value,
      "masterWeight": masterWeight,
      "lowThreshold": lowThreshold,
      "medThreshold": medThreshold,
      "highThreshold": highThreshold,
      "homeDomain": homeDomain,
      "signer": signer?.toJson()
    };
  }

  @override
  OperationLevel get level => OperationLevel.high;
}

/// with pool asset
typedef ChangeTrustAsset = StellarAsset;

/// Creates, updates or deletes a trust line
/// Threshold: med
/// Result: ChangeTrustResult
class ChangeTrustOperation extends OperationBody {
  final ChangeTrustAsset asset;

  /// if limit is set to 0, deletes the trust line
  final BigInt limit;
  ChangeTrustOperation({required this.asset, required BigInt limit})
      : limit = limit.asInt64,
        super(OperationType.changeTrust);
  factory ChangeTrustOperation.fromStruct(Map<String, dynamic> json) {
    return ChangeTrustOperation(
        asset: ChangeTrustAsset.fromStruct(json.asMap("asset")),
        limit: json.as("limit"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ChangeTrustAsset.layout(property: "asset"),
      LayoutConst.s64be(property: "limit"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"asset": asset.toVariantLayoutStruct(), "limit": limit};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"asset": asset.toJson(), "limit": limit.toString()};
  }
}

/// Updates the "authorized" flag of an existing trust line
/// this is called by the issuer of the related asset.
///
///  note that authorize can only be set (and not cleared) if
///  the issuer account does not have the AUTH_REVOCABLE_FLAG set
///
///  Threshold: low
///  Result: AllowTrustResult
class AllowTrustOperation extends OperationBody {
  final StellarPublicKey trustor;
  final AssetCode asset;

  ///  One of 0, AUTHORIZED_FLAG, or AUTHORIZED_TO_MAINTAIN_LIABILITIES_FLAG
  final TrustAuthFlag authorize;
  AllowTrustOperation(
      {required this.trustor, required this.asset, required this.authorize})
      : super(OperationType.allowTrust);
  factory AllowTrustOperation.fromStruct(Map<String, dynamic> json) {
    return AllowTrustOperation(
        trustor: StellarPublicKey.fromStruct(json.asMap("trustor")),
        asset: AssetCode.fromStruct(json.asMap("asset")),
        authorize: TrustAuthFlag.fromValue(json.as("authorize")));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "trustor"),
      AssetCode.layout(property: "asset"),
      LayoutConst.u32be(property: "authorize")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "trustor": trustor.toLayoutStruct(),
      "asset": asset.toVariantLayoutStruct(),
      "authorize": authorize.value
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "trustor": trustor.toAddress().toString(),
      "asset": asset.toJson(),
      "authorize": authorize.name
    };
  }

  @override
  OperationLevel get level => OperationLevel.low;
}

/// AccountMerge
/// Transfers native balance to destination account.
/// Threshold: high
/// Result : AccountMergeResult
class AccountMergeOperation extends OperationBody {
  final MuxedAccount account;
  AccountMergeOperation(this.account) : super(OperationType.accountMerge);
  factory AccountMergeOperation.fromStruct(Map<String, dynamic> json) {
    return AccountMergeOperation(
        MuxedAccount.fromStruct(json.asMap("account")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      MuxedAccount.layout(property: "account"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"account": account.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"account": account.address.toScAddress()};
  }

  @override
  OperationLevel get level => OperationLevel.high;
}

/// Inflation Runs inflation
/// Threshold: low
/// Result: InflationResult
class InflationOperation extends OperationBody {
  InflationOperation() : super(OperationType.inflation);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.noArgs(property: property);
  }

  factory InflationOperation.fromStruct(Map<String, dynamic> json) {
    return InflationOperation();
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
  OperationLevel get level => OperationLevel.low;
}

/// Adds, Updates, or Deletes a key value pair associated with a particular account.
/// Threshold: med
/// Result: ManageDataResult
class ManageDataOperation extends OperationBody {
  final String dataName;

  /// set to null to clear
  final List<int>? dataValue;
  ManageDataOperation({required String dataName, List<int>? dataValue})
      : dataValue = dataValue?.asImmutableBytes
            .max(StellarConst.dataValueLength, name: "dataValue"),
        dataName = dataName.max(StellarConst.str64),
        super(OperationType.manageData);

  factory ManageDataOperation.fromStruct(Map<String, dynamic> json) {
    return ManageDataOperation(
        dataName: json.as("dataName"), dataValue: json.asBytes("dataValue"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: "dataName"),
      LayoutConst.optionalU32Be(LayoutConst.xdrVecBytes(),
          property: "dataValue"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"dataName": dataName, "dataValue": dataValue};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "dataName": dataName,
      "dataValue": BytesUtils.tryToHexString(dataValue)
    };
  }
}

/// Bump Sequence
/// increases the sequence to a given level
/// Threshold: low
/// Result: BumpSequenceResult
class BumpSequenceOperation extends OperationBody {
  final BigInt bumpTo;
  BumpSequenceOperation(BigInt bumpTo)
      : bumpTo = bumpTo.asInt64,
        super(OperationType.bumpSequence);
  factory BumpSequenceOperation.fromStruct(Map<String, dynamic> json) {
    return BumpSequenceOperation(json.as("bumpTo"));
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.s64be(property: "bumpTo"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"bumpTo": bumpTo};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"bumpTo": bumpTo};
  }

  @override
  OperationLevel get level => OperationLevel.low;
}

/// Creates, updates or deletes an offer with amount in terms of buying asset
/// Threshold: med
/// Result: ManageBuyOfferResult
class ManageBuyOfferOperation extends OperationBody {
  final StellarAsset selling;
  final StellarAsset buying;

  /// amount being bought. if set to 0, delete the offer
  final BigInt buyAmount;

  /// price of thing being bought in terms of what you are selling
  final StellarPrice price;

  /// 0=create a new offer, otherwise edit an existing offer
  final BigInt offerId;
  ManageBuyOfferOperation(
      {required this.selling,
      required this.buying,
      required BigInt buyAmount,
      required this.price,
      required BigInt offerId})
      : buyAmount = buyAmount.asInt64,
        offerId = offerId.asInt64,
        super(OperationType.manageBuyOffer);
  factory ManageBuyOfferOperation.fromStruct(Map<String, dynamic> json) {
    return ManageBuyOfferOperation(
        buyAmount: json.as("buyAmount"),
        buying: StellarAsset.fromStruct(json.asMap("buying")),
        selling: StellarAsset.fromStruct(json.asMap("selling")),
        price: StellarPrice.fromStruct(json.asMap("price")),
        offerId: json.as("offerId"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "selling"),
      StellarAsset.layout(property: "buying"),
      LayoutConst.s64be(property: "buyAmount"),
      StellarPrice.layout(property: "price"),
      LayoutConst.s64be(property: "offerId"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "selling": selling.toVariantLayoutStruct(),
      "buying": buying.toVariantLayoutStruct(),
      "buyAmount": buyAmount,
      "price": price.toLayoutStruct(),
      "offerId": offerId
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "selling": selling.toJson(),
      "buying": buying.toJson(),
      "buyAmount": buyAmount.toString(),
      "price": price.toPrice(),
      "offerId": offerId.toString()
    };
  }
}

/// send an amount to a destination account through a path.
/// Threshold: med
/// Result: PathPaymentStrictSendResult
class PathPaymentStrictSendOperation extends OperationBody {
  /// asset we pay with
  final StellarAsset sendAsset;

  /// amount of sendAsset to send (excluding fees)
  final BigInt sendAmount;

  /// recipient of the payment
  final MuxedAccount destination;
  final StellarAsset destAsset;
  final BigInt destMin;

  /// additional hops it must go through to get there
  final List<StellarAsset> path;
  factory PathPaymentStrictSendOperation.fromStruct(Map<String, dynamic> json) {
    return PathPaymentStrictSendOperation(
        sendAmount: json.as("sendAmount"),
        destMin: json.as("destMin"),
        sendAsset: StellarAsset.fromStruct(json.asMap("sendAsset")),
        destAsset: StellarAsset.fromStruct(json.asMap("destAsset")),
        destination: MuxedAccount.fromStruct(json.asMap("destination")),
        path: json
            .asListOfMap("path")!
            .map((e) => StellarAsset.fromStruct(e))
            .toList());
  }

  PathPaymentStrictSendOperation({
    required this.sendAsset,
    required BigInt sendAmount,
    required this.destination,
    required this.destAsset,
    required BigInt destMin,
    List<StellarAsset> path = const [],
  })  : sendAmount = sendAmount.asInt64,
        destMin = destMin.asInt64,
        path = path.immutable.max(5, name: "Path"),
        super(OperationType.pathPaymentStrictSend);
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "sendAsset"),
      LayoutConst.s64be(property: "sendAmount"),
      MuxedAccount.layout(property: "destination"),
      StellarAsset.layout(property: "destAsset"),
      LayoutConst.s64be(property: "destMin"),
      LayoutConst.xdrVec(StellarAsset.layout(), property: "path")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "sendAsset": sendAsset.toVariantLayoutStruct(),
      "sendAmount": sendAmount,
      "destination": destination.toVariantLayoutStruct(),
      "destAsset": destAsset.toVariantLayoutStruct(),
      "destMin": destMin,
      "path": path.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "sendAsset": sendAsset.toJson(),
      "sendAmount": sendAmount.toString(),
      "destination": destination.address.toString(),
      "destAsset": destAsset.toJson(),
      "destMin": destMin.toString(),
      "path": path.map((e) => e.toJson()).toList()
    };
  }
}

/// Creates a claimable balance entry
/// Threshold: med
/// Result: CreateClaimableBalanceResult
class CreateClaimableBalanceOperation extends OperationBody {
  final StellarAsset asset;
  final BigInt amount;
  final List<Claimant> claimants;
  CreateClaimableBalanceOperation(
      {required this.asset,
      required BigInt amount,
      required List<Claimant> claimants})
      : amount = amount.asInt64,
        claimants = claimants.immutable
            .max(10, name: "claimants")
            .min(1, name: "claimants"),
        super(OperationType.createClaimableBalance);
  factory CreateClaimableBalanceOperation.fromStruct(
      Map<String, dynamic> json) {
    return CreateClaimableBalanceOperation(
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        amount: json.as("amount"),
        claimants: json
            .asListOfMap("claimants")!
            .map((e) => Claimant.fromStruct(e))
            .toList());
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "asset"),
      LayoutConst.s64be(property: "amount"),
      LayoutConst.xdrVec(Claimant.layout(), property: "claimants")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "asset": asset.toVariantLayoutStruct(),
      "amount": amount,
      "claimants": claimants.map((e) => e.toVariantLayoutStruct()).toList()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "asset": asset.toJson(),
      "amount": amount.toString(),
      "claimants": claimants.map((e) => e.toJson()).toList()
    };
  }
}

/// Claims a claimable balance entry
/// Threshold: low
/// Result: ClaimClaimableBalanceResult
class ClaimClaimableBalanceOperation extends OperationBody {
  final ClaimableBalanceId balanceID;
  factory ClaimClaimableBalanceOperation.fromStruct(Map<String, dynamic> json) {
    return ClaimClaimableBalanceOperation(
        ClaimableBalanceId.fromStruct(json.asMap("balanceID")));
  }
  ClaimClaimableBalanceOperation(this.balanceID)
      : super(OperationType.claimClaimableBalance);

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [ClaimableBalanceId.layout(property: "balanceID")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"balanceID": balanceID.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"balanceID": balanceID.toJson()};
  }

  @override
  OperationLevel get level => OperationLevel.low;
}

/// BeginSponsoringFutureReserves
/// Establishes the is-sponsoring-future-reserves-for relationship between
/// the source account and sponsoredID
/// Threshold: med
/// Result: BeginSponsoringFutureReservesResult
class BeginSponsoringFutureReservesOperation extends OperationBody {
  final StellarPublicKey sponsoredId;
  const BeginSponsoringFutureReservesOperation(this.sponsoredId)
      : super(OperationType.beginSponsoringFutureReserves);
  factory BeginSponsoringFutureReservesOperation.fromStruct(
      Map<String, dynamic> json) {
    return BeginSponsoringFutureReservesOperation(
        StellarPublicKey.fromStruct(json.asMap("sponsoredId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [StellarPublicKey.layout(property: "sponsoredId")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"sponsoredId": sponsoredId.toLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"sponsoredId": sponsoredId.toAddress().toString()};
  }
}

class EndSponsoringFutureReservesOperation extends OperationBody {
  const EndSponsoringFutureReservesOperation()
      : super(OperationType.endSponsoringFutureReserves);
  factory EndSponsoringFutureReservesOperation.fromStruct(
      Map<String, dynamic> json) {
    return const EndSponsoringFutureReservesOperation();
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

/// If source account is not sponsored or is sponsored by the owner of the
/// specified entry or sub-entry, then attempt to revoke the sponsorship.
/// If source account is sponsored, then attempt to transfer the sponsorship
/// to the sponsor of source account.
/// Threshold: med
/// Result: RevokeSponsorshipResult
class RevokeSponsorshipOperation extends OperationBody {
  final RevokeSponsorship revokeSponsorship;
  const RevokeSponsorshipOperation(this.revokeSponsorship)
      : super(OperationType.revokeSponsorship);
  factory RevokeSponsorshipOperation.fromStruct(Map<String, dynamic> json) {
    return RevokeSponsorshipOperation(
        RevokeSponsorship.fromStruct(json.asMap("revokeSponsorship")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct(
        [RevokeSponsorship.layout(property: "revokeSponsorship")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"revokeSponsorship": revokeSponsorship.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"revokeSponsorship": revokeSponsorship.toJson()};
  }
}

/// Claws back an amount of an asset from an account
/// Threshold: med
/// Result: ClawbackResult
class ClawbackOperation extends OperationBody {
  final StellarAsset asset;
  final MuxedAccount from;
  final BigInt amount;
  ClawbackOperation(
      {required this.asset, required this.from, required BigInt amount})
      : amount = amount.asInt64,
        super(OperationType.clawback);
  factory ClawbackOperation.fromStruct(Map<String, dynamic> json) {
    return ClawbackOperation(
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        amount: json.as("amount"),
        from: MuxedAccount.fromStruct(json.asMap("from")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarAsset.layout(property: "asset"),
      MuxedAccount.layout(property: "from"),
      LayoutConst.s64be(property: "amount")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "asset": asset.toVariantLayoutStruct(),
      "from": from.toVariantLayoutStruct(),
      "amount": amount,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "asset": asset.toJson(),
      "from": from.address.toString(),
      "amount": amount.toString(),
    };
  }
}

/// Claws back a claimable balance
/// Threshold: med
/// Result: ClawbackClaimableBalanceResult
class ClawbackClaimableBalanceOperation extends OperationBody {
  final ClaimableBalanceId balanceId;
  const ClawbackClaimableBalanceOperation(this.balanceId)
      : super(OperationType.clawbackClaimableBalance);
  factory ClawbackClaimableBalanceOperation.fromStruct(
      Map<String, dynamic> json) {
    return ClawbackClaimableBalanceOperation(
        ClaimableBalanceId.fromStruct(json.asMap("balanceId")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ClaimableBalanceId.layout(property: "balanceId"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"balanceId": balanceId.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"balanceId": balanceId.toJson()};
  }
}

///  SetTrustLineFlagsOp
///  Updates the flags of an existing trust line.
///  This is called by the issuer of the related asset.
///  Threshold: low
///  Result: SetTrustLineFlagsResult
class SetTrustLineFlagsOperation extends OperationBody {
  final StellarPublicKey trustor;
  final StellarAsset asset;
  final TrustLineFlag clearFlags;
  final TrustLineFlag setFlags;

  SetTrustLineFlagsOperation(
      {required this.trustor,
      required this.asset,
      required this.clearFlags,
      required this.setFlags})
      : super(OperationType.setTrustLineFlags);
  factory SetTrustLineFlagsOperation.fromStruct(Map<String, dynamic> json) {
    return SetTrustLineFlagsOperation(
        asset: StellarAsset.fromStruct(json.asMap("asset")),
        trustor: StellarPublicKey.fromStruct(json.asMap("trustor")),
        clearFlags: TrustLineFlag.fromValue(json.as("clearFlags")),
        setFlags: TrustLineFlag.fromValue(json.as("setFlags")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      StellarPublicKey.layout(property: "trustor"),
      StellarAsset.layout(property: "asset"),
      LayoutConst.u32be(property: "clearFlags"),
      LayoutConst.u32be(property: "setFlags"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "trustor": trustor.toLayoutStruct(),
      "asset": asset.toVariantLayoutStruct(),
      "clearFlags": clearFlags.value,
      "setFlags": setFlags.value
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "trustor": trustor.toAddress().toString(),
      "asset": asset.toJson(),
      "clearFlags": clearFlags.name,
      "setFlags": setFlags.name
    };
  }

  @override
  OperationLevel get level => OperationLevel.low;
}

/// Deposit assets into a liquidity pool
/// Threshold: med
/// Result: LiquidityPoolDepositResult
class LiquidityPoolDepositOperation extends OperationBody {
  final List<int> liquidityPoolId;
  final BigInt maxAmountA;
  final BigInt maxAmountB;
  final StellarPrice minPrice;
  final StellarPrice maxPrice;

  LiquidityPoolDepositOperation(
      {required List<int> liquidityPoolId,
      required BigInt maxAmountA,
      required BigInt maxAmountB,
      required this.minPrice,
      required this.maxPrice})
      : liquidityPoolId = liquidityPoolId.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "liquidityPoolId"),
        maxAmountA = maxAmountA.asInt64,
        maxAmountB = maxAmountB.asInt64,
        super(OperationType.liquidityPoolDeposit);
  factory LiquidityPoolDepositOperation.fromStruct(Map<String, dynamic> json) {
    return LiquidityPoolDepositOperation(
      liquidityPoolId: json.asBytes("liquidityPoolId"),
      maxAmountA: json.as("maxAmountA"),
      maxAmountB: json.as("maxAmountB"),
      minPrice: StellarPrice.fromStruct(json.asMap("minPrice")),
      maxPrice: StellarPrice.fromStruct(json.asMap("maxPrice")),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "liquidityPoolId"),
      LayoutConst.s64be(property: "maxAmountA"),
      LayoutConst.s64be(property: "maxAmountB"),
      StellarPrice.layout(property: "minPrice"),
      StellarPrice.layout(property: "maxPrice")
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
      "maxAmountA": maxAmountA,
      "maxAmountB": maxAmountB,
      "minPrice": minPrice.toLayoutStruct(),
      "maxPrice": maxPrice.toLayoutStruct()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "liquidityPoolId": BytesUtils.toHexString(liquidityPoolId, prefix: "0x"),
      "maxAmountA": maxAmountA.toString(),
      "maxAmountB": maxAmountB.toString(),
      "minPrice": minPrice.toPrice(7),
      "maxPrice": maxPrice.toPrice(7)
    };
  }
}

/// Withdraw assets from a liquidity pool
/// Threshold: med
/// Result: LiquidityPoolWithdrawResult
class LiquidityPoolWithdrawOperation extends OperationBody {
  final List<int> liquidityPoolId;
  final BigInt amount;
  final BigInt minAmountA;
  final BigInt minAmountB;

  LiquidityPoolWithdrawOperation({
    required List<int> liquidityPoolId,
    required BigInt amount,
    required BigInt minAmountA,
    required BigInt minAmountB,
  })  : liquidityPoolId = liquidityPoolId.asImmutableBytes
            .exc(StellarConst.hash256Length, name: "liquidityPoolId"),
        amount = amount.asInt64,
        minAmountA = minAmountA.asInt64,
        minAmountB = minAmountB.asInt64,
        super(OperationType.liquidityPoolWithdraw);
  factory LiquidityPoolWithdrawOperation.fromStruct(Map<String, dynamic> json) {
    return LiquidityPoolWithdrawOperation(
      liquidityPoolId: json.asBytes("liquidityPoolId"),
      amount: json.as("amount"),
      minAmountA: json.as("minAmountA"),
      minAmountB: json.as("minAmountB"),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.fixedBlobN(StellarConst.hash256Length,
          property: "liquidityPoolId"),
      LayoutConst.s64be(property: "amount"),
      LayoutConst.s64be(property: "minAmountA"),
      LayoutConst.s64be(property: "minAmountB"),
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
      "amount": amount,
      "minAmountA": minAmountA,
      "minAmountB": minAmountB,
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "liquidityPoolId": BytesUtils.toHexString(liquidityPoolId, prefix: "0x"),
      "amount": amount.toString(),
      "minAmountA": minAmountA.toString(),
      "minAmountB": minAmountB.toString(),
    };
  }
}

/// Upload Wasm, create, and invoke contracts in Soroban.
/// Threshold: med
/// Result: InvokeHostFunctionResult
class InvokeHostFunctionOperation extends OperationBody {
  /// Host function to invoke.
  final HostFunction hostFunction;

  /// Per-address authorizations for this host function.
  final List<SorobanAuthorizationEntry> auth;
  InvokeHostFunctionOperation(
      {required this.hostFunction,
      List<SorobanAuthorizationEntry> auth = const []})
      : auth = auth.immutable,
        super(OperationType.invokeHostFunction);
  factory InvokeHostFunctionOperation.fromStruct(Map<String, dynamic> json) {
    return InvokeHostFunctionOperation(
        hostFunction: HostFunction.fromStruct(json.asMap("hostFunction")),
        auth: json
            .asListOfMap("auth")!
            .map((e) => SorobanAuthorizationEntry.fromStruct(e))
            .toList());
  }

  InvokeHostFunctionOperation copyWith(
      {HostFunction? hostFunction, List<SorobanAuthorizationEntry>? auth}) {
    return InvokeHostFunctionOperation(
        hostFunction: hostFunction ?? this.hostFunction,
        auth: auth ?? this.auth);
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      HostFunction.layout(property: "hostFunction"),
      LayoutConst.xdrVec(SorobanAuthorizationEntry.layout(), property: "auth")
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      "hostFunction": hostFunction.toVariantLayoutStruct(),
      "auth": auth.map((e) => e.toLayoutStruct()).toList()
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "hostFunction": hostFunction.toJson(),
      "auth": auth.map((e) => e.toJson()).toList()
    };
  }
}

/// Extend the TTL of the entries specified in the readOnly footprint
/// so they will live at least extendTo ledgers from lcl.
/// Threshold: low
/// Result: ExtendFootprintTTLResult
class ExtendFootprintTTLOperation extends OperationBody {
  final ExtentionPointVoid ext;
  final int extendTo;
  ExtendFootprintTTLOperation(
      {required int extendTo, this.ext = const ExtentionPointVoid()})
      : extendTo = extendTo.asUint32,
        super(OperationType.extendFootprintTtl);
  factory ExtendFootprintTTLOperation.fromStruct(Map<String, dynamic> json) {
    return ExtendFootprintTTLOperation(
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")),
        extendTo: json.as("extendTo"));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ExtentionPointVoid.layout(property: "ext"),
      LayoutConst.u32be(property: "extendTo"),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"extendTo": extendTo, "ext": ext.toVariantLayoutStruct()};
  }

  @override
  Map<String, dynamic> toJson() {
    return {"extendTo": extendTo};
  }

  @override
  OperationLevel get level => OperationLevel.low;
}

/// Restore the archived entries specified in the readWrite footprint.
/// Threshold: low
/// Result: RestoreFootprintOp
class RestoreFootprintOperation extends OperationBody {
  final ExtentionPointVoid ext;
  RestoreFootprintOperation({this.ext = const ExtentionPointVoid()})
      : super(OperationType.restoreFootprint);

  factory RestoreFootprintOperation.fromStruct(Map<String, dynamic> json) {
    return RestoreFootprintOperation(
        ext: ExtentionPointVoid.fromStruct(json.asMap("ext")));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([ExtentionPointVoid.layout(property: "ext")],
        property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"ext": ext.toVariantLayoutStruct()};
  }

  @override
  OperationLevel get level => OperationLevel.low;
}
