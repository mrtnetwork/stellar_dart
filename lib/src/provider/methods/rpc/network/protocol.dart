import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// Version information about the RPC and Captive core. RPC manages its own, pared-down
/// version of Stellar Core optimized for its own subset of needs. we'll refer to this as a "Captive Core" instance.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getVersionInfo
class SorobanRequestGetVersionInfo extends SorobanRequestParam<
    SorobanVersionInfoResponse, Map<String, dynamic>> {
  SorobanRequestGetVersionInfo();

  @override
  String get method => SorobanAPIMethods.getVersionInfo.name;
  @override
  SorobanVersionInfoResponse onResonse(Map<String, dynamic> result) {
    return SorobanVersionInfoResponse.fromJson(result);
  }
}
