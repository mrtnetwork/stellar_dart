import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/core/address.dart';
import 'package:stellar_dart/src/models/models.dart';

/// Represents a Stellar contract address, which is based on a contract ID.
/// Extends `StellarAddress` and provides additional functionality specific to contract addresses.
class StellarContractAddress extends StellarAddress {
  /// Private constructor that initializes the contract address and type.
  StellarContractAddress._({required String address, required super.type})
    : super(baseAddress: address);

  /// Creates a `StellarContractAddress` from a raw contract ID byte array.
  ///
  /// The `contractId` must be a valid contract identifier, and it will be
  /// encoded into a Stellar contract address.
  ///
  /// Throws a `BuError` if the contract ID bytes are invalid.
  factory StellarContractAddress.fromBytes(List<int> contractId) {
    try {
      final encode = XlmAddrEncoder().encodeKey(
        contractId,
        addrType: XlmAddrTypes.contract,
      );
      return StellarContractAddress._(
        address: encode,
        type: XlmAddrTypes.contract,
      );
    } catch (e, s) {
      throw BuError(DefaultErrorType.invalidAddressBytes, 
        'Invalid contract address bytes.',
        details: {'error': e.toString(), 'stack': s.toString()},
      );
    }
  }

  /// Creates a `StellarContractAddress` from a string-encoded Stellar contract address.
  ///
  /// The address must be a valid Stellar contract address. It will decode
  /// the address and validate the type to ensure it is of type `XlmAddrTypes.contract`.
  ///
  /// Throws a `BuError` if the address is invalid or of the wrong type.
  factory StellarContractAddress(String address) {
    try {
      final decode = XlmAddrDecoder().decode(address);
      if (decode.type != XlmAddrTypes.contract) {
        throw BuError(DefaultErrorType.invalidAddress, 
          'Incorrect address type.',
          details: {
            'expected': XlmAddrTypes.contract.name,
            'type': decode.type.name,
          },
        );
      }
      return StellarContractAddress._(address: address, type: decode.type);
    } on BuError {
      rethrow;
    } catch (e, s) {
      throw BuError(DefaultErrorType.invalidAddress, 
        'Invalid Stellar contract address.',
        details: {'error': e.toString(), 'stack': s.toString()},
      );
    }
  }

  /// Converts this Stellar contract address into an `ScAddress` for use in Soroban smart contracts.
  @override
  ScAddress toScAddress() {
    return ScAddressContract(this);
  }
}
