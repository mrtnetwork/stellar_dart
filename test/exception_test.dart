import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart' show test, expect, equals;

import 'utils.dart';

void main() {
  StellarTestApi.runTest(exceptionTest, 'Exception');
}

void exceptionTest() {
  test('Exception serialization', () {
    BuErrorCodec.registerTypes(StellarErrorType.values);
    {
      const error = BuError(
        StellarErrorType.plugin,
        "error",
        details: {"length": '32'},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, StellarErrorType.plugin);
      expect(decode.message, "error");
      expect(decode.details, {"length": '32'});
    }
    {
      const error = BuError(
        StellarErrorType.address,
        "error",
        details: {"length": '32'},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, StellarErrorType.address);
      expect(decode.message, "error");
    }
    {
      final ids = StellarErrorType.values.map((e) => e.id);
      expect(ids.toSet().length, StellarErrorType.values.length);
      for (final id in ids) {
        expect(id > 258, equals(true));
      }
    }
  });
}
