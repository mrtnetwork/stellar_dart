import 'package:blockchain_utils/bip/address/decoders.dart';
import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:stellar_dart/src/address/address/account_address.dart';
import 'package:stellar_dart/src/address/core/address.dart';
import 'package:stellar_dart/src/address/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

/// Represents a Stellar muxed address, which is a multiplexed account with an account ID.
/// Extends `StellarAddress` and includes functionality specific to muxed addresses.
class StellarMuxedAddress extends StellarAddress {
  /// The ID of the multiplexed account.
  final BigInt accountId;

  /// The muxed address as a string.
  final String muxedAddress;

  /// Private constructor for initializing the muxed address, account ID, and address type.
  StellarMuxedAddress._({
    required String address,
    required this.muxedAddress,
    required BigInt accountId,
  })  : accountId = accountId.asUint64,
        super(baseAddress: address, type: XlmAddrTypes.muxed);

  /// Factory constructor to create a `StellarMuxedAddress` from a `StellarAccountAddress` and an `accountId`.
  ///
  /// It converts the account address into a muxed address.
  factory StellarMuxedAddress.fromAccountAddress(
      {required StellarAccountAddress address, required BigInt accountId}) {
    return StellarMuxedAddress.fromPublicKey(
        publicKey: address.keyBytes(), accountId: accountId);
  }

  /// Factory constructor to create a `StellarMuxedAddress` from a public key and an `accountId`.
  ///
  /// The `publicKey` and `accountId` are used to encode the muxed address.
  ///
  /// Throws a `StellarAddressException` if the public key is invalid.
  factory StellarMuxedAddress.fromPublicKey(
      {required List<int> publicKey, required BigInt accountId}) {
    try {
      final address = XlmAddrEncoder().encodeKey(publicKey,
          {"addr_type": XlmAddrTypes.pubKey, "account_id": accountId});
      final muxedAddress = XlmAddrEncoder().encodeKey(publicKey,
          {"addr_type": XlmAddrTypes.muxed, "account_id": accountId});
      return StellarMuxedAddress._(
          address: address, accountId: accountId, muxedAddress: muxedAddress);
    } catch (e) {
      throw StellarAddressException("Invalid public key.",
          details: {"stack": e.toString()});
    }
  }

  /// Factory constructor to create a `StellarMuxedAddress` from a string-encoded muxed address.
  ///
  /// The address must be of type `XlmAddrTypes.muxed`, and it will be decoded accordingly.
  ///
  /// Throws a `StellarAddressException` if the address is of the wrong type or invalid.
  factory StellarMuxedAddress(String address) {
    try {
      final decode = XlmAddrDecoder().decode(address);
      if (decode.type != XlmAddrTypes.muxed) {
        throw StellarAddressException("Incorrect address type.", details: {
          "expected": XlmAddrTypes.muxed.name,
          "type": decode.type.toString()
        });
      }

      return StellarMuxedAddress._(
          address: decode.baseAddress,
          accountId: decode.accountId!,
          muxedAddress: address);
    } on StellarAddressException {
      rethrow;
    } catch (e, s) {
      throw StellarAddressException("Invalid Muxed address.",
          details: {"error": e.toString(), "stack": s.toString()});
    }
  }

  /// Converts this muxed address back to a regular `StellarAccountAddress`.
  StellarAccountAddress toAccountAddress() {
    return StellarAccountAddress.fromPublicKey(keyBytes());
  }

  /// Converts this muxed address into an `ScAddress` for use in Soroban smart contracts.
  @override
  ScAddress toScAddress() {
    return ScAddressAccountId(toPublicKey());
  }

  /// Equality operator for comparing two `StellarMuxedAddress` instances.
  @override
  operator ==(other) {
    if (other is! StellarMuxedAddress) return false;
    return other.accountId == accountId && other.muxedAddress == muxedAddress;
  }

  /// Returns the hash code for this Stellar muxed address, based on its account ID and muxed address.
  @override
  int get hashCode => accountId.hashCode ^ muxedAddress.hashCode;

  /// Returns the muxed address as a string.
  @override
  String toString() {
    return muxedAddress;
  }
}
