import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
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
  final wallet = Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;
  final signer2PrivateKey = StellarPrivateKey.fromBytes(wallet.privateKey.raw);
  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));

  final maxTime =
      DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch ~/
          1000;

  final operation = PaymentOperation(
      amount: StellarHelper.toStroop("1"),
      destination: signer2PrivateKey.toPublicKey().toMuxedAccount(),
      asset: StellarAssetNative());

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: StellarHelper.toStroop("0.001").toInt(),
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.zero, maxTime: BigInt.from(maxTime))),
      operations: [
        Operation(body: operation),
      ]);

  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  final signature = privateKey.sign(payload.txHash());
  final signature2 = signer2PrivateKey.sign(payload.txHash());
  TransactionV1Envelope envlope = TransactionV1Envelope(
      tx: transaction, signatures: [signature, signature2]);

  await rpc
      .request(HorizonRequestSubmitTransaction(envlope.toVariantXDRBase64()));
}
