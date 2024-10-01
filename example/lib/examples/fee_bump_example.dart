import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
  final rpc = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));

  final List<int> seed = BytesUtils.fromHexString(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");

  final privateKey = StellarPrivateKey.fromHex(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");
  final source = privateKey.toPublicKey().toAddress();

  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));

  final wallet = Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;

  final maxTime =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;

  final operation = PaymentOperation(
      destination: MuxedAccount.fromBase32Address(wallet.publicKey.toAddress),
      asset: StellarAssetNative(),
      amount: StellarHelper.toStroop("10"));

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: 0,
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.from(0), maxTime: BigInt.from(maxTime))),
      operations: [Operation(body: operation)]);

  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: []);
  payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey.sign(payload.txHash());
  envlope = TransactionV1Envelope(tx: transaction, signatures: [signature]);
  final feeBum = StellarFeeBumpTransaction(
      feeSource: MuxedAccount.fromBase32Address(wallet.publicKey.toAddress),
      fee: StellarHelper.toStroop("0.1"),
      innerTx: envlope);
  final prv = StellarPrivateKey.fromBytes(wallet.privateKey.raw);
  payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: feeBum);
  final feeBumpEnvlop = FeeBumpTransactionEnvelope(
      tx: feeBum, signatures: [prv.sign(payload.txHash())]);
  final tx = feeBumpEnvlop.toVariantXDRBase64();
  await rpc.request(HorizonRequestSubmitTransaction(tx));
}
