import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';

abstract class StellarAddress {
  final String baseAddress;
  final XlmAddrTypes type;
  const StellarAddress({required this.baseAddress, required this.type});
  factory StellarAddress.fromBase32Addr(String address) {
    final decode = XlmAddrDecoder().decode(address);
    switch (decode.type) {
      case XlmAddrTypes.muxed:
        return StellarMuxedAddress(address);
      case XlmAddrTypes.pubKey:
        return StellarAccountAddress(address);
      case XlmAddrTypes.contract:
        return StellarContractAddress(address);
      case XlmAddrTypes.privKey:
        throw const DartStellarPlugingException(
            "Invalid address type. for secret key please use `StellarPrivateKey.fromBase32`");
      default:
        throw const DartStellarPlugingException("Unknown address type.");
    }
  }
  List<int> keyBytes() {
    final decode = XlmAddrDecoder().decode(baseAddress);
    return decode.pubKeyBytes;
  }

  @override
  String toString() {
    return baseAddress;
  }

  StellarPublicKey toPublicKey() {
    return StellarPublicKey.fromAddress(this);
  }

  MuxedAccount toMuxedAccount() {
    return MuxedAccount(this);
  }

  ScAddress toScAddress();

  T cast<T extends StellarAddress>() {
    if (this is! T) {
      throw DartStellarPlugingException("Address casting failed.",
          details: {"excepted": "$T", "address": runtimeType.toString()});
    }
    return this as T;
  }
}
