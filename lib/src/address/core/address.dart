import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';

abstract class StellarAddress
    with Equality, CborTagSerializable
    implements IAddress {
  final String baseAddress;
  final XlmAddrTypes type;
  @override
  String get address => baseAddress;
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
          'Invalid address type. for secret key please use `StellarPrivateKey.fromBase32`',
        );
    }
  }

  factory StellarAddress.deserializeIAddress({
    List<int>? bytes,
    CborObject? object,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: BlockchainNetwork.stellar.identifier,
      cborBytes: bytes,
      cborObject: object,
    );
    final type = XlmAddrTypes.fromTag(values.rawValueAt(0));
    switch (type) {
      case XlmAddrTypes.muxed:
        return StellarMuxedAddress.fromPublicKey(
          publicKey: values.rawValueAt(1),
          accountId: values.rawValueAt(2),
        );
      case XlmAddrTypes.pubKey:
        return StellarAccountAddress.fromPublicKey(values.rawValueAt(1));
      case XlmAddrTypes.contract:
        return StellarContractAddress.fromBytes(values.rawValueAt(1));
      case XlmAddrTypes.privKey:
        throw const DartStellarPlugingException(
          'Invalid address type. for secret key please use `StellarPrivateKey.fromBase32`',
        );
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
      throw DartStellarPlugingException(
        'Address casting failed.',
        details: {'expected': '$T', 'address': runtimeType.toString()},
      );
    }
    return this as T;
  }

  @override
  BlockchainNetwork get blockchainNetwork => BlockchainNetwork.stellar;

  @override
  List<int> encodeAsIAddress() {
    return toCbor().encode();
  }

  @override
  SerializationIdentifier get serializationIdentifier =>
      blockchainNetwork.identifier;

  @override
  List<dynamic> get variables => [type, baseAddress];

  @override
  List<CborObject?> get serializationItems => [
    type.value.toCbor(),
    CborBytesValue(keyBytes()),
  ];

  @override
  String? get viewType => type.name;
}
