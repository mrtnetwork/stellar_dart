import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';
import 'suite_setup.dart';

/// Offline tests for the classic (non-Soroban) quick-client calls
/// (fake providers, no network).
StellarAddress get _account => StellarAccountAddress(
  'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR',
);
StellarAddress get _issuer => StellarAccountAddress(
  'GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ',
);

void main() {
  setUpAll(initSuiteBackend);

  const accountG =
      'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR';
  const issuerG =
      'GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ';

  HorizonAccountEmbeddedRecordsItem fakeAccount({
    String sequence = '41',
    List<HorizonAccountEmbeddedRecordsItemBalancesItem> balances = const [],
  }) {
    return HorizonAccountEmbeddedRecordsItem(
      id: accountG,
      accountId: accountG,
      sequence: sequence,
      subentryCount: 0,
      lastModifiedLedger: 100,
      lastModifiedTime: '2024-01-01T00:00:00Z',
      thresholds: const HorizonThresholds(),
      flags: const HorizonFlags(),
      balances: balances,
      signers: const [],
      data: const {},
      numSponsoring: 0,
      numSponsored: 0,
      pagingToken: '1',
    );
  }

  HorizonAccountEmbeddedRecordsItemBalancesItem nativeLine(String balance) {
    return HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative(
      HorizonBalanceLineNative(
        balance: balance,
        assetType: HorizonBalanceLineNativeAssetType.native,
      ),
    );
  }

  HorizonAccountEmbeddedRecordsItemBalancesItem assetLine({
    required String balance,
    required String code,
    required String issuer,
  }) {
    return HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset(
      HorizonBalanceLineAsset(
        balance: balance,
        limit: '1000000',
        buyingLiabilities: '0',
        sellingLiabilities: '0',
        lastModifiedLedger: 100,
        isAuthorized: true,
        isAuthorizedToMaintainLiabilities: true,
        assetType: HorizonBalanceLineAssetAssetType.creditAlphanum4,
        assetCode: code,
        assetIssuer: issuer,
      ),
    );
  }

  DefaultStellarQuickClient quickWith({
    required Map<Type, dynamic Function()> horizon,
    Map<Type, dynamic Function()> rpc = const {},
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

  test('parseBalanceToStroops converts decimal XLM', () {
    expect(StellarQuickClientApi.parseBalanceToStroops('1.5'), BigInt.from(15000000));
    expect(StellarQuickClientApi.parseBalanceToStroops('0'), BigInt.zero);
  });

  test('getNativeBalance sums native lines only', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveAnAccount: () => fakeAccount(
          balances: [
            nativeLine('1.5'),
            assetLine(balance: '10', code: 'USDC', issuer: issuerG),
            nativeLine('0.5'),
          ],
        ),
      },
    );
    expect(await quick.getNativeBalance(_account), BigInt.from(20000000));
  });

  test('getNativeBalance is zero for missing accounts', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveAnAccount: () => throw const RPCError(
          message: 'Not found',
          statusCode: 404,
          relatedNetwork: BlockchainNetwork.stellar,
        ),
      },
    );
    expect(await quick.getNativeBalance(_account), BigInt.zero);
  });

  test('getAssetBalance matches code and issuer', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveAnAccount: () => fakeAccount(
          balances: [
            nativeLine('1.5'),
            assetLine(balance: '10.25', code: 'USDC', issuer: issuerG),
          ],
        ),
      },
    );
    expect(
      await quick.getAssetBalance(
        account: _account,
        assetCode: 'USDC',
        issuer: _issuer,
      ),
      BigInt.from(102500000),
    );
    expect(
      await quick.getAssetBalance(
        account: _account,
        assetCode: 'EURC',
        issuer: _issuer,
      ),
      BigInt.zero,
    );
  });

  test('buildClassicTransaction sets sequence, fee and hash', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveAnAccount: () => fakeAccount(sequence: '41'),
      },
    );
    final built = await quick.buildClassicTransaction(
      source: _account,
      operations: [Operation(body: InflationOperation())],
      networkPassphrase: StellarNetwork.testnet.passphrase,
    );
    expect(built.transaction.seqNum, BigInt.from(42));
    expect(built.transaction.fee, 100);
    final envelope = TransactionV1Envelope(
      tx: built.transaction,
      signatures: const [],
    );
    expect(
      envelope.txId(StellarNetwork.testnet.passphraseHash),
      BytesUtils.toHexString(built.payloadHash),
    );
  });

  test('buildClassicTransaction throws for missing accounts', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveAnAccount: () => throw const RPCError(
          message: 'Not found',
          statusCode: 404,
          relatedNetwork: BlockchainNetwork.stellar,
        ),
      },
    );
    await expectLater(
      quick.buildClassicTransaction(
        source: _account,
        operations: [Operation(body: InflationOperation())],
        networkPassphrase: StellarNetwork.testnet.passphrase,
      ),
      throwsA(isA<BuError>()),
    );
  });

  test('submitChecked returns the hash on success', () async {
    final quick = quickWith(
      horizon: {
        HorizonRequestSubmitATransaction: () => HorizonTransaction2(
          hash: 'ab' * 32,
          successful: true,
        ),
      },
    );
    expect(await quick.submitChecked('e30='), 'ab' * 32);
  });

  test('submitChecked throws on failure responses', () async {
    final failed = quickWith(
      horizon: {
        HorizonRequestSubmitATransaction: () =>
            HorizonTransaction2(hash: 'ab' * 32, successful: false),
      },
    );
    await expectLater(
      failed.submitChecked('e30='),
      throwsA(isA<BuError>()),
    );

    final hashless = quickWith(
      horizon: {
        HorizonRequestSubmitATransaction: () =>
            const HorizonTransaction2(successful: true),
      },
    );
    await expectLater(
      hashless.submitChecked('e30='),
      throwsA(isA<BuError>()),
    );
  });

  test('trackHorizonTransaction completes and times out', () async {
    var calls = 0;
    final quick = quickWith(
      horizon: {
        HorizonRequestRetrieveATransaction: () {
          calls++;
          return HorizonTransaction2(
            hash: 'ab' * 32,
            successful: calls < 3 ? null : true,
          );
        },
      },
    );
    await quick.trackHorizonTransaction(
      transactionId: 'ab' * 32,
      periodicTimeOut: const Duration(milliseconds: 1),
    );
    expect(calls, 3);

    final failed = quickWith(
      horizon: {
        HorizonRequestRetrieveATransaction: () => HorizonTransaction2(
          hash: 'ab' * 32,
          successful: false,
        ),
      },
    );
    await expectLater(
      failed.trackHorizonTransaction(
        transactionId: 'ab' * 32,
        periodicTimeOut: const Duration(milliseconds: 1),
      ),
      throwsA(isA<BuError>()),
    );

    final never = quickWith(
      horizon: {
        HorizonRequestRetrieveATransaction: () => HorizonTransaction2(
          hash: 'ab' * 32,
          successful: null,
        ),
      },
    );
    await expectLater(
      never.trackHorizonTransaction(
        transactionId: 'ab' * 32,
        timeout: const Duration(milliseconds: 20),
        periodicTimeOut: const Duration(milliseconds: 1),
      ),
      throwsA(isA<BuError>()),
    );
  });

  test('latestLedgerSequence reads the RPC ledger', () async {
    final quick = quickWith(
      horizon: const {},
      rpc: {
        StellarRpcRequestGetLatestLedger: () =>
            const StellarRpcGetLatestLedgerResult(sequence: 123),
      },
    );
    expect(await quick.latestLedgerSequence(), 123);
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
