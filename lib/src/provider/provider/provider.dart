import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:blockchain_utils/service/service.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/service/service.dart';

/// Facilitates communication with the stellar horizon api by making requests using a provided [StellarProvider].
class StellarProvider implements BaseProvider<StellarRequestDetails> {
  /// The underlying horizon service provider used for network communication.
  final StellarServiceProvider rpc;

  /// Constructs a new [StellarProvider] instance with the specified [rpc] service provider.
  StellarProvider(this.rpc);

  static SERVICERESPONSE _findError<SERVICERESPONSE>({
    required BaseServiceResponse<Map<String, dynamic>> response,
    required StellarRequestDetails params,
  }) {
    final Map<String, dynamic> r = response.getResult(params);
    if (params.apiType == StellarAPIType.soroban) {
      final error = r['error'];
      if (error != null) {
        throw RPCError(
          message: error['message']?.toString() ?? '',
          errorCode: IntUtils.tryParse(error['code']),
          details: Map<String, dynamic>.from(error),
        );
      }
      return ServiceProviderUtils.parseResponse(
        object: r['result'],
        params: params,
      );
    }
    return ServiceProviderUtils.parseResponse(object: r, params: params);
  }

  /// The unique identifier for each JSON-RPC request.
  int _id = 0;

  /// Sends a request to the stellar network (horizon) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  @override
  Future<RESULT> request<RESULT, SERVICERESPONSE>(
    BaseServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails>
    request, {
    Duration? timeout,
  }) async {
    final r = await requestDynamic(request, timeout: timeout);
    return request.onResonse(r);
  }

  /// Sends a request to the stellar network (Horizon) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  /// Whatever is received will be returned
  @override
  Future<SERVICERESPONSE> requestDynamic<RESULT, SERVICERESPONSE>(
    BaseServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails>
    request, {
    Duration? timeout,
  }) async {
    final params = request.buildRequest(_id++);
    final response = await rpc.doRequest<Map<String, dynamic>>(
      params,
      timeout: timeout,
    );
    return _findError(params: params, response: response);
  }
}
