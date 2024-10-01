import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/helper/helper.dart';
import 'package:stellar_dart/src/keypair/crypto/public_key.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/models/operations/operation.dart';
import 'package:test/test.dart';

final _contract = StellarContractAddress(
    "CAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAKAL");
final _source = StellarAccountAddress(
    "GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR");
final _mSource = StellarMuxedAddress(
    "MCFSYXIYBGIXS7QTSGECHBEUTM3DRZIBXI4Y4Q3XA5NNSWWZVM7S6AAAAAAAAAAABSLHA");
final _asset = StellarAssetCreditAlphanum12(
    code: "MRTNETWORK", issuer: StellarPublicKey.fromAddress(_source));
final _asset2 = StellarAssetCreditAlphanum4(
    code: "MRT", issuer: StellarPublicKey.fromAddress(_source));
void main() {
  group("Operation", () {
    _restoreFootprintOperation();
    _extendFootprintTtlOperation();
    _invokeHostFunction();
    _liquidityPoolWithdraw();
    _liquidityPoolDeposit();
    _setTrustLineFlags();
    _clawbackClaimableBalance();
    _clawback();
    _revokeSponsorshipOperation();
    _endSponsoringFutureReservesOperation();
    _beginSponsoringFutureReservesOperation();
    _claimClaimbleBalance();
    _createClaimableBalance();
    _pathPaymentStrictSend();
    _manageBuyOffer();
    _bumpSeq();
    _manageData();
    _accountMerge();
    _allowTrust();
    _changeTrust();
    _passiveSellOffer();
    _manageSellOffer();
    _createAccount();
    _payment();
    _inflation();
    _setOptions();
    _pathPaymentStrictReceiveOperation();
  });
}

