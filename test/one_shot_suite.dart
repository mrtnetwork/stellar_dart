import 'utils.dart';
import 'backend_identity_test.dart' as f12;
import 'address_test.dart' as f0;
import 'assets_test.dart' as f1;
import 'contract_spec_test.dart' as f2;
import 'enocde_request_params_test.dart' as f3;
import 'exception_test.dart' as f4;
import 'number_test.dart' as f5;
import 'operation_test.dart' as f6;
import 'p30_xdr_test.dart' as f7;
import 'quick_assemble_test.dart' as f8;
import 'quick_classic_test.dart' as f9;
import 'sc_address_p30_test.dart' as f10;
import 'transaction_test.dart' as f11;

Future<void> runOneShotSuite() async {
  StellarTestApi.runTest(() {
    f12.backendIdentityTest();
    f0.addressTest();
    f1.assetsTest();
    f2.contractSpecTest();
    f3.encodeRequestParamsTest();
    f4.exceptionTest();
    f5.numberTest();
    f6.operationTest();
    f7.p30XdrTest();
    f8.quickAssembleTest();
    f9.quickClassicTest();
    f10.scAddressP30Test();
    f11.transactionTest();
  }, 'Stellar One Shot');
}
