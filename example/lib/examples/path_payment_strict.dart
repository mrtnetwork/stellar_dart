import 'package:stellar_dart/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
  final rpc = HorizonProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));
  final masterKey = StellarPrivateKey.fromBase32(
      "SAQGSJ7PLMO5C62DOULXPXNHCQJ6VQYTZGJRVXCFQ72MRUO56T2QQSTZ");
  final source = masterKey.toPublicKey().toAddress();
  final account = await rpc.request(HorizonRequestAccount(source.baseAddress));

  final maxTime =
      DateTime.now().add(const Duration(seconds: 30)).millisecondsSinceEpoch ~/
          1000;
  final buyAsset = StellarAssetCreditAlphanum4(
      issuer: StellarAddress.fromBase32Addr(
              "GB726ND2YG4TR772WY4767M56RNSN3PHP4MV2ITQVCDM2LSMMVT7CD6O")
          .toPublicKey(),
      code: "MRT");

  final changeTrust = ChangeTrustOperation(
      asset: buyAsset, limit: StellarHelper.toStroop("100"));
  final operation = PathPaymentStrictReceiveOperation(
    sendAsset: StellarAssetNative(),
    sendMax: StellarHelper.toStroop("10"),
    destAsset: buyAsset,
    destAmount: StellarHelper.toStroop("70"),
    destination: masterKey.toPublicKey().toMuxedAccount(),
  );

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: masterKey.toPublicKey().toMuxedAccount(),
      fee: StellarHelper.toStroop("0.001").toInt(),
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.zero, maxTime: BigInt.from(maxTime))),
      operations: [
        Operation(body: changeTrust),
        Operation(body: operation),
      ]);

  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  final signature = masterKey.sign(payload.txHash());
  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: [signature]);

  await rpc
      .request(HorizonRequestSubmitTransaction(envlope.toVariantXDRBase64()));

  /// https://stellar.expert/explorer/testnet/tx/969077765967872
}
