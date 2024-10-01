import 'package:blockchain_utils/blockchain_utils.dart';
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
  final wallet = Bip44.fromSeed(
          BytesUtils.fromHexString(
              "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23"),
          Bip44Coins.stellar)
      .deriveDefaultPath;

  final maxTime =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;
  final operation = InvokeHostFunctionOperation(
      hostFunction: HostFunctionTypeInvokeContract(InvokeContractArgs(
          contractAddress: StellarContractAddress(
                  "CAPVIGVAQHXISEA7SGGPAK7Q5AZ5Q26WM74S4PY7M5C4VGTRLNI3JNML")
              .toScAddress(),
          functionName: ScValSymbol("transfer"),
          args: [
        ScValAddress(source.toScAddress()),
        ScValAddress.fromBase32(wallet.publicKey.toAddress),
        ScValI128(Int128Parts.fromNumber(BigInt.parse('1' * 18))),
      ])));

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: 41310835,
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.from(0), maxTime: BigInt.from(maxTime))),
      operations: [Operation(body: operation)]);

  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: []);
  final simulateData = await rpc.request(
      SorobanRequestSimulateTransaction(tx: envlope.toVariantXDRBase64()));
  if (!simulateData.isSuccess) {
    // ignore: avoid_print
    print("simulate failed. ${simulateData.error}");
    return;
  }
  transaction = transaction.copyWith(
      operations: [
        Operation(body: operation.copyWith(auth: simulateData.auths)),
      ],
      sorobanData: SorobanTransactionDataExt(
          sorobanTransactionData: simulateData.sorobanTransactionData));
  payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey.sign(payload.txHash());
  envlope = TransactionV1Envelope(tx: transaction, signatures: [signature]);
  final tx = envlope.toVariantXDRBase64();
  await rpc.request(HorizonRequestSubmitTransaction(tx));
}
