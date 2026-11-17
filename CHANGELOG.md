## 3.0.0
- Stellar XDR v30.0: CAP-84 muxed-contract (`W…`) addresses with the completed 6-arm `ScAddress` union, `CreateContractArgsV2` + auth V2, `SorobanCredentials` addressV2 with delegates, `ContractExecutable` externalRef, `ContractCostType`, `StellarValue` ms arms (CAP-88), ML-DSA key classes (CAP-87, client side).
- Contract addresses: added `StellarContractAddress` (`C…`) and `StellarMuxedContractAddress`.
- Regenerated Horizon (OpenAPI) and Soroban RPC (OpenRPC) request/response models; validated against live testnet.
- Dual-backend test parity (pure Dart + Rust/WASM) via `test_backend.dart`.
- New examples: fee bump, contract initialize, WASM-hash upload, local testnet flows.

## 2.3.0
- Updated dependencies.
- Updated StellarAddress to inherit from IAddress provided by blockchain_utils.

## 2.2.0

- Update dependencies.
- Minimum required Dart SDK version updated to 3.7.

## 2.1.0

- Update dependencies.

## 1.9.0

- Update dependencies.
- Add utility for parsing TOML metadata

## 1.8.0

- Update dependencies.
- Fixed API transaction response model.
- Added `address` getter to the `StellarAddress` class for deterministic address viewing.


## 1.7.0

- Update dependencies.

## 1.6.0

- Update dependencies.

## 1.5.0

- Update dependencies.

## 1.4.0

- Update dependencies.

## 1.3.0

- Update dependencies.

## 1.2.0

- Update dependencies.

## 1.1.0

- Update dependencies.

## 1.0.0

- Minimum required Dart SDK version updated to 3.3.
- The RPC method names and service class implementations have been updated. Please refer to the examples folder for guidance.
- Update dependencies.

## 0.3.0

- Update dependencies.
- Important Notice: This is the final version supporting Dart v2. The next release will require Dart v3.3 or higher.

## 0.2.0

- Update dependencies.

## 0.1.0

- Initial version.
