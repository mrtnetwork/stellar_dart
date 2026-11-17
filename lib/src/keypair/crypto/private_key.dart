import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/keypair/crypto/public_key.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

/// Represents a Stellar private key using the Ed25519 cryptographic system.
class StellarPrivateKey with SecretState {
  /// The underlying Ed25519 private key.
  final ED25519PrivateKey privateKey;

  /// Private constructor that accepts an `Ed25519PrivateKey`.
  const StellarPrivateKey(this.privateKey);

  /// Creates a `StellarPrivateKey` from a raw byte array.
  ///
  /// The byte array must represent a valid Ed25519 private key.
  factory StellarPrivateKey.fromBytes(List<int> bytes) {
    return StellarPrivateKey(ED25519PrivateKey.fromBytes(bytes));
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
  /// Throws a `BuError` if the secret key is invalid.
  factory StellarPrivateKey.fromBase32(String secretKey) {
    try {
      final key = XlmAddrDecoder().decode(
        secretKey,
        addrType: XlmAddrTypes.privKey,
      );
      if (key.type != XlmAddrTypes.privKey) {
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid key type.',
        );
      }
      return StellarPrivateKey.fromBytes(key.pubKeyBytes);
    } catch (e) {
      throw BuError(
        DefaultErrorType.badBase32,
        'Invalid base32 secret key.',
        details: {'message': e.toString()},
      );
    }
  }

  /// Returns the corresponding `StellarPublicKey` for the current private key.
  StellarPublicKey toPublicKey() {
    return StellarPublicKey(privateKey.publicKey);
  }

  /// Returns the private key as a raw byte array.
  SecretBytes toBytes() {
    return privateKey.toBytes();
  }

  /// Returns the private key as a hexadecimal string.
  String toHex() {
    return privateKey.takeSecretKey().toHex(prefix: '0x');
  }

  /// Returns the private key as a base32 encoded string.
  ///
  /// This method encodes the raw private key bytes into base32 format.
  String toBase32() {
    return privateKey.takeSecretKey().useValue(
      (k) => XlmAddrEncoder().encodeKey(k, addrType: XlmAddrTypes.privKey),
    );
  }

  /// Signs the given `message` (as a list of bytes) with the private key.
  ///
  /// Returns a `DecoratedSignature`, which includes the signature and the key hint.
  DecoratedSignature sign(List<int> message) {
    final signer = ED25519Signer(privateKey);
    final sign = signer.sign(message);
    final hint = toPublicKey().hint();
    return DecoratedSignature(hint: hint, signature: sign.encoded);
  }

  @override
  void dispose() {
    privateKey.dispose();
  }
}
