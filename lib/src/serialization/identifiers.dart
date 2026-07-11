import 'package:blockchain_utils/cbor/serialization/cbor/tag.dart';
import 'package:blockchain_utils/exception/exceptions.dart';

enum StellarSerializationIdentifiers implements SerializationIdentifier {
  stellarPluginError(17001),
  stellarAddressError(17002);

  @override
  final int id;
  const StellarSerializationIdentifiers(this.id);

  static StellarSerializationIdentifiers fromIdentifier(int? value) {
    return values.firstWhere(
      (e) => e.id == value,
      orElse:
          () =>
              throw ItemNotFoundException(
                name: "StellarSerializationIdentifiers",
              ),
    );
  }

  @override
  bool isValid(int? tag) {
    return tag == id;
  }
}
