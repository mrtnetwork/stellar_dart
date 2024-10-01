import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
  final rpc = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));

  final List<int> seed = BytesUtils.fromHexString(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");
  final wallet = Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;
  final privateKey2 = StellarPrivateKey.fromBytes(wallet.privateKey.raw);
  final privateKey = StellarPrivateKey.fromHex(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");
  final source = privateKey.toPublicKey().toAddress();

  final account = await rpc.request(
      HorizonRequestAccount(privateKey2.toPublicKey().toAddress().baseAddress));
  final maxTime =
      DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch ~/
          1000;
  final operation = ChangeTrustOperation(
      asset: StellarAssetCreditAlphanum4(
          issuer: source.toPublicKey(), code: "MRT"),
      limit: StellarHelper.toStroop("100000"));

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: privateKey2.toPublicKey().toMuxedAccount(),
      fee: StellarHelper.toStroop("1").toInt(),
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.zero, maxTime: BigInt.from(maxTime))),
      operations: [
        Operation(body: operation),
      ]);
  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey2.sign(payload.txHash());
  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: [signature]);
  await rpc
      .request(HorizonRequestSubmitTransaction(envlope.toVariantXDRBase64()));
}
