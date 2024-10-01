import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// General node health check.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getHealth
class SorobanRequestGetHealth
    extends SorobanRequestParam<SorobanHealthResponse, Map<String, dynamic>> {
  SorobanRequestGetHealth();

  @override
  String get method => SorobanAPIMethods.getHealth.name;
  @override
  SorobanHealthResponse onResonse(Map<String, dynamic> result) {
    return SorobanHealthResponse.fromJson(result);
  }
}
