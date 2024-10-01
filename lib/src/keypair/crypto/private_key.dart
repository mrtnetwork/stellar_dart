import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/keypair/crypto/public_key.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

/// Represents a Stellar private key using the Ed25519 cryptographic system.
class StellarPrivateKey {
  /// The underlying Ed25519 private key.
  final Ed25519PrivateKey _privateKey;

  /// Private constructor that accepts an `Ed25519PrivateKey`.
  const StellarPrivateKey._(this._privateKey);

  /// Creates a `StellarPrivateKey` from a raw byte array.
  ///
  /// The byte array must represent a valid Ed25519 private key.
  factory StellarPrivateKey.fromBytes(List<int> bytes) {
    return StellarPrivateKey._(Ed25519PrivateKey.fromBytes(bytes));
  }

  /// Creates a `StellarPrivateKey` from a hexadecimal string.
  ///
  /// The hex string must represent a valid Ed25519 private key.
  factory StellarPrivateKey.fromHex(String secretKey) {
    return StellarPrivateKey.fromBytes(BytesUtils.fromHexString(secretKey));
  }

  /// Creates a `StellarPrivateKey` from a base32 encoded string.
  ///
  /// This method decodes a base32 Stellar secret key (private key) and
  /// returns a `StellarPrivateKey` instance.
  ///
  /// Throws a `DartStellarPlugingException` if the secret key is invalid.
  factory StellarPrivateKey.fromBase32(String secretKey) {
    try {
      final key = XlmAddrDecoder()
          .decode(secretKey, {"addr_type": XlmAddrTypes.privKey});
      if (key.type != XlmAddrTypes.privKey) {
        throw const DartStellarPlugingException("Invalid key type.");
      }
      return StellarPrivateKey.fromBytes(key.pubKeyBytes);
    } catch (e) {
      throw DartStellarPlugingException("Invalid base32 secret key.",
          details: {"message": e.toString()});
    }
  }

  /// Returns the corresponding `StellarPublicKey` for the current private key.
  StellarPublicKey toPublicKey() {
    return StellarPublicKey.fromPublicBytes(_privateKey.publicKey.compressed);
  }

  /// Returns the private key as a raw byte array.
  List<int> toBytes() {
    return _privateKey.raw;
  }

  /// Returns the private key as a hexadecimal string.
  String toHex() {
    return _privateKey.toHex(prefix: "0x");
  }

  /// Returns the private key as a base32 encoded string.
  ///
  /// This method encodes the raw private key bytes into base32 format.
  String toBase32() {
    return XlmAddrEncoder()
        .encodeKey(toBytes(), {"addr_type": XlmAddrTypes.privKey});
  }

  /// Signs the given `message` (as a list of bytes) with the private key.
  ///
  /// Returns a `DecoratedSignature`, which includes the signature and the key hint.
  DecoratedSignature sign(List<int> message) {
    final signer = SolanaSigner.fromKeyBytes(_privateKey.raw);
    final sign = signer.sign(message);
    final hint = toPublicKey().hint();
    return DecoratedSignature(hint: hint, signature: sign);
  }
}
