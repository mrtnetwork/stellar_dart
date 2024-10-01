import 'package:blockchain_utils/bip/address/decoders.dart';
import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:stellar_dart/src/address/core/address.dart';
import 'package:stellar_dart/src/address/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

import 'muxed_address.dart';

/// Represents a Stellar account address, which is based on an ED25519 public key.
/// Extends `StellarAddress` and provides additional functionality specific to account addresses.
class StellarAccountAddress extends StellarAddress {
  /// Private constructor that initializes the address and type.
  StellarAccountAddress._({required String address, required XlmAddrTypes type})
      : super(baseAddress: address, type: type);

  /// Creates a `StellarAccountAddress` from a raw ED25519 public key byte array.
  ///
  /// The `publicKey` must be a valid ED25519 public key, and it will be
  /// encoded into a Stellar public address.
  ///
  /// Throws a `StellarAddressException` if the public key bytes are invalid.
  factory StellarAccountAddress.fromPublicKey(List<int> publicKey) {
    try {
      final encode = XlmAddrEncoder()
          .encodeKey(publicKey, {"addr_type": XlmAddrTypes.pubKey});
      return StellarAccountAddress._(
          address: encode, type: XlmAddrTypes.pubKey);
    } catch (e, s) {
      throw StellarAddressException("Invalid ED25519 public key bytes.",
          details: {"error": e.toString(), "stack": s.toString()});
    }
  }

  /// Creates a `StellarAccountAddress` from a string-encoded Stellar public address.
  ///
  /// The address must be a valid Stellar ED25519 public key address. It will decode
  /// the address and validate the type to ensure it is of type `XlmAddrTypes.pubKey`.
  ///
  /// Throws a `StellarAddressException` if the address is invalid or of the wrong type.
  factory StellarAccountAddress(String address) {
    try {
      final decode = XlmAddrDecoder().decode(address);
      if (decode.type != XlmAddrTypes.pubKey) {
        throw StellarAddressException("Incorrect address type.", details: {
          "expected": XlmAddrTypes.pubKey.name,
          "type": decode.type.toString()
        });
      }
      return StellarAccountAddress._(address: address, type: decode.type);
    } on StellarAddressException {
      rethrow;
    } catch (e, s) {
      throw StellarAddressException(
          "Invalid Stellar ED25519 public key address.",
          details: {"error": e.toString(), "stack": s.toString()});
    }
  }

  /// Converts the `StellarAccountAddress` into a `StellarMuxedAddress` by providing an `accountId`.
  ///
  /// This allows for the creation of muxed addresses which can hold additional account IDs.
  StellarMuxedAddress toMuxedAddress(BigInt accountId) {
    return StellarMuxedAddress.fromAccountAddress(
        address: this, accountId: accountId);
  }

  /// Converts this Stellar account address into an `ScAddress` for use in Soroban smart contracts.
  @override
  ScAddress toScAddress() {
    return ScAddressAccountId(toPublicKey());
  }

  /// Equality operator for comparing two `StellarAccountAddress` instances.
  @override
  operator ==(other) {
    if (other is! StellarAccountAddress) return false;
    return other.baseAddress == baseAddress;
  }

  /// Returns the hash code for this Stellar account address, based on its `baseAddress`.
  @override
  int get hashCode => baseAddress.hashCode;
}
