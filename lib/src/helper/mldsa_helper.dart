import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

/// Helpers for the Protocol 30 ML-DSA host functions (CAP-87):
/// `verify_sig_ml_dsa_44`, `verify_sig_ml_dsa_65`, `verify_sig_ml_dsa_87`.
///
/// These run *inside* contracts (for example custom-account signature
/// checks); transaction-level signatures stay Ed25519, so there are no
/// ML-DSA Stellar keypairs or addresses. This helper only covers the
/// client side: generating keys, signing/verifying off-chain, and encoding
/// keys/signatures as the `ScVal` bytes a contract call expects.
///
/// All key operations go through [BaseMLDSAPublicKey] /
/// [BaseMLDSAPrivateKey] — never the raw [MLDSA] algorithm object.
class StellarMldsaHelper {
  /// Generates an ML-DSA keypair for [params] (default 65).
  /// Deterministic when [seed] is provided.
  static BaseMLDSAPrivateKey generateKey({
    MLDSAParams? params,
    List<int>? seed,
  }) {
    return BaseMLDSAPrivateKey.generate(
      params ?? MLDSAParams.mldsa65Params,
      seed: seed,
    );
  }

  /// Parses a verifying key; the parameter set is detected from the length.
  static BaseMLDSAPublicKey publicKeyFromBytes(List<int> bytes) {
    return BaseMLDSAPublicKey.fromBytes(bytes);
  }

  /// Parses a signing key; the parameter set is detected from the length.
  static BaseMLDSAPrivateKey privateKeyFromBytes(List<int> bytes) {
    return BaseMLDSAPrivateKey.fromBytes(bytes);
  }

  /// Signs [message] (FIPS 204, optional [context] binding).
  static MLDSASignature sign({
    required BaseMLDSAPrivateKey privateKey,
    required List<int> message,
    List<int>? context,
  }) {
    return privateKey.sign(MLDSASigningParams(message, context: context));
  }

  /// Verifies [signature] over [message].
  static bool verify({
    required BaseMLDSAPublicKey publicKey,
    required List<int> message,
    required List<int> signature,
    List<int>? context,
  }) {
    return publicKey.verify(
      MLDSAVerifyingParams(
        message,
        MLDSASignature(signature),
        context: context,
      ),
    );
  }

  /// Encodes a verifying key as contract-arg bytes.
  static ScValBytes publicKeyToScVal(BaseMLDSAPublicKey key) {
    return ScValBytes(key.toBytes().toList());
  }

  /// Encodes a signature as contract-arg bytes.
  static ScValBytes signatureToScVal(MLDSASignature signature) {
    return ScValBytes(signature.toBytes().toList());
  }
}
