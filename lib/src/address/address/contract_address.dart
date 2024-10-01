import 'package:blockchain_utils/bip/address/decoders.dart';
import 'package:blockchain_utils/bip/address/encoders.dart';
import 'package:stellar_dart/src/address/core/address.dart';
import 'package:stellar_dart/src/address/exception/exception.dart';
import 'package:stellar_dart/src/models/models.dart';

/// Represents a Stellar contract address, which is based on a contract ID.
/// Extends `StellarAddress` and provides additional functionality specific to contract addresses.
class StellarContractAddress extends StellarAddress {
  /// Private constructor that initializes the contract address and type.
  StellarContractAddress._(
      {required String address, required XlmAddrTypes type})
      : super(baseAddress: address, type: type);

  /// Creates a `StellarContractAddress` from a raw contract ID byte array.
  ///
  /// The `contractId` must be a valid contract identifier, and it will be
  /// encoded into a Stellar contract address.
  ///
  /// Throws a `StellarAddressException` if the contract ID bytes are invalid.
  factory StellarContractAddress.fromBytes(List<int> contractId) {
    try {
      final encode = XlmAddrEncoder()
          .encodeKey(contractId, {"addr_type": XlmAddrTypes.contract});
      return StellarContractAddress._(
          address: encode, type: XlmAddrTypes.contract);
    } catch (s, e) {
      throw StellarAddressException("Invalid contract address bytes.",
          details: {"error": e.toString(), "stack": s.toString()});
    }
  }

  /// Creates a `StellarContractAddress` from a string-encoded Stellar contract address.
  ///
  /// The address must be a valid Stellar contract address. It will decode
  /// the address and validate the type to ensure it is of type `XlmAddrTypes.contract`.
  ///
  /// Throws a `StellarAddressException` if the address is invalid or of the wrong type.
  factory StellarContractAddress(String address) {
    try {
      final decode = XlmAddrDecoder().decode(address);
      if (decode.type != XlmAddrTypes.contract) {
        throw StellarAddressException("Incorrect address type.", details: {
          "expected": XlmAddrTypes.contract.name,
          "type": decode.type.toString()
        });
      }
      return StellarContractAddress._(address: address, type: decode.type);
    } on StellarAddressException {
      rethrow;
    } catch (e, s) {
      throw StellarAddressException("Invalid Stellar contract address.",
          details: {"error": e.toString(), "stack": s.toString()});
    }
  }

  /// Converts this Stellar contract address into an `ScAddress` for use in Soroban smart contracts.
  @override
  ScAddress toScAddress() {
    return ScAddressContract(this);
  }

  /// Equality operator for comparing two `StellarContractAddress` instances.
  @override
  operator ==(other) {
    if (other is! StellarContractAddress) return false;
    return other.baseAddress == baseAddress;
  }

  /// Returns the hash code for this Stellar contract address, based on its `baseAddress`.
  @override
  int get hashCode => baseAddress.hashCode;
}
