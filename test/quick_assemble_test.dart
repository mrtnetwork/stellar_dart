import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';
import 'suite_setup.dart';

/// Phase 3: offline tests for transaction assembly (fake providers, no
/// network) plus ledger-key and `ScVal` builders.
void main() {
  setUpAll(initSuiteBackend);

  const accountG =
      'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR';
  const contractIdHex =
      '3f0c34bf93ad0d9971d04ccc90f705511c838aad9734a4a2fb0d7a03fc7fe89a';
  const wOne =
      'WA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAAAAAAAAEGHC';

  StellarTransactionV1 unsignedInvokeTx() {
    final contractId = BytesUtils.fromHexString(contractIdHex);
    return StellarTransactionV1(
      sourceAccount: StellarAccountAddress(accountG).toMuxedAccount(),
      fee: 100,
      seqNum: BigInt.one,
      operations: [
        Operation(
          body: InvokeHostFunctionOperation(
            hostFunction: HostFunctionTypeInvokeContract(
              InvokeContractArgs(
                contractAddress:
                    StellarContractAddress.fromBytes(contractId).toScAddress(),
                functionName: ScValSymbol('transfer'),
                args: [
                  StellarScVal.address(
                    StellarAccountAddress(accountG).toScAddress(),
                  ),
                  // W destination (CAP-84) inside contract args.
                  StellarScVal.address(
                    StellarMuxedContractAddress(wOne).toScAddress(),
                  ),
                  StellarScVal.amount(BigInt.from(10000000)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String unsignedInvokeEnvelope() {
    return TransactionV1Envelope(
      tx: unsignedInvokeTx(),
      signatures: const [],
    ).toVariantXDRBase64();
  }

  SorobanAuthorizationEntry sampleAuth() {
    final contractId = BytesUtils.fromHexString(contractIdHex);
    return SorobanAuthorizationEntry(
      credentials: const SorobanCredentialsSourceAccount(),
      rootInvocation: SorobanAuthorizedInvocation(
        function: SorobanAuthorizedFunctionTypeContractFunction(
          InvokeContractArgs(
            contractAddress:
                StellarContractAddress.fromBytes(contractId).toScAddress(),
            functionName: ScValSymbol('transfer'),
            args: const [],
          ),
        ),
        subInvocations: const [],
      ),
    );
  }

  String sampleTxData() {
    return SorobanTransactionData(
      resources: SorobanResources(
        footprint: LedgerFootprint(readOnly: const [], readWrite: const []),
        instructions: 100000,
        readBytes: 1000,
        writeBytes: 1000,
      ),
      resourceFee: BigInt.from(500),
    ).toXDRBase64();
  }

  StellarRpcSimulateTransactionResult sampleSimulation() {
    return StellarRpcSimulateTransactionResult(
      latestLedger: 100,
      minResourceFee: '1000',
      results: [
        StellarRpcSimulateTransactionResultResultsItem(
          xdr: StellarScVal.boolean(true).toVariantXDRBase64(),
          auth: [sampleAuth().toXDRBase64()],
        ),
      ],
      transactionData: sampleTxData(),
    );
  }

  DefaultStellarQuickClient quickWith({
    required Map<Type, dynamic Function()> rpc,
    Map<Type, dynamic Function()> horizon = const {},
  }) {
    return DefaultStellarQuickClient(
      horizonProvider: _FakeProvider(horizon),
      rpcProvider: _FakeProvider({
        StellarRpcRequestGetNetwork: () => StellarRpcGetNetworkResult(
          passphrase: StellarNetwork.testnet.passphrase,
          protocolVersion: 29,
        ),
        ...rpc,
      }),
    );
  }

  test('assembleTransaction injects auth, footprint and fee', () async {
    final quick = quickWith(rpc: const {});
    final assembled = await quick.assembleTransaction(
      unsignedEnvelopeBase64: unsignedInvokeEnvelope(),
      simulation: sampleSimulation(),
    );
    expect(assembled.needsRestore, isFalse);
    expect(assembled.minResourceFee, '1000');

    final envelope = Envelope.fromXdr(
      StringUtils.encode(
        assembled.envelopeBase64,
        encoding: StringEncoding.base64,
      ),
    ).cast<TransactionV1Envelope>();
    // base fee 100 + resource fee 1000.
    expect(envelope.tx.fee, 1100);
    final body =
        envelope.tx.operations.single.body as InvokeHostFunctionOperation;
    expect(body.auth, hasLength(1));
    expect(envelope.tx.sorobanData.sorobanTransactionData, isNotNull);
    expect(
      assembled.txId,
      envelope.txId(StellarNetwork.testnet.passphraseHash),
    );
  });

  test('assembleTransaction surfaces simulation errors', () async {
    final quick = quickWith(rpc: const {});
    await expectLater(
      quick.assembleTransaction(
        unsignedEnvelopeBase64: unsignedInvokeEnvelope(),
        simulation: const StellarRpcSimulateTransactionResult(
          latestLedger: 100,
          error: 'host failed',
        ),
      ),
      throwsA(anything),
    );
  });

  test('assembleTransaction flags restore preamble', () async {
    final quick = quickWith(rpc: const {});
    final sim = sampleSimulation();
    final withRestore = StellarRpcSimulateTransactionResult(
      latestLedger: sim.latestLedger,
      minResourceFee: sim.minResourceFee,
      results: sim.results,
      transactionData: sim.transactionData,
      restorePreamble:
          const StellarRpcSimulateTransactionResultRestorePreamble(
            minResourceFee: '200',
            transactionData: '',
          ),
    );
    final assembled = await quick.assembleTransaction(
      unsignedEnvelopeBase64: unsignedInvokeEnvelope(),
      simulation: withRestore,
    );
    expect(assembled.needsRestore, isTrue);
    expect(assembled.restorePreamble, isNotNull);
  });

  test('buildRestoreTransaction produces a restore envelope', () async {
    final quick = quickWith(rpc: const {});
    final txData = sampleTxData();
    final envelopeBase64 = await quick.buildRestoreTransaction(
      source: StellarAccountAddress(accountG),
      preamble:
          StellarRpcSimulateTransactionResultRestorePreamble(
            minResourceFee: '200',
            transactionData: txData,
          ),
      seqNum: BigInt.from(42),
      fee: 300,
    );
    final envelope = Envelope.fromXdr(
      StringUtils.encode(envelopeBase64, encoding: StringEncoding.base64),
    ).cast<TransactionV1Envelope>();
    expect(envelope.tx.seqNum, BigInt.from(42));
    expect(envelope.tx.fee, 500);
    expect(
      envelope.tx.operations.single.body,
      isA<RestoreFootprintOperation>(),
    );
    expect(envelope.tx.sorobanData.sorobanTransactionData, isNotNull);
  });

  test('pollTransaction returns on terminal status', () async {
    var calls = 0;
    final quick = quickWith(
      rpc: {
        StellarRpcRequestGetTransaction: () {
          calls++;
          final status =
              calls < 3
                  ? StellarRpcGetTransactionResultStatus.notFound
                  : StellarRpcGetTransactionResultStatus.success;
          return StellarRpcGetTransactionResult(
            status: status,
            txHash: 'ab' * 32,
            latestLedger: 100,
            latestLedgerCloseTime: '1',
            oldestLedger: 90,
            oldestLedgerCloseTime: '1',
          );
        },
      },
    );
    final r = await quick.pollTransaction(
      'ab' * 32,
      interval: const Duration(milliseconds: 1),
    );
    expect(r.status, StellarRpcGetTransactionResultStatus.success);
    expect(calls, 3);
  });

  test('ledger-key builders roundtrip', () {
    final account = StellarAccountAddress(accountG);
    final contractId = BytesUtils.fromHexString(contractIdHex);
    final keys = <String>[
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForAccount(account),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForTrustline(
        account: account,
        asset: StellarAssetNative(),
      ),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForOffer(seller: account, offerId: BigInt.one),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForData(account: account, dataName: 'key'),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForClaimableBalance(
        ClaimableBalanceIdV0(contractId),
      ),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForLiquidityPool(contractId),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForContractData(
        contract:
            StellarContractAddress.fromBytes(contractId).toScAddress(),
        key: StellarScVal.symbol('k'),
      ),
      DefaultStellarQuickClient(
        horizonProvider: _FakeProvider(const {}),
        rpcProvider: _FakeProvider(const {}),
      ).ledgerKeyForContractCode(contractId),
    ];
    expect(keys, hasLength(8));
    for (final k in keys) {
      final decoded = LedgerKey.fromStruct(
        LedgerKey.layout().deserialize(
          StringUtils.encode(k, encoding: StringEncoding.base64),
        ).value,
      );
      expect(decoded.toVariantXDRBase64(), k);
    }
  });

  test('StellarScVal builders roundtrip', () {
    final values = <ScVal>[
      StellarScVal.boolean(true),
      StellarScVal.u32(7),
      StellarScVal.i32(-7),
      StellarScVal.u64(BigInt.parse('18446744073709551615')),
      StellarScVal.i64(BigInt.from(-5)),
      StellarScVal.string('hello'),
      StellarScVal.symbol('sym'),
      StellarScVal.bytes([1, 2, 3]),
      StellarScVal.address(StellarMuxedContractAddress(wOne).toScAddress()),
      StellarScVal.vec([StellarScVal.u32(1)]),
      StellarScVal.amount(BigInt.from(10000000)),
    ];
    for (final v in values) {
      final decoded = ScVal.fromStruct(
        ScVal.layout().deserialize(v.toVariantXDR()).value,
      );
      expect(decoded.toVariantXDR(), v.toVariantXDR());
    }
  });
}

class _FakeProvider
    implements IProvider<IServiceProvider, StellarRequestDetails> {
  final Map<Type, dynamic Function()> handlers;
  _FakeProvider(this.handlers);

  @override
  IServiceProvider get service => throw UnimplementedError();

  @override
  Future<RESULT> request<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails> request, {
    Duration? timeout,
  }) async {
    final handler = handlers[request.runtimeType];
    if (handler == null) {
      throw StateError('Unexpected request ${request.runtimeType}');
    }
    return handler() as RESULT;
  }

  @override
  Future<SERVICERESPONSE> requestDynamic<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails> request, {
    Duration? timeout,
  }) {
    throw UnimplementedError();
  }
}
