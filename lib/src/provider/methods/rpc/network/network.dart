import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// General information about the currently configured network.
/// This response will contain all the information needed to successfully submit transactions to the network this node serves.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getNetwork
class SorobanRequestGetNetwork
    extends SorobanRequestParam<SorobanNetworkResponse, Map<String, dynamic>> {
  SorobanRequestGetNetwork();

  @override
  String get method => SorobanAPIMethods.getNetwork.name;
  @override
  SorobanNetworkResponse onResonse(Map<String, dynamic> result) {
    return SorobanNetworkResponse.fromJson(result);
  }
}
