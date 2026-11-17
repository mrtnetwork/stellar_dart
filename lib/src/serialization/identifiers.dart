import 'package:blockchain_utils/blockchain_utils.dart';

/// CBOR tag identifiers for this package's serializable exceptions.
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
              throw const BuError(DefaultErrorType.notFound, "No matching StellarSerializationIdentifiers found for the given value. null"),
    );
  }

  @override
  bool isValid(int? tag) {
    return tag == id;
  }
}
