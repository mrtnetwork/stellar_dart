/// Shared backend init for plain test suites (no one_shot aggregator).
///
/// Import from any `*_test.dart` and call inside `main()`:
/// ```dart
/// void main() {
///   setUpAll(initSuiteBackend);
///   ...
/// }
/// ```
/// Backend via `BU_BACKEND` (VM process env) or `--define` (web):
/// `dart` (default), `ffi`/`rust`/`native` (needs the shared `.so`).
/// Without init, `blockchainUtils.api` throws LateInitializationError.
library;

import 'package:blockchain_utils/blockchain_utils.dart';

import 'test_backend.dart';
import 'test_backend_stub.dart'
    if (dart.library.io) 'test_backend_io.dart' as backend_io;

/// Selects the backend for the current suite. VM default is the pure-Dart
/// backend (zero setup); pass `BU_BACKEND=ffi` for the Rust backend (the
/// shared library is auto-resolved, `BU_LIB_PATH` overrides).
/// Resolves the backend for the current suite: `BU_BACKEND` (VM env or web
/// `--define`), defaulting to pure Dart (zero setup, works on VM and web).
/// Single source of truth for [initSuiteBackend] and the backend-identity
/// test so a run can never execute against a different backend than the one
/// it claims.
BuTestBackend resolveSuiteBackend() {
  final raw = testEnvVar('BU_BACKEND');
  return (raw == null || raw.trim().isEmpty)
      ? BuTestBackend.dart
      : BuTestBackend.parse(raw);
}

/// Throws [StateError] when the resolved backend did not actually activate
/// (e.g. an `ffi` run silently falling back to pure Dart). Fails loudly
/// instead of producing backend-mislabeled results.
void assertBackendActive(BuTestBackend backend) {
  final native = blockchainUtils.hasNativeBackend;
  if (backend == BuTestBackend.dart && native) {
    throw StateError(
      'BU_BACKEND=dart selected but a native backend is active. '
      'Refusing to run Dart-backend tests against Rust.',
    );
  }
  if (backend != BuTestBackend.dart && !native) {
    throw StateError(
      'BU_BACKEND=$backend selected but no native backend is active '
      '(hasNativeBackend == false). Refusing to run Rust-backend tests '
      'on the pure-Dart backend.',
    );
  }
}

void initSuiteBackend() {
  // Default is the pure-Dart backend (zero setup, works on VM and web);
  // pass `BU_BACKEND=ffi` (VM) for the Rust backend.
  final backend = resolveSuiteBackend();
  if (backend == BuTestBackend.ffi) {
    String? path = testEnvVar('BU_LIB_PATH');
    try {
      path ??= backend_io.defaultFfiLibraryPath(
        profile: testEnvVar('BU_FFI_PROFILE') ?? 'debug',
      );
      if (!backend_io.ffiLibraryExists(path)) {
        throw StateError(
          'FFI library missing: $path. Build it (`dart tool/build_backends.dart --ffi` '
          'in blockchain_utils) or set BU_LIB_PATH.',
        );
      }
    } on UnsupportedError {
      path = testEnvVar('BU_LIB_PATH');
    }
    blockchainUtils.setRustApi(libraryPath: path);
  } else {
    blockchainUtils.setDartApi();
  }
  assertBackendActive(backend);
}
