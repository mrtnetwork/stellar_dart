@TestOn('browser')
@Tags(['wasm'])
library;

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  setUpAll(() async {
    // Shared harness: loads the WASM module (built via
    // `dart tool/build_backends.dart --wasm`) and selects the Rust backend.
    // No .so involved.
    await StellarTestApi.initWasmBrowser();
  });

  group('wasm backend smoke (stellar_dart)', () {
    test('sha256 empty (shared backend)', () {
      expect(
        BytesUtils.toHexString(QuickCrypto.sha256Hash([])),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
    });
    test('stellar account address roundtrip', () {
      final addr = StellarAccountAddress(
        'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR',
      );
      expect(
        StellarAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
        addr,
      );
    });
  });
}
