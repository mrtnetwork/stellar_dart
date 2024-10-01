import 'package:stellar_dart/src/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
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
}
