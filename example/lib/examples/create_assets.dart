import 'package:stellar_dart/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
  final rpc = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));

  final privateKey = StellarPrivateKey.fromHex(
      "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");
  final source = privateKey.toPublicKey().toAddress();

  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));
  final maxTime =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;
  final asset =
      StellarAssetCreditAlphanum4(issuer: source.toPublicKey(), code: "MRT");

  final operation = PaymentOperation(
      destination: source.toMuxedAccount(),
      asset: asset,
      amount: StellarHelper.toStroop("1"));

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: StellarHelper.toStroop("1").toInt(),
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.zero, maxTime: BigInt.from(maxTime))),
      operations: [Operation(body: operation)]);
  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey.sign(payload.txHash());
  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: [signature]);
  await rpc
      .request(HorizonRequestSubmitTransaction(envlope.toVariantXDRBase64()));
}
