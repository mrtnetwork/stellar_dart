import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';

void main() {
  _transaction();
}

void _transaction() {
  test("Transaction v1", () {
    final List<int> seed = BytesUtils.fromHexString(
        "7dea550a78dd0f6afa98342a0e288e1d0b6bddd38d7a6fe17d9501a0524c3f23");
    final privateKey = StellarPrivateKey.fromBytes(seed);
    final wallet = Bip44.fromSeed(seed, Bip44Coins.stellar).deriveDefaultPath;

    final source = privateKey.toPublicKey().toAddress();
    final transaction = StellarTransactionV1(
        sourceAccount: MuxedAccount(source),
        fee: 100000,
        seqNum: BigInt.from(13),
        cond: PrecondTime(TimeBounds(
            minTime: BigInt.from(0), maxTime: BigInt.from(1727106100))),
        operations: [
          Operation(
              body: CreateAccountOperation(
                  destination: StellarPublicKey.fromAddress(
                      StellarAccountAddress(wallet.publicKey.toAddress)),
                  startingBalance: StellarHelper.toStroop("20")))
        ]);
    expect(transaction.toXDRHex(),
        "000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f1000186a0000000000000000d0000000100000000000000000000000066f18c340000000000000001000000000000000000000000990be5617d49ff3741f1aaff56d4b547b7fb5a225e6dfb9c799dae81586ab67e000000000bebc20000000000");
  });

  test("fee bump transaction", () {
    final envlp = Envelope.fromXdr(BytesUtils.fromHexString(
        "0000000500000000990be5617d49ff3741f1aaff56d4b547b7fb5a225e6dfb9c799dae81586ab67e00000000000f424000000002000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f100000000000175c5000000260000000100000000000000000000000066f509320000000000000001000000000000000100000000990be5617d49ff3741f1aaff56d4b547b7fb5a225e6dfb9c799dae81586ab67e000000000000000005f5e10000000000000000014c6567f100000040904b5b026d7fb839ff9e79bdc6e9326de9dc10dfdfb7338ff4dfb8eab1ff71f480c1f3b1a4d9570cbe556898edd5b621265d97c4cd67fda3daa8bb12d0d871080000000000000001586ab67e0000004027d0cee7b290dba8ab659f26ddb752d3b4c6e3e4b1c8446b7f65c68a77032426974eaec079d3c232e6d28cae38e0c2d26164c96ea3ce9493d587604203210205"));
    final decode = Envelope.fromXdr(envlp.toVariantXDR());
    expect(decode.toVariantXDRHex(),
        "0000000500000000990be5617d49ff3741f1aaff56d4b547b7fb5a225e6dfb9c799dae81586ab67e00000000000f424000000002000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f100000000000175c5000000260000000100000000000000000000000066f509320000000000000001000000000000000100000000990be5617d49ff3741f1aaff56d4b547b7fb5a225e6dfb9c799dae81586ab67e000000000000000005f5e10000000000000000014c6567f100000040904b5b026d7fb839ff9e79bdc6e9326de9dc10dfdfb7338ff4dfb8eab1ff71f480c1f3b1a4d9570cbe556898edd5b621265d97c4cd67fda3daa8bb12d0d871080000000000000001586ab67e0000004027d0cee7b290dba8ab659f26ddb752d3b4c6e3e4b1c8446b7f65c68a77032426974eaec079d3c232e6d28cae38e0c2d26164c96ea3ce9493d587604203210205");
    expect(decode.type, EnvelopeType.txFeeBump);
    expect(decode, isA<FeeBumpTransactionEnvelope>());
    final feeBump = decode as FeeBumpTransactionEnvelope;
    expect(feeBump.tx.fee, StellarHelper.toStroop("0.1"));
    expect(feeBump.tx.innerTx.tx.fee, 0);
    expect(
        feeBump.tx.innerTx.tx.sourceAccount.address,
        StellarAddress.fromBase32Addr(
            "GB726ND2YG4TR772WY4767M56RNSN3PHP4MV2ITQVCDM2LSMMVT7CD6O"));
  });
  test("envelope3", () {
    final envlp = Envelope.fromXdr(BytesUtils.fromHexString(
        "00000002000000001618d9b282065b8800b1a4f6279bc7299332966e72ba2f3cab80f1b0c28833f1000027100003711d000000020000000100000000000000000000000066fbd2e300000000000000020000000000000006000000014d525400000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f1000000003b9aca000000000000000002000000000000000005f5e100000000001618d9b282065b8800b1a4f6279bc7299332966e72ba2f3cab80f1b0c28833f1000000014d525400000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f10000000029b92700000000000000000000000001c28833f1000000404e98ce059e52569d90cb188f7d93a85cb26340a9a918ba241d524f81b7179bd3ac40a18c892bf961dcbb65e6422c467dc26534c389cec3bf20e3ef746a11e406"));
    final decode = Envelope.fromXdr(envlp.toVariantXDR());
    expect(decode.toVariantXDRHex(),
        "00000002000000001618d9b282065b8800b1a4f6279bc7299332966e72ba2f3cab80f1b0c28833f1000027100003711d000000020000000100000000000000000000000066fbd2e300000000000000020000000000000006000000014d525400000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f1000000003b9aca000000000000000002000000000000000005f5e100000000001618d9b282065b8800b1a4f6279bc7299332966e72ba2f3cab80f1b0c28833f1000000014d525400000000007faf347ac1b938fffab639ff7d9df45b26ede77f195d2270a886cd2e4c6567f10000000029b92700000000000000000000000001c28833f1000000404e98ce059e52569d90cb188f7d93a85cb26340a9a918ba241d524f81b7179bd3ac40a18c892bf961dcbb65e6422c467dc26534c389cec3bf20e3ef746a11e406");
    expect(decode.type, EnvelopeType.tx);
    expect(decode, isA<TransactionV1Envelope>());
    final transaction = decode.tx as StellarTransactionV1;
    expect(transaction.operations.length, 2);
    expect(transaction.operations[0].body.operationType,
        OperationType.changeTrust);
    expect(transaction.operations[1].body.operationType,
        OperationType.pathPaymentStrictReceive);
    expect(decode.signatures.length, 1);
    TransactionSignaturePayload payload = TransactionSignaturePayload(
        networkId: StellarNetwork.testnet.passphraseHash,
        taggedTransaction: transaction);
    final pubkey = transaction.sourceAccount.address.toPublicKey();
    final verify = pubkey.verify(
        digest: payload.txHash(), signature: decode.signatures[0].signature);
    expect(verify, true);
  });
}
