import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart' show test, expect;

void main() {
  test('Exception serialization', () {
    {
      const error = DartStellarPlugingException(
        "error",
        details: {"length": '32'},
      );
      final decode = BaseDartStellarPlugingException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
    {
      const error = StellarAddressException("error", details: {"length": '32'});
      final decode = BaseDartStellarPlugingException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
  });
}
