# Stellar Dart

Cross-platform Dart toolkit for the Stellar network: build, sign, and submit transactions, manage accounts and assets, run multisig flows, and deploy/interact with Soroban smart contracts.

This package is the expanded successor of the original
[mrtnetwork/stellar_dart](https://github.com/mrtnetwork/stellar_dart).
Everything from that release is still here; the address types, regenerated
providers, and backend-parity tests below are new.

## Crypto engine: `blockchain_utils` dual backend

All cryptography (Ed25519 signing/verification, hashing) delegates to
[`blockchain_utils`](https://github.com/mrtnetwork/blockchain_utils), which now
runs a **dual backend behind one typed API**: pure Dart by default, optional
zero-dependency Rust backend (FFI on native, WASM on web).

- Details and backend tables live in the
  [`blockchain_utils` README](https://github.com/mrtnetwork/blockchain_utils).
- The Rust core is maintained at
  [mrtnetwork/blockchain-utils](https://github.com/mrtnetwork/blockchain-utils).
- When the Rust backend is set (`blockchainUtils.setRustApi()`), all
  high-level crypto used here routes through Rust.

## Capability tables

### Transactions & accounts

| Area | Support |
|---|---|
| Envelopes | V1, fee bump |
| Preconditions | Time bounds, ledger bounds, min seq, extra signers |
| Multisig | Thresholds, extra signers, multisig payments |
| Sequence handling | Classic + Soroban footprint (restore / extend TTL) |
| Key management | BIP-39 / BIP-44 (`Bip44Coins.stellar`), muxed IDs |

### Operations

| Group | Operations |
|---|---|
| Payments | Payment, path payment strict send/receive |
| Offers & liquidity | Manage / create passive sell offers, manage buy offers, liquidity pool deposit / withdraw |
| Trust | Change trust, allow trust, set trust-line flags, clawback (+ claimable) |
| Balances | Create / claim claimable balance |
| Account | Create account, merge, manage data, set options, bump sequence, inflation |
| Sponsorship | Begin / end sponsoring future reserves, revoke sponsorship |

### Soroban contracts

| Area | Support |
|---|---|
| Lifecycle | Deploy, initialize, invoke host functions |
| Footprint | Extend TTL, restore footprint |
| Spec | On-chain contract-spec parsing, XDR encode/decode |
| Assets | Stellar asset contract bindings, WASM upload hash |

### Addresses

| Type | Format |
|---|---|
| Account | `G…` (Ed25519) |
| Muxed account | `M…` (base account + 64-bit ID) |
| Contract | `C…` (Soroban contract hash / asset contract) |
| Muxed contract | `W…` (CAP-84: contract + 64-bit ID) |

All address types inherit `IAddress` from `blockchain_utils`, so they plug
into the shared coin/address APIs.

### Providers

| API | Source |
|---|---|
| Horizon (accounts, txs, offers, claimable balances, liquidity pools) | Regenerated from `tool/specs/horizon-bundled.yml` (OpenAPI) |
| Soroban RPC (simulate, send, get transaction/ledger) | Regenerated from `tool/specs/stellar-rpc.openrpc.json` (OpenRPC) |
| Metadata | SEP-1 TOML parsing, fee stats |

Request/response types follow the canonical specs and are validated against
live testnet (`tool/live_quick_test.dart`).

## What's new vs the old `mrtnetwork/stellar_dart` release

- **Contract addresses:** `StellarContractAddress` (`C…`) and
  `StellarMuxedContractAddress` (`W…`, CAP-84).
- **Stellar XDR v30.0:** auth V2 / `CreateContractArgsV2`, credentials with
  delegates, `ContractExecutable` externalRef, CAP-88 value arms, CAP-87
  ML-DSA key classes (client side).
- **`IAddress` inheritance** for all Stellar address types (shared validation
  and coin-config integration).
- **Regenerated providers:** Horizon types from OpenAPI, Soroban RPC types
  from OpenRPC, with live-node test coverage.
- **Dual-backend tests:** `test_backend.dart` / `backend_identity_test.dart`
  exercise both the pure-Dart and Rust/WASM backends.
- **New examples:** fee bump, contract initialize, WASM-hash upload, local
  testnet flows.

## Breaking changes

- **All legacy exception classes removed — every error is `BuError`.** Failures throw `BuError` with a `StellarErrorType` taxonomy value (`domain: 'stellar'`: plugin, address). Update `catch` clauses and `on` filters to `BuError`.

- Address types now inherit `IAddress` — `is` checks against the old concrete
  hierarchy and custom subclasses may need updating.
- Horizon / Soroban RPC request and response models were regenerated from the
  canonical OpenAPI / OpenRPC specs; field names, optionality, and defaults
  may differ from the previous hand-written models.

## Examples

Explore all examples in [`example/lib/examples/`](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples):

## Testing

```sh
dart test            # unit + backend-parity suites
```

Live suites hit testnet and need network access:

```sh
STELLAR_HORIZON_URL=https://horizon-testnet.stellar.org \
STELLAR_RPC_URL=https://soroban-testnet.stellar.org \
dart tool/live_quick_test.dart
```

## Contributing

Contributions are welcome! Please follow these guidelines:

- Fork the repository and create a new branch.
- Make your changes and ensure tests pass.
- Submit a pull request with a detailed description of your changes.

## Feature requests and bugs

Please file feature requests and bugs in the issue tracker.
