import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';
import 'utils.dart';

/// Phase 1 / Step 1: CAP-84 muxed contract (`W`) addresses and the completed
/// `ScAddress` union (6 arms per stellar-xdr v30.0).
void main() {
  StellarTestApi.runTest(scAddressP30Test, 'ScAddressP30');
}

void scAddressP30Test() {

  // Contract id from the SEP-23 examples; W vectors cross-checked with an
  // independent strkey implementation (version byte 22 << 3).
  const contractIdHex =
      '3f0c34bf93ad0d9971d04ccc90f705511c838aad9734a4a2fb0d7a03fc7fe89a';
  const contractBase =
      'CA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUWDA';
  const wZero =
      'WA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAAAAAAAAAWWC';
  const wOne =
      'WA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJUAAAAAAAAAAAAEGHC';
  const wMax =
      'WA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJV7777777777777GMO';

  test('W address parsing and base mapping', () {
    final w = StellarMuxedContractAddress(wZero);
    expect(w.id, BigInt.zero);
    expect(w.baseAddress, contractBase);
    expect(w.toString(), wZero);
    expect(w.toContractAddress(), StellarContractAddress(contractBase));

    final fromId = StellarMuxedContractAddress.fromContractId(
      contractId: BytesUtils.fromHexString(contractIdHex),
      id: BigInt.one,
    );
    expect(fromId.toString(), wOne);

    expect(
      StellarAddress.fromBase32Addr(wOne),
      isA<StellarMuxedContractAddress>(),
    );
    expect(
      StellarAddress.deserializeIAddress(bytes: fromId.encodeAsIAddress()),
      fromId,
    );
  });

  test('W address requires contract type', () {
    expect(() => StellarMuxedContractAddress(contractBase), throwsA(anything));
    expect(
      () => StellarMuxedContractAddress.fromContractId(
        contractId: List<int>.filled(31, 0),
        id: BigInt.zero,
      ),
      throwsA(anything),
    );
  });

  T roundTrip<T extends ScAddress>(T address) {
    final decoded = ScAddress.fromStruct(
      ScAddress.layout().deserialize(address.toVariantXDR()).value,
    );
    expect(decoded.runtimeType, address.runtimeType);
    expect(decoded.toVariantXDR(), address.toVariantXDR());
    return decoded as T;
  }

  test('ScAddress muxedContract arm (CAP-84)', () {
    final sc = ScAddressMuxedContract.fromBase32Address(wMax);
    expect(sc.id, BigInt.parse('18446744073709551615'));
    expect(
      BytesUtils.toHexString(sc.toLayoutStruct()['contractId'] as List<int>),
      contractIdHex,
    );
    final back = roundTrip(sc);
    expect((back.address as StellarMuxedContractAddress).toString(), wMax);
    expect(
      ScAddress.fromAddress(StellarMuxedContractAddress(wOne)),
      isA<ScAddressMuxedContract>(),
    );
  });

  test('ScAddress muxedAccount arm', () {
    const muxed =
        'MCFSYXIYBGIXS7QTSGECHBEUTM3DRZIBXI4Y4Q3XA5NNSWWZVM7S6AAAAAAAAAAABSLHA';
    final sc = ScAddress.fromAddress(StellarMuxedAddress(muxed));
    expect(sc, isA<ScAddressMuxedAccount>());
    final back = roundTrip(sc);
    expect((back.address as StellarMuxedAddress).toString(), muxed);
    expect(
      StellarMuxedAddress(muxed).toScAddress(),
      isA<ScAddressMuxedAccount>(),
    );
  });

  test('ScAddress claimableBalance and liquidityPool arms', () {
    final cb = ScAddressClaimableBalance(
      ClaimableBalanceIdV0(BytesUtils.fromHexString(contractIdHex)),
    );
    final cbBack = roundTrip(cb);
    expect(
      BytesUtils.toHexString((cbBack.balanceId as ClaimableBalanceIdV0).hash),
      contractIdHex,
    );

    final lp = ScAddressLiquidityPool(BytesUtils.fromHexString(contractIdHex));
    roundTrip(lp);
  });

  test('ScAddress union rejects unknown arms', () {
    expect(() => ScAddressType.fromName('nope'), throwsA(anything));
  });
}