/// 00000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000001a00000000
void _restoreFootprintOperation() {
  test("Restore Footprint", () {
    final operation = Operation(
      sourceAccount: MuxedAccount(_source),
      body: RestoreFootprintOperation(),
    );
    expect(operation.toXDRHex(),
        "00000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000001a00000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _extendFootprintTtlOperation() {
  test("Extend Footprint Ttl", () {
    final operation = Operation(
      body: ExtendFootprintTTLOperation(extendTo: 1),
    );
    expect(operation.toXDRHex(), "00000000000000190000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _invokeHostFunction() {
  test("create contract 1", () {
    final operation = Operation(
      body: InvokeHostFunctionOperation(
          hostFunction: HostFunctionTypeCreateContract(
        CreateContractArgs(
            executable: ContractExecutableStellarAsset(),
            contractIdPreimage: ContractIdPreimageFromAsset(_asset)),
      )),
    );
    expect(operation.toXDRHex(),
        "00000000000000180000000100000001000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000100000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("create contract 2", () {
    final operation = Operation(
      body: InvokeHostFunctionOperation(
          hostFunction: HostFunctionTypeCreateContract(
        CreateContractArgs(
            executable: ContractExecutableStellarAsset(),
            contractIdPreimage: ContractIdPreimageFromAddress(
                address: ScAddressContract(_contract),
                salt: BytesUtils.fromHexString(
                    "eb5346e4965313b1b706ae792249bccf77fa9af0e1963129744fd35ffd76b674"))),
      )),
    );
    expect(operation.toXDRHex(),
        "00000000000000180000000100000000000000012020202020202020202020202020202020202020202020202020202020202020eb5346e4965313b1b706ae792249bccf77fa9af0e1963129744fd35ffd76b6740000000100000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("create contract 3", () {
    final operation = Operation(
      body: InvokeHostFunctionOperation(
          hostFunction: HostFunctionTypeCreateContract(
        CreateContractArgs(
            executable: ContractExecutableWasmHash(BytesUtils.fromHexString(
                "84228ea7534fe215e620ec23f4c294b51a0f113758c4d856ac396637c919e435")),
            contractIdPreimage: ContractIdPreimageFromAddress(
                address: ScAddressContract(_contract),
                salt: BytesUtils.fromHexString(
                    "d9963d77b153f5f017ad5de9b1cda5253046a0fa62164923503837e46c47ff1e"))),
      )),
    );
    expect(operation.toXDRHex(),
        "00000000000000180000000100000000000000012020202020202020202020202020202020202020202020202020202020202020d9963d77b153f5f017ad5de9b1cda5253046a0fa62164923503837e46c47ff1e0000000084228ea7534fe215e620ec23f4c294b51a0f113758c4d856ac396637c919e43500000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });

  test("Invoke host function 2", () {
    final operation = Operation(
      body: InvokeHostFunctionOperation(
          hostFunction: HostFunctionTypeInvokeContract(InvokeContractArgs(
              contractAddress: ScAddressContract(_contract),
              functionName: ScValSymbol('account'),
              args: [
            ScValBoolean(true),
            ScValVoid(),
            ScValU32(12),
            ScValI32(13),
            ScValU64(BigInt.from(12)),
            ScValI64(BigInt.parse("23123123123123123")),
            ScValI64(BigInt.parse("-1123123123122")),
            ScValTimePoint(BigInt.parse("8000")),
            ScValDuration(BigInt.parse("8000")),
            ScValU256(UInt256Parts.fromNumber(
                BigInt.parse("23123123123123112312312312312312312312312323"))),
            ScValI256(Int256Parts.fromNumber(
                BigInt.parse("23123123123123112312312312312312312312312323"))),
            ScValU128(
                UInt128Parts.fromNumber(BigInt.parse("44444444444441233123"))),
            ScValI128(
                Int128Parts.fromNumber(BigInt.parse("-44444444444441233123"))),
            ScValBytes(BytesUtils.fromHexString(
                "69a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d23")),
            ScValString("MRTNETWORK"),
            ScValSymbol("MRT"),
            ScValVec(value: [
              ScValBoolean(true),
              ScValVoid(),
              ScValU32(12),
              ScValI32(13),
              ScValU64(BigInt.from(12)),
              ScValI64(BigInt.parse("23123123123123123")),
              ScValI64(BigInt.parse("-1123123123122")),
              ScValTimePoint(BigInt.parse("8000")),
              ScValDuration(BigInt.parse("8000")),
              ScValU256(UInt256Parts.fromNumber(BigInt.parse(
                  "23123123123123112312312312312312312312312323"))),
              ScValI256(Int256Parts.fromNumber(BigInt.parse(
                  "23123123123123112312312312312312312312312323"))),
              ScValU128(UInt128Parts.fromNumber(
                  BigInt.parse("44444444444441233123"))),
              ScValI128(Int128Parts.fromNumber(
                  BigInt.parse("-44444444444441233123"))),
              ScValBytes(BytesUtils.fromHexString(
                  "69a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d23")),
              ScValString("MRTNETWORK"),
              ScValSymbol("MRT"),
            ]),
            ScValMap(
                value: [ScMapEntry(ScValSymbol("MRT"), ScValSymbol("MRT"))]),
            ScValAddress(ScAddressContract(_contract)),
            ScValKeyContractInstance(),
            ScValNonceKey(ScNonceKey(BigInt.from(12312))),
            ScValInstance(ScContractInstance(
                executable: ContractExecutableStellarAsset())),
            ScValInstance(ScContractInstance(
                executable: ContractExecutableWasmHash(BytesUtils.fromHexString(
                    "a0968670e61560f3fef331011235f6fc2521c980da5da9cdde10b69f76c8dd8a")),
                storage: [
                  ScMapEntry(
                      ScValVec(value: [
                        ScValBoolean(true),
                        ScValVoid(),
                        ScValU32(12),
                        ScValI32(13),
                        ScValU64(BigInt.from(12)),
                        ScValI64(BigInt.parse("23123123123123123")),
                        ScValI64(BigInt.parse("-1123123123122")),
                        ScValTimePoint(BigInt.parse("8000")),
                        ScValDuration(BigInt.parse("8000")),
                        ScValU256(UInt256Parts.fromNumber(BigInt.parse(
                            "23123123123123112312312312312312312312312323"))),
                        ScValI256(Int256Parts.fromNumber(BigInt.parse(
                            "23123123123123112312312312312312312312312323"))),
                        ScValU128(UInt128Parts.fromNumber(
                            BigInt.parse("44444444444441233123"))),
                        ScValI128(Int128Parts.fromNumber(
                            BigInt.parse("-44444444444441233123"))),
                        ScValBytes(BytesUtils.fromHexString(
                            "69a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d23")),
                        ScValString("MRTNETWORK"),
                        ScValSymbol("MRT"),
                      ]),
                      ScValU128(UInt128Parts.fromNumber(
                          BigInt.parse("44444444444441233123"))))
                ]))
            //
          ]))),
    );
    expect(operation.toXDRHex(),
        "000000000000001800000000000000012020202020202020202020202020202020202020202020202020202020202020000000076163636f756e740000000017000000000000000100000001000000030000000c000000040000000d00000005000000000000000c000000060052265ba3d9f3b300000006fffffefa80a52c4e000000070000000000001f40000000080000000000001f400000000b00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b32030000000c00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b320300000009000000000000000268ca62bed680c6e30000000afffffffffffffffd97359d41297f391d0000000d0000002069a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d230000000e0000000a4d52544e4554574f524b00000000000f000000034d525400000000100000000100000010000000000000000100000001000000030000000c000000040000000d00000005000000000000000c000000060052265ba3d9f3b300000006fffffefa80a52c4e000000070000000000001f40000000080000000000001f400000000b00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b32030000000c00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b320300000009000000000000000268ca62bed680c6e30000000afffffffffffffffd97359d41297f391d0000000d0000002069a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d230000000e0000000a4d52544e4554574f524b00000000000f000000034d5254000000001100000001000000010000000f000000034d5254000000000f000000034d52540000000012000000012020202020202020202020202020202020202020202020202020202020202020000000140000001500000000000030180000001300000001000000000000001300000000a0968670e61560f3fef331011235f6fc2521c980da5da9cdde10b69f76c8dd8a0000000100000001000000100000000100000010000000000000000100000001000000030000000c000000040000000d00000005000000000000000c000000060052265ba3d9f3b300000006fffffefa80a52c4e000000070000000000001f40000000080000000000001f400000000b00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b32030000000c00000000000000000000000000010970c0630ebced8a63aa1df0644c7f3b320300000009000000000000000268ca62bed680c6e30000000afffffffffffffffd97359d41297f391d0000000d0000002069a7b70e039a2c617881c4095bb832946598d3588d457748bc917d379d428d230000000e0000000a4d52544e4554574f524b00000000000f000000034d52540000000009000000000000000268ca62bed680c6e300000000");

    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Invoke host function", () {
    final operation = Operation(
      body: InvokeHostFunctionOperation(
          hostFunction: HostFunctionTypeInvokeContract(InvokeContractArgs(
              contractAddress: ScAddressContract(_contract),
              functionName: ScValSymbol('hello'),
              args: [ScValString('world')]))),
    );
    expect(operation.toXDRHex(),
        "0000000000000018000000000000000120202020202020202020202020202020202020202020202020202020202020200000000568656c6c6f000000000000010000000e00000005776f726c6400000000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _liquidityPoolWithdraw() {
  test("Liquidity Pool Withdraw", () {
    final operation = Operation(
      body: LiquidityPoolWithdrawOperation(
          liquidityPoolId: BytesUtils.fromHexString(
              "c63e57f24bbd3c3e1dc4f5e588516f49f3222ae8aeb112cb1c7105cd43e3bdde"),
          minAmountA: StellarHelper.toStroop("1"),
          minAmountB: StellarHelper.toStroop("21.12"),
          amount: StellarHelper.toStroop("18")),
    );
    expect(operation.toXDRHex(),
        "0000000000000017c63e57f24bbd3c3e1dc4f5e588516f49f3222ae8aeb112cb1c7105cd43e3bdde000000000aba95000000000000989680000000000c96a800");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _liquidityPoolDeposit() {
  test("Liquidity Pool Deposit", () {
    final operation = Operation(
      body: LiquidityPoolDepositOperation(
          liquidityPoolId: BytesUtils.fromHexString(
              "57764d44fb8054e6bc32eafe556beeb5496234841335c1a6fecbd6d62333d263"),
          maxAmountA: StellarHelper.toStroop("1"),
          maxAmountB: StellarHelper.toStroop("21.12"),
          maxPrice: StellarPrice.fromDecimal("18"),
          minPrice: StellarPrice.fromDecimal("12")),
    );
    expect(operation.toXDRHex(),
        "000000000000001657764d44fb8054e6bc32eafe556beeb5496234841335c1a6fecbd6d62333d2630000000000989680000000000c96a8000000000c000000010000001200000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _setTrustLineFlags() {
  test("Set TrustLine Flags", () {
    final operation = Operation(
      sourceAccount: MuxedAccount(_mSource),
      body: SetTrustLineFlagsOperation(
          asset: StellarAssetNative(),
          clearFlags: TrustLineFlag.authorizedFlag,
          setFlags: TrustLineFlag.frozenFlag,
          trustor: StellarPublicKey.fromAddress(_source)),
    );
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000015000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000000000000100000002");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _clawbackClaimableBalance() {
  test("Clawback Claimable Balance", () {
    final operation = Operation(
      body: ClawbackClaimableBalanceOperation(ClaimableBalanceIdV0(
          BytesUtils.fromHexString(
              "da0d57da7d4850e7fc10d2a9d0ebc731f7afb40574c03395b17d49149b91f5be"))),
    );
    expect(operation.toXDRHex(),
        "000000000000001400000000da0d57da7d4850e7fc10d2a9d0ebc731f7afb40574c03395b17d49149b91f5be");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _clawback() {
  test("Clawback", () {
    final operation = Operation(
      sourceAccount: MuxedAccount(_mSource),
      body: ClawbackOperation(
          amount: StellarHelper.toStroop("1.31098"),
          asset: StellarAssetNative(),
          from: MuxedAccount(_source)),
    );
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f0000001300000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000000c80a28");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _revokeSponsorshipOperation() {
  test("Revoke Sponsorship 3", () {
    final operation = Operation(
      body: RevokeSponsorshipOperation(RevokeSponsorshipSigner(
          accountId: StellarPublicKey.fromAddress(_source),
          signerKey: SignerKeyPreAuthTx(BytesUtils.fromHexString(
              "22727193e194afaf799178f15916fd88d4e85a764d5773e2b54cda0d98e32777")))),
    );
    expect(operation.toXDRHex(),
        "000000000000001200000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000122727193e194afaf799178f15916fd88d4e85a764d5773e2b54cda0d98e32777");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Revoke Sponsorship 2", () {
    final operation = Operation(
      body: RevokeSponsorshipOperation(RevokeSponsorshipSigner(
          accountId: StellarPublicKey.fromAddress(_source),
          signerKey: SignerKeyHashX(BytesUtils.fromHexString(
              "a614642004ec1ef7b26d67a4e3a0b19798169f2d2a68ef09af03f66ce474e141")))),
    );
    expect(operation.toXDRHex(),
        "000000000000001200000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000002a614642004ec1ef7b26d67a4e3a0b19798169f2d2a68ef09af03f66ce474e141");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Revoke Sponsorship", () {
    final operation = Operation(
      body: RevokeSponsorshipOperation(RevokeSponsorshipSigner(
          accountId: StellarPublicKey.fromAddress(_source),
          signerKey: SignerKeyEd25519(_source.keyBytes()))),
    );
    expect(operation.toXDRHex(),
        "000000000000001200000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _endSponsoringFutureReservesOperation() {
  test("End Sponsoring Future Reserves", () {
    final operation = Operation(
      sourceAccount: MuxedAccount(_mSource),
      body: const EndSponsoringFutureReservesOperation(),
    );
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000011");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _beginSponsoringFutureReservesOperation() {
  test("Begin Sponsoring Future Reserve", () {
    final operation = Operation(
      body: BeginSponsoringFutureReservesOperation(
          StellarPublicKey.fromAddress(_source)),
    );
    expect(operation.toXDRHex(),
        "0000000000000010000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _claimClaimbleBalance() {
  test("Claim Claimable Balance", () {
    final operation = Operation(
      body: ClaimClaimableBalanceOperation(ClaimableBalanceIdV0(
          BytesUtils.fromHexString(
              "da0d57da7d4850e7fc10d2a9d0ebc731f7afb40574c03395b17d49149b91f5be"))),
    );
    expect(operation.toXDRHex(),
        "000000000000000f00000000da0d57da7d4850e7fc10d2a9d0ebc731f7afb40574c03395b17d49149b91f5be");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _createClaimableBalance() {
  test("Create Claimable Balance", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateBeforeRelativeTime(BigInt.from(123123)))
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000100000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000005000000000001e0f3");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Create Claimable Balance 2", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateBeforeRelativeTime(BigInt.from(123123))),
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateBeforeAbsoluteTime(BigInt.from(1)))
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000200000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000005000000000001e0f300000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000040000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });

  test("Create Claimable Balance 3", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate:
                  ClaimPredicateNot(const ClaimPredicateUnconditional())),
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000100000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000030000000100000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Create Claimable Balance 4", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateAnd([
                const ClaimPredicateUnconditional(),
                ClaimPredicateBeforeAbsoluteTime(BigInt.from(1)),
              ])),
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000100000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000010000000200000000000000040000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Create Claimable Balance 5", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateBeforeRelativeTime(BigInt.from(123123))),
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateBeforeAbsoluteTime(BigInt.from(1))),
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate:
                  ClaimPredicateNot(const ClaimPredicateUnconditional())),
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateAnd([
                const ClaimPredicateUnconditional(),
                ClaimPredicateBeforeAbsoluteTime(BigInt.from(1)),
              ])),
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000400000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000005000000000001e0f300000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000004000000000000000100000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000003000000010000000000000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000010000000200000000000000040000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Create Claimable Balance 6", () {
    final operation = Operation(
        body: CreateClaimableBalanceOperation(
            amount: StellarHelper.toStroop("11.000349"),
            asset: _asset,
            claimants: [
          ClaimantV0(
              destination: StellarPublicKey.fromAddress(_source),
              predicate: ClaimPredicateOr([
                ClaimPredicateAnd([
                  const ClaimPredicateUnconditional(),
                  ClaimPredicateBeforeAbsoluteTime(BigInt.from(1)),
                ]),
                ClaimPredicateBeforeAbsoluteTime(BigInt.from(1)),
              ])),
        ]));
    expect(operation.toXDRHex(),
        "000000000000000e000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000068e85220000000100000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000200000002000000010000000200000000000000040000000000000001000000040000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _pathPaymentStrictSend() {
  test("Path payment strict send", () {
    final operation = Operation(
        body: PathPaymentStrictSendOperation(
            destAsset: _asset,
            destMin: StellarHelper.toStroop("123"),
            destination: MuxedAccount(_mSource),
            sendAmount: StellarHelper.toStroop("223"),
            sendAsset: _asset2,
            path: [_asset, _asset2]));
    expect(operation.toXDRHex(),
        "000000000000000d000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000084eb198000000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000049504f8000000002000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Path payment strict send 2", () {
    final operation = Operation(
        body: PathPaymentStrictSendOperation(
      destAsset: _asset,
      destMin: StellarHelper.toStroop("123"),
      destination: MuxedAccount(_source),
      sendAmount: StellarHelper.toStroop("223"),
      sendAsset: _asset2,
    ));
    expect(operation.toXDRHex(),
        "000000000000000d000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000084eb1980000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000049504f8000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _manageBuyOffer() {
  test("Manage buy offer", () {
    final operation = Operation(
        body: ManageBuyOfferOperation(
            buyAmount: StellarHelper.toStroop("322.123312"),
            buying: _asset,
            selling: _asset2,
            offerId: BigInt.from(123123123),
            price: StellarPrice.fromDecimal("10.18")));
    expect(operation.toXDRHex(),
        "000000000000000c000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000c0001de0000001fd00000032000000000756b5b3");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _bumpSeq() {
  test("Bump Sequence", () {
    final operation = Operation(body: BumpSequenceOperation(BigInt.from(1123)));
    expect(operation.toXDRHex(), "000000000000000b0000000000000463");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _manageData() {
  test("Manage data", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: ManageDataOperation(
            dataName: "https://github.com/mrtnetwork",
            dataValue: BytesUtils.fromHexString(
                "26eaca10832065dcfb46eba9c6f34d83f7b9a303b10ea318d8b3cf20cd77a24d")));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f0000000a0000001d68747470733a2f2f6769746875622e636f6d2f6d72746e6574776f726b000000000000010000002026eaca10832065dcfb46eba9c6f34d83f7b9a303b10ea318d8b3cf20cd77a24d");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _accountMerge() {
  test("account merge", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: AccountMergeOperation(MuxedAccount(_source)));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000008000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _allowTrust() {
  test("allow trust", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: AllowTrustOperation(
          asset: AssetCode4.fromString("MRT"),
          authorize: TrustAuthFlag.authorized,
          trustor: StellarPublicKey.fromAddress(_source),
        ));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000007000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000014d52540000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _changeTrust() {
  test("change trust", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: ChangeTrustOperation(
            asset: _asset, limit: StellarHelper.toStroop("1")));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000006000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000000989680");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _passiveSellOffer() {
  test("manage sell offer", () {
    final operation = Operation(
        body: CreatePassiveSellOfferOperation(
            amount: StellarHelper.toStroop("12.190123"),
            buying: _asset,
            selling: _asset2,
            price: StellarPrice.fromDecimal("100000.230129834")));
    expect(operation.toXDRHex(),
        "0000000000000004000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000074410ae56c44536000038dd");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _manageSellOffer() {
  test("manage sell offer 2", () {
    final operation = Operation(
        body: ManageSellOfferOperation(
            amount: StellarHelper.toStroop("0.1"),
            buying: _asset,
            selling: _asset2,
            offerId: BigInt.one,
            price: StellarPrice.fromDecimal("0.321023")));
    expect(operation.toXDRHex(),
        "0000000000000003000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000000f42400004e5ff000f42400000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("manage sell offer with source", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: ManageSellOfferOperation(
            amount: StellarHelper.toStroop("0.1"),
            buying: _asset,
            selling: _asset2,
            offerId: BigInt.one,
            price: StellarPrice.fromDecimal("0.321023")));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f00000003000000014d525400000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000000f42400004e5ff000f42400000000000000001");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _createAccount() {
  test("create account", () {
    final operation = Operation(
        body: CreateAccountOperation(
            startingBalance: StellarHelper.toStroop("0.3"),
            destination: StellarPublicKey.fromAddress(_source)));
    expect(operation.toXDRHex(),
        "0000000000000000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c00000000002dc6c0");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _payment() {
  test("payment", () {
    final operation = Operation(
        body: PaymentOperation(
            amount: StellarHelper.toStroop("1"),
            asset: _asset,
            destination: MuxedAccount(_source)));
    expect(operation.toXDRHex(),
        "0000000000000001000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000000989680");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("payment destination muxed address", () {
    final operation = Operation(
        body: PaymentOperation(
            amount: StellarHelper.toStroop("1"),
            asset: _asset,
            destination: MuxedAccount(_mSource)));
    expect(operation.toXDRHex(),
        "000000000000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000000989680");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("payment destination and source muxed address", () {
    final operation = Operation(
        sourceAccount: MuxedAccount(_mSource),
        body: PaymentOperation(
            amount: StellarHelper.toStroop("1"),
            asset: _asset,
            destination: MuxedAccount(_mSource)));
    expect(operation.toXDRHex(),
        "0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f0000000100000100000000000000000c8b2c5d180991797e1391882384949b3638e501ba398e4377075ad95ad9ab3f2f000000024d52544e4554574f524b0000000000008a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c0000000000989680");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _inflation() {
  test("inflation with source", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final operation = Operation(
        body: InflationOperation(), sourceAccount: MuxedAccount(source));
    expect(operation.toXDRHex(),
        "0000000100000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef00000009");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("inflation without source", () {
    final operation = Operation(body: InflationOperation());
    expect(operation.toXDRHex(), "0000000000000009");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _setOptions() {
  test("Set Options", () {
    final operation = Operation(body: SetOptionsOperation());
    expect(operation.toXDRHex(),
        "0000000000000005000000000000000000000000000000000000000000000000000000000000000000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Set Options 2", () {
    final operation = Operation(
        body: SetOptionsOperation(
            clearFlags: AuthFlag.requiredFlag,
            highThreshold: 2,
            homeDomain: "https://github.com/mrtnetwork"));
    expect(operation.toXDRHex(),
        "0000000000000005000000000000000100000001000000000000000000000000000000000000000100000002000000010000001d68747470733a2f2f6769746875622e636f6d2f6d72746e6574776f726b00000000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Set Options 3", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final operation = Operation(
      sourceAccount: MuxedAccount(source),
      body: SetOptionsOperation(
          clearFlags: AuthFlag.requiredFlag,
          highThreshold: 2,
          homeDomain: "https://github.com/mrtnetwork",
          inflationDest: StellarPublicKey.fromAddress(source)),
    );
    expect(operation.toXDRHex(),
        "0000000100000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef000000050000000100000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef0000000100000001000000000000000000000000000000000000000100000002000000010000001d68747470733a2f2f6769746875622e636f6d2f6d72746e6574776f726b00000000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
  test("Set Options 4", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final operation = Operation(
      sourceAccount: MuxedAccount(source),
      body: SetOptionsOperation(
          clearFlags: AuthFlag.requiredFlag,
          highThreshold: 2,
          homeDomain: "https://github.com/mrtnetwork",
          inflationDest: StellarPublicKey.fromAddress(source),
          signer: Signer(
              key: SignerKeyPreAuthTx(BytesUtils.fromHexString(
                  "2c45367217c8a5128341505afc8bc78ac425475c3bf58fa4c1cfd2391169d8ee")),
              weight: 5)),
    );
    expect(operation.toXDRHex(),
        "0000000100000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef000000050000000100000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef0000000100000001000000000000000000000000000000000000000100000002000000010000001d68747470733a2f2f6769746875622e636f6d2f6d72746e6574776f726b00000000000001000000012c45367217c8a5128341505afc8bc78ac425475c3bf58fa4c1cfd2391169d8ee00000005");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}

void _pathPaymentStrictReceiveOperation() {
  test("PathPaymentStrictReceiveOperation", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final asset1 = StellarAssetCreditAlphanum12(
        code: "MRTNETWORK", issuer: StellarPublicKey.fromAddress(source));
    final operation = Operation(
      body: PathPaymentStrictReceiveOperation(
          sendAsset: asset1,
          sendMax: BigInt.from(10000000),
          destination: MuxedAccount(source),
          destAsset: asset1,
          destAmount: BigInt.from(10000000),
          path: []),
    );
    expect(operation.toXDRHex(),
        "0000000000000002000000024d52544e4554574f524b000000000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef000000000098968000000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef000000024d52544e4554574f524b000000000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef000000000098968000000000");
    final decode = Operation.fromXdr(operation.toXDR());
    expect(operation.toXDRHex(), decode.toXDRHex());
  });
}
