# Stellar Dart

Stellar Dart is a powerful package designed for seamless integration with the Stellar network, specifically tailored for developers looking to create, sign, and dispatch transactions effortlessly. It provides robust support for Stellar's transaction models, including native asset transfers and smart contract interactions.

Designed to facilitate interactions with various Stellar wallet types and features, Stellar Dart ensures efficient communication and transaction management within the Stellar ecosystem. It supports operations with accounts, managing assets, and implementing multi-signature transactions with ease.

With Stellar Dart, developers can leverage advanced cryptographic capabilities for secure transaction signing and verification, enhancing the integrity and security of their operations. Whether you're executing transactions, querying account balances, or interacting with Stellar smart contracts, Stellar Dart offers a comprehensive toolkit to handle diverse data formats and cryptographic operations efficiently.

To maximize the benefits of Stellar Dart, a solid understanding of Stellar's network and API interactions is recommended. Stellar Dart simplifies complex tasks, making it an essential resource for developers navigating the Stellar ecosystem.

## Futures

- **Transaction Management**
  - Create, sign, and verify transactions using ED25519.

- **Provider**
  - Communication with Horizon and Soroban api.

- **Operation**
  - Supports all Stellar operations, including Payments, Path Payments, Create Account, and Manage Data.

- **Contract**
  - Supports deployment and interaction with Soroban smart contracts.

### Examples

  - [Payment](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/send_assets.dart)
  - [DeployContract](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/deploy_contract.dart)
  - [CallContract](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/transfer.dart)
  - [CreateSellOffer](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/create_sell_offer.dart)
  - [EnableMultisigAccount](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/enable_multisig_account.dart)
  - [PaymentUsingMultisigAccount](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/payment_using_multisig.dart)
  - [PathPaymentStrict](https://github.com/mrtnetwork/stellar_dart/tree/main/example/lib/examples/path_payment_strict.dart)


transfer

```dart
  /// Initialize the HorizonProvider with the specified URLs for the testnet.
  final rpc = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));

  /// Create a StellarPrivateKey instance from a hexadecimal string.
  final privateKey = StellarPrivateKey.fromHex(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");

  /// Convert the private key to a public key and then to an address.
  final source = privateKey.toPublicKey().toAddress();

  /// Request the account details for the source address from the Stellar network.
  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));

  /// Create a StellarAddress instance from a base32 encoded address for the destination.
  final destination = StellarAddress.fromBase32Addr(
      "GCMQXZLBPVE76N2B6GVP6VWUWVD3P622EJPG3644PGO25AKYNK3H5IAM");

  /// Set the maximum time for the transaction to 30 seconds from now.
  final maxTime =
      DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch ~/
          1000;

  /// Create a PaymentOperation for the transaction.
  final operation = PaymentOperation(
      asset: StellarAssetCreditAlphanum4(
          issuer: StellarAddress.fromBase32Addr(
                  "GB726ND2YG4TR772WY4767M56RNSN3PHP4MV2ITQVCDM2LSMMVT7CD6O")
              .toPublicKey(),
          code: "MRT"),
      amount: StellarHelper.toStroop("12"),
      destination: destination.toMuxedAccount());

  /// Create a StellarTransactionV1 instance with the specified parameters.
  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: StellarHelper.toStroop("0.001").toInt(),
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.zero, maxTime: BigInt.from(maxTime))),
      operations: [Operation(body: operation)]);

  /// Create a TransactionSignaturePayload using the network ID and transaction.
  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  /// Sign the transaction using the private key.
  final signature = privateKey.sign(payload.txHash());

  /// Create a TransactionV1Envelope to encapsulate the transaction and its signature.
  TransactionV1Envelope envelope =
      TransactionV1Envelope(tx: transaction, signatures: [signature]);

  /// Submit the transaction to the Stellar network.
  await rpc
      .request(HorizonRequestSubmitTransaction(envelope.toVariantXDRBase64()));
```

### Horizon and soroban provider

```dart
class StellarHTTPProvider implements StellarServiceProvider {
  @override
  Future<HorizonServiceResponse> get(HorizonRequestDetails params,
      [Duration? timeout]) async {}

  @override
  Future<HorizonServiceResponse> post(HorizonRequestDetails params,
      [Duration? timeout]) async {}
}

  final providr = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));

  final account = await providr.request(const HorizonRequestAccount(
      "GCMQXZLBPVE76N2B6GVP6VWUWVD3P622EJPG3644PGO25AKYNK3H5IAM"));
  final fee = await providr.request(const HorizonRequestFeeStats());

  /// ...

  /// soroban request
  final simulateTx =
      await providr.request(const SorobanRequestSimulateTransaction(tx: tx));
  //// ....


```

### Addresses and KeyManagment

```dart
  /// Define the passphrase for generating the seed.
  const String passphrase = "MRTNETWORK";

  /// Generate a 12-word mnemonic using the Bip39MnemonicGenerator.
  final mnemonic =
      Bip39MnemonicGenerator().fromWordsNumber(Bip39WordsNum.wordsNum12);

  /// Generate a seed using the mnemonic and passphrase with the Bip39SeedGenerator.
  final seed = Bip39SeedGenerator(mnemonic).generate(passphrase);

  /// Derive the master wallet using Bip44 from the generated seed for the Stellar coin type.
  final masterWallet =
      Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;

  /// Extract the private key from the master wallet.
  final privateKey = StellarPrivateKey.fromBytes(masterWallet.privateKey.raw);

  /// Derive the public key from the private key.
  final publicKey = privateKey.toPublicKey();

  /// Convert the public key to a Stellar address.
  final address = publicKey.toAddress();

  /// Convert the address to a muxed address with an ID of 10.
  final muxedAddress = address.toMuxedAddress(BigInt.from(10));

```

## Resources

- Comprehensive Testing: All functionalities have been thoroughly tested, ensuring reliability and accuracy.

## Contributing

Contributions are welcome! Please follow these guidelines:

- Fork the repository and create a new branch.
- Make your changes and ensure tests pass.
- Submit a pull request with a detailed description of your changes.

## Feature requests and bugs

Please file feature requests and bugs in the issue tracker.
