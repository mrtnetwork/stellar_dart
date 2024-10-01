import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/serialization/serialization.dart';
import 'package:stellar_dart/src/utils/validator.dart';

/// Represents a Stellar public key using the Ed25519 cryptographic system.
/// Extends `XDRSerialization` for XDR serialization/deserialization support.
class StellarPublicKey extends XDRSerialization {
  /// The underlying Ed25519 public key.
  final Ed25519PublicKey _publicKey;

  /// Private constructor that accepts an `Ed25519PublicKey`.
  const StellarPublicKey._(this._publicKey);

  /// Creates a `StellarPublicKey` from a raw byte array.
  ///
  /// The byte array must represent a valid Ed25519 public key.
  factory StellarPublicKey.fromPublicBytes(List<int> bytes) {
    return StellarPublicKey._(Ed25519PublicKey.fromBytes(bytes));
  }

  /// Creates a `StellarPublicKey` from a `StellarAddress`.
  ///
  /// The `StellarAddress` must be of type `XlmAddrTypes.pubKey` or `XlmAddrTypes.muxed`,
  /// otherwise an exception is thrown.
  factory StellarPublicKey.fromAddress(StellarAddress address) {
    if (address.type != XlmAddrTypes.pubKey &&
        address.type != XlmAddrTypes.muxed) {
      throw DartStellarPlugingException(
          "Only Stellar ED25519 public key address (XlmAddrTypes.pubKey, XlmAddrTypes.muxed) can be converted to `StellarPublicKey`.",
          details: {"type": address.type.name});
    }
    return StellarPublicKey.fromPublicBytes(address.keyBytes());
  }

  /// Creates a `StellarPublicKey` from XDR bytes.
  ///
  /// Optionally accepts a `property` for specifying a custom layout.
  factory StellarPublicKey.fromXdr(List<int> bytes, {String? property}) {
    final decode = XDRSerialization.deserialize(
        bytes: bytes, layout: layout(property: property));
    return StellarPublicKey.fromStruct(decode);
  }

  /// Creates a `StellarPublicKey` from a structured JSON map.
  ///
  /// The `json` must include a valid type and `ed25519` public key.
  factory StellarPublicKey.fromStruct(Map<String, dynamic> json) {
    final int type = json.as("type");
    if (type != 0) {
      throw const DartStellarPlugingException(
          "Invalid StellarPublicKey XDR bytes.");
    }
    return StellarPublicKey.fromPublicBytes(json.asBytes("ed25519"));
  }

  /// Defines the layout for XDR serialization/deserialization.
  ///
  /// This layout includes a type field and a fixed 32-byte Ed25519 public key field.
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: "type"),
      LayoutConst.fixedBlob32(property: "ed25519")
    ], property: property);
  }

  /// Converts the `StellarPublicKey` to a `StellarAccountAddress`.
  StellarAccountAddress toAddress() {
    return StellarAccountAddress.fromPublicKey(toBytes());
  }

  /// Creates the layout for serialization with an optional `property`.
  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  /// Converts the public key into a structured map for serialization.
  @override
  Map<String, dynamic> toLayoutStruct() {
    return {"type": 0, "ed25519": _publicKey.compressed.sublist(1)};
  }

  /// Returns the public key as a byte array.
  List<int> toBytes() {
    return _publicKey.compressed.sublist(1);
  }

  /// Returns the key hint, which is the last few bytes of the public key.
  List<int> hint() {
    final bytes = toBytes();
    return bytes.sublist(bytes.length - StellarConst.pubkeyHintBytesLength);
  }

  /// Converts the `StellarPublicKey` into a `MuxedAccount`.
  MuxedAccount toMuxedAccount() {
    return MuxedAccount.fromPublicKey(this);
  }

  /// Verifies a signature using the public key.
  ///
  /// Requires a `digest` (the hashed data) and the `signature` to verify.
  bool verify({required List<int> digest, required List<int> signature}) {
    final verifier = SolanaVerifier.fromKeyBytes(toBytes());
    return verifier.verify(digest, signature);
  }

  /// Equality operator that checks if two `StellarPublicKey` objects are equal.
  @override
  operator ==(other) {
    if (other is! StellarPublicKey) return false;
    return _publicKey == other._publicKey;
  }

  /// Returns a hash code for the `StellarPublicKey`.
  @override
  int get hashCode => _publicKey.hashCode;
}
