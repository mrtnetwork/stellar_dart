import 'dart:io';
import 'package:stellar_dart/stellar_dart.dart';
import 'test_provider.dart';

void main() async {
  final sorbanTokenContract = File(
      "/Users/macbookpro/Downloads/soroban-examples-21.6.0/token/target/wasm32-unknown-unknown/release/soroban_token_contract.wasm");
  final wasmBytes = await sorbanTokenContract.readAsBytes();

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

  StellarTransactionV1 transaction = StellarTransactionV1(
      sourceAccount: source.toMuxedAccount(),
      fee: 1217850,
      seqNum: account.sequence + BigInt.one,
      cond: PrecondTime(
          TimeBounds(minTime: BigInt.from(0), maxTime: BigInt.from(maxTime))),
      operations: [
        Operation(
            body: InvokeHostFunctionOperation(
                hostFunction: HostFunctionTypeUploadContractWasm(wasmBytes))),
      ]);

  TransactionSignaturePayload payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);

  TransactionV1Envelope envlope =
      TransactionV1Envelope(tx: transaction, signatures: []);
  final simulateData = await rpc.request(
      SorobanRequestSimulateTransaction(tx: envlope.toVariantXDRBase64()));
  transaction = transaction.copyWith(
      sorobanData: SorobanTransactionDataExt(
          sorobanTransactionData: simulateData.sorobanTransactionData));
  payload = TransactionSignaturePayload(
      networkId: StellarNetwork.testnet.passphraseHash,
      taggedTransaction: transaction);
  final signature = privateKey.sign(payload.txHash());
  envlope = TransactionV1Envelope(tx: transaction, signatures: [signature]);
  final tx = envlope.toVariantXDRBase64();

  await rpc.request(HorizonRequestSubmitTransactionAsynchronously(tx));

  /// https://stellar.expert/explorer/testnet/tx/558886914424832
}
