import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/serialization/identifiers.dart';

class StellarAddressException extends BaseDartStellarPlugingException {
  const StellarAddressException(super.message, {super.details});
  factory StellarAddressException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: StellarSerializationIdentifiers.stellarAddressError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return StellarAddressException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  StellarSerializationIdentifiers get serializationIdentifier =>
      StellarSerializationIdentifiers.stellarAddressError;
}
