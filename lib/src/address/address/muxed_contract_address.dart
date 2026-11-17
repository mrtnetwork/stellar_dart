import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address/contract_address.dart';
import 'package:stellar_dart/src/address/core/address.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

/// Represents a Stellar muxed contract address (CAP-84, `W...` strkey):
/// a contract id paired with a 64-bit multiplexing id.
///
/// Mirrors [StellarMuxedAddress], but the underlying key is a contract id
/// (a hash, not an Ed25519 point). Usable as a transfer destination; it
/// cannot be used as a contract storage key.
class StellarMuxedContractAddress extends StellarAddress {
  /// The multiplexing id.
  final BigInt id;

  /// The muxed contract address as a string.
  final String muxedAddress;

  @override
  String get address => muxedAddress;

  /// Private constructor for initializing the muxed contract address and id.
  StellarMuxedContractAddress._({
    required String address,
    required this.muxedAddress,
    required BigInt id,
  }) : id = id.asU64,
       super(baseAddress: address, type: XlmAddrTypes.muxedContract);

  /// Factory constructor to create a `StellarMuxedContractAddress` from a
  /// contract id and an [id].
  ///
  /// Throws a `BuError` if the contract id is invalid.
  factory StellarMuxedContractAddress.fromContractId({
    required List<int> contractId,
    required BigInt id,
  }) {
    try {
      final address = XlmAddrEncoder().encodeKey(
        contractId,
        addrType: XlmAddrTypes.contract,
      );
      final muxedAddress = XlmAddrEncoder().encodeKey(
        contractId,
        muxedId: id,
        addrType: XlmAddrTypes.muxedContract,
      );
      return StellarMuxedContractAddress._(
        address: address,
        id: id,
        muxedAddress: muxedAddress,
      );
    } catch (e) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Invalid contract id.',
        details: {'stack': e.toString()},
      );
    }
  }

  /// Factory constructor to create a `StellarMuxedContractAddress` from a
  /// string-encoded muxed contract address.
  ///
  /// The address must be of type `XlmAddrTypes.muxedContract`.
  ///
  /// Throws a `BuError` if the address is of the wrong type
  /// or invalid.
  factory StellarMuxedContractAddress(String address) {
    try {
      final decode = XlmAddrDecoder().decode(address);
      if (decode.type != XlmAddrTypes.muxedContract) {
        throw BuError(
          DefaultErrorType.invalidAddress,
          'Incorrect address type.',
          details: {
            'expected': XlmAddrTypes.muxedContract.name,
            'type': decode.type.name,
          },
        );
      }
      return StellarMuxedContractAddress._(
        address: decode.baseAddress,
        id: decode.accountId!,
        muxedAddress: address,
      );
    } on BuError {
      rethrow;
    } catch (e, s) {
      throw BuError(
        DefaultErrorType.invalidAddress,
        'Invalid muxed contract address.',
        details: {'error': e.toString(), 'stack': s.toString()},
      );
    }
  }

  /// Converts this muxed contract address back to a regular
  /// `StellarContractAddress`.
  StellarContractAddress toContractAddress() {
    return StellarContractAddress.fromBytes(keyBytes());
  }

  /// Converts this muxed contract address into an `ScAddress`.
  @override
  ScAddress toScAddress() {
    return ScAddressMuxedContract.fromAddress(this);
  }

  /// Returns the muxed contract address as a string.
  @override
  String toString() {
    return muxedAddress;
  }

  @override
  List<CborObject?> get serializationItems => [
    type.value.toCbor(),
    CborBytesValue(keyBytes()),
    id.toCbor(),
  ];

  @override
  List<dynamic> get variables => [muxedAddress, type];
}
