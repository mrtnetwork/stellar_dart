import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';

void main() {
  test("IAddress encoding", () {
    {
      final addr = StellarContractAddress(
        'CAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAIBAEAQCAKAL',
      );
      expect(
        addr,
        StellarAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
      );
    }
    {
      final addr = StellarAccountAddress(
        'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR',
      );
      expect(
        addr,
        StellarAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
      );
    }
    {
      final addr = StellarMuxedAddress(
        'MCFSYXIYBGIXS7QTSGECHBEUTM3DRZIBXI4Y4Q3XA5NNSWWZVM7S6AAAAAAAAAAABSLHA',
      );
      expect(
        addr,
        StellarAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
      );
    }
  });
}
