import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';
import 'suite_setup.dart';

/// Phase 1 / Steps 2-6: P30 XDR additions (stellar-xdr v30.0).
void main() {
  setUpAll(initSuiteBackend);

  const contractIdHex =
      '3f0c34bf93ad0d9971d04ccc90f705511c838aad9734a4a2fb0d7a03fc7fe89a';
  final contractId = BytesUtils.fromHexString(contractIdHex);
  const accountG = 'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR';

  T roundTrip<T extends XDRSerialization>(
    T value,
    T Function(Map<String, dynamic>) fromStruct,
  ) {
    final layout = value.createLayout();
    final decoded = fromStruct(layout.deserialize(value.toXDR()).value);
    expect(decoded.toXDR(), value.toXDR());
    return decoded;
  }

  T roundTripVariant<T extends XDRVariantSerialization>(
    T value,
    T Function(Map<String, dynamic>) fromStruct,
  ) {
    final layout = value.createVariantLayout();
    final decoded = fromStruct(layout.deserialize(value.toVariantXDR()).value);
    expect(decoded.toVariantXDR(), value.toVariantXDR());
    return decoded;
  }

  test('Step 2: HostFunction createContractV2 + auth V2 variant', () {
    final args = CreateContractArgsV2(
      contractIdPreimage: ContractIdPreimageFromAddress(
        address: StellarContractAddress.fromBytes(contractId).toScAddress(),
        salt: BytesUtils.fromHexString(contractIdHex),
      ),
      executable: ContractExecutableWasmHash(contractId),
      constructorArgs: [ScValU32(7), ScValSymbol('init')],
    );
    final fn = HostFunctionTypeCreateContractV2(args);
    final back = roundTripVariant(fn, HostFunction.fromStruct);
    expect(
      ((back as HostFunctionTypeCreateContractV2).args.constructorArgs[0]
              as ScValU32)
          .value,
      7,
    );

    final authFn = SorobanAuthorizedFunctionTypeCreateContractV2HostFunction(
      args,
    );
    final authBack = roundTripVariant(
      authFn,
      SorobanAuthorizedFunction.fromStruct,
    );
    expect(
      (authBack as SorobanAuthorizedFunctionTypeCreateContractV2HostFunction)
          .args
          .constructorArgs,
      hasLength(2),
    );
  });

  test('Step 3: SorobanCredentials addressV2 + withDelegates', () {
    final v1 = SorobanAddressCredentials(
      address: StellarAccountAddress(accountG).toScAddress(),
      nonce: BigInt.one,
      signatureExpirationLedger: 100,
      signature: ScValU32(1),
    );
    roundTripVariant(v1, SorobanCredentials.fromStruct);

    final v2 = SorobanAddressCredentialsV2(
      address: StellarAccountAddress(accountG).toScAddress(),
      nonce: BigInt.one,
      signatureExpirationLedger: 100,
      signature: ScValU32(1),
    );
    final v2Back = roundTripVariant(v2, SorobanCredentials.fromStruct);
    expect(v2Back, isA<SorobanAddressCredentialsV2>());

    final withDelegates = SorobanAddressCredentialsWithDelegates(
      addressCredentials: v1,
      delegates: [
        SorobanDelegateSignature(
          address: StellarContractAddress.fromBytes(contractId).toScAddress(),
          signature: ScValU32(2),
          nestedDelegates: const [],
        ),
      ],
    );
    final wdBack = roundTripVariant(
      withDelegates,
      SorobanCredentials.fromStruct,
    );
    expect(wdBack, isA<SorobanAddressCredentialsWithDelegates>());
  });

  test('Step 4: ContractExecutable externalRef + ContractCostType', () {
    final ext = ContractExecutableExternalRef(
      executableOwner: StellarAccountAddress(accountG).toScAddress(),
      tag: 'vault',
    );
    final back = roundTripVariant(ext, ContractExecutable.fromStruct);
    expect((back as ContractExecutableExternalRef).tag, 'vault');

    expect(ContractCostType.values, hasLength(95));
    expect(ContractCostType.fromValue(0).name, 'WasmInsnExec');
    expect(ContractCostType.fromValue(92).name, 'VerifyMlDsa44Sig');
    expect(ContractCostType.fromValue(94).name, 'VerifyMlDsa87Sig');
    expect(ContractCostType.fromName('MlDsa65DecodeSignature').value, 90);
  });

  test('Step 5: StellarValue incl. ms arms (CAP-88)', () {
    StellarValue base(StellarValueExt ext) => StellarValue(
      txSetHash: contractId,
      closeTime: BigInt.from(1234567890),
      upgrades: const [],
      ext: ext,
    );

    final basicBack = roundTrip(
      base(StellarValueExt.basic()),
      StellarValue.fromStruct,
    );
    expect(basicBack.type, StellarValueType.basic);

    final nodeKey = StellarAccountAddress(accountG).toPublicKey();
    final sig = LedgerCloseValueSignature(
      nodeId: nodeKey,
      signature: List<int>.filled(64, 1),
    );
    final msBack = roundTrip(
      base(
        StellarValueExt.signedMs(
          StellarValueSignedMs(
            closeTimeMs: BigInt.from(1234567890123),
            lcValueSignature: sig,
          ),
        ),
      ),
      StellarValue.fromStruct,
    );
    final msBody = msBack.ext.value as StellarValueSignedMs;
    expect(msBody.closeTimeMs, BigInt.from(1234567890123));
    // Whole-second invariant: closeTime == closeTimeMs ~/ 1000.
    expect(msBack.closeTime, (msBody.closeTimeMs ~/ BigInt.from(1000)));

    final txSetBack = roundTrip(
      base(
        StellarValueExt.emptyTxSetMs(
          StellarValueEmptyTxSetMs(
            closeTimeMs: BigInt.from(1234567890999),
            body: StellarValueEmptyTxSetBody(
              txSetHash: contractId,
              previousLedgerHash: contractId,
              previousLedgerVersion: 30,
              lcValueSignature: sig,
            ),
          ),
        ),
      ),
      StellarValue.fromStruct,
    );
    expect(txSetBack.type, StellarValueType.emptyTxSetMs);
  });

  test('Step 6: ML-DSA via key classes (CAP-87 client side)', () {
    final seed = List<int>.generate(32, (i) => (i * 3 + 1) & 0xff);
    final sk = StellarMldsaHelper.generateKey(
      params: MLDSAParams.mldsa44Params,
      seed: seed,
    );
    final pk = sk.publicKey;
    expect(StellarMldsaHelper.publicKeyFromBytes(pk.toBytes().toList()), pk);

    const message = [1, 2, 3, 4, 5];
    final signature = StellarMldsaHelper.sign(privateKey: sk, message: message);
    expect(
      StellarMldsaHelper.verify(
        publicKey: pk,
        message: message,
        signature: signature.toBytes().toList(),
      ),
      isTrue,
    );
    expect(
      StellarMldsaHelper.verify(
        publicKey: pk,
        message: [9, 9, 9],
        signature: signature.toBytes().toList(),
      ),
      isFalse,
    );

    final keyArg = StellarMldsaHelper.publicKeyToScVal(pk);
    final sigArg = StellarMldsaHelper.signatureToScVal(signature);
    expect(keyArg.value, hasLength(pk.toBytes().length));
    expect(sigArg.value, hasLength(signature.toBytes().length));
    roundTripVariant(keyArg, ScVal.fromStruct);
  });
}
