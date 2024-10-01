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
  final wallet = Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;
  final signer2PrivateKey = StellarPrivateKey.fromBytes(wallet.privateKey.raw);
  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));

  final maxTime =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;

  final operation = SetOptionsOperation(
      highThreshold: 2,
      lowThreshold: 2,
      medThreshold: 2,
      masterWeight: 1,
      signer: Signer(
          key: SignerKeyEd25519(signer2PrivateKey.toPublicKey().toBytes()),
          weight: 1));

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

  payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey.sign(payload.txHash());
  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: [signature]);

  await rpc
      .request(HorizonRequestSubmitTransaction(envlope.toVariantXDRBase64()));
}
