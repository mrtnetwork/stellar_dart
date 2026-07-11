import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:blockchain_utils/networks/types/network.dart';
import 'package:stellar_dart/src/address/exception/exception.dart';
import 'package:stellar_dart/src/serialization/identifiers.dart';

abstract class BaseDartStellarPlugingException extends IException {
  const BaseDartStellarPlugingException(super.message, {super.details});
  factory BaseDartStellarPlugingException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValueWithInfo(
      expectedTags: StellarSerializationIdentifiers.values,
      cborBytes: bytes,
      cborObject: obj,
    );
    final identifier = values.identifier;
    return switch (identifier) {
      StellarSerializationIdentifiers.stellarPluginError =>
        DartStellarPlugingException.deserialize(obj: values.tag),
      StellarSerializationIdentifiers.stellarAddressError =>
        StellarAddressException.deserialize(obj: values.tag),
    };
  }

  @override
  BlockchainNetwork? get relatedNetwork => BlockchainNetwork.stellar;
  @override
  StellarSerializationIdentifiers get serializationIdentifier;
}

class DartStellarPlugingException extends BaseDartStellarPlugingException {
  const DartStellarPlugingException(super.message, {super.details});
  factory DartStellarPlugingException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: StellarSerializationIdentifiers.stellarPluginError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return DartStellarPlugingException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  StellarSerializationIdentifiers get serializationIdentifier =>
      StellarSerializationIdentifiers.stellarPluginError;
}
