import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/core/core/core.dart';

/// v2 base for generated Stellar-RPC (ex-Soroban) JSON-RPC requests.
///
/// Matches generator `--client-json-rpc` output (`jsonRpcMethod` + `body()`).
/// Transport matches the shared [StellarProvider]/[StellarRequestDetails]
/// stack so old and new clients can share it.
abstract class StellarRpcRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  const StellarRpcRequest();

  String? get path => null;
  String? get jsonRpcMethod;
  dynamic body({JsonifyConfig config = DefaultJsonifyConfig.defaultConfig});

  @override
  RequestMethod get requestMethod => RequestMethod.post;

  Map<String, dynamic>? _params() {
    final b = body();
    if (b == null) return null;
    if (b is Map<String, dynamic>) {
      final m = {...b}..removeWhere((k, v) => v == null);
      return m.isEmpty ? null : m;
    }
    return null;
  }

  @override
  StellarRequestDetails buildRequest(int requestID) {
    return StellarRequestDetails(
      requestID: requestID,
      path: '',
      headers: ServiceConst.defaultPostHeaders,
      bodyString: StringUtils.fromJson(
        ServiceProviderUtils.buildJsonRPCParams(
          requestId: requestID,
          method: jsonRpcMethod ?? '',
          params: _params(),
        ),
      ),
      requestMethod: requestMethod,
      api: StellarAPIType.soroban,
      responseEncoding: ServiceReponseEncoding.map,
    );
  }
}
