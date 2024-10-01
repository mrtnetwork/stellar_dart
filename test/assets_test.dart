import 'package:stellar_dart/src/address/address.dart';
import 'package:stellar_dart/src/keypair/crypto/public_key.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:test/test.dart';

void main() {
  _asset();
}

void _asset() {
  test("native asset", () {
    final asset = StellarAssetNative();
    expect(asset.toVariantXDRHex(), "00000000");
    final decode = StellarAsset.fromXdr(asset.toVariantXDR());
    expect(decode.toVariantXDRHex(), asset.toVariantXDRHex());
  });
  test("CreditAlphanum4  asset", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final asset = StellarAssetCreditAlphanum4(
        code: "MRT", issuer: StellarPublicKey.fromAddress(source));
    expect(asset.toVariantXDRHex(),
        "000000014d52540000000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef");
    final decode = StellarAsset.fromXdr(asset.toVariantXDR());
    expect(decode.toVariantXDRHex(), asset.toVariantXDRHex());
  });
  test("CreditAlphanum12  asset", () {
    final source = StellarAccountAddress(
        "GCEZWKCA5VLDNRLN3RPRJMRZOX3Z6G5CHCGSNFHEYVXM3XOJMDS674JZ");
    final asset = StellarAssetCreditAlphanum12(
        code: "MRTNETWORK", issuer: StellarPublicKey.fromAddress(source));
    expect(asset.toVariantXDRHex(),
        "000000024d52544e4554574f524b000000000000899b2840ed5636c56ddc5f14b23975f79f1ba2388d2694e4c56ecdddc960e5ef");
    final decode = StellarAsset.fromXdr(asset.toVariantXDR());
    expect(decode.toVariantXDRHex(), asset.toVariantXDRHex());
  });
}
