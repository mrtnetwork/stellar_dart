import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:blockchain_utils/networks/types/network.dart';
import 'package:blockchain_utils/service/service.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// Facilitates communication with the stellar horizon api by making requests using a provided [StellarProvider].
class StellarProvider<SERVICE extends IServiceProvider>
    implements IProvider<SERVICE, StellarRequestDetails> {
  /// The underlying horizon service provider used for network communication.
  @override
  final SERVICE service;

  StellarProvider(this.service);

  static SERVICERESPONSE _findError<SERVICERESPONSE>({
    required BaseServiceResponse response,
    required StellarRequestDetails params,
  }) {
    if (response.type == ServiceResponseType.error) {
      final error = response.cast<BaseServiceErrorResponse>();
      if (!error.validate) throw error.defaultError();
      if (params.api == StellarAPIType.horizon) {
        final toJson = error.tryToJson();
        throw RPCError(
          message:
              toJson?.valueAsString<String?>("detail") ??
              toJson?.valueAsString<String>("title") ??
              ServiceConst.defaultError,
          jsonRpcErrpr: toJson,
          errorCode: toJson?.valueAsInt("status"),
          statusCode: response.statusCode,
          relatedNetwork: BlockchainNetwork.stellar,
        );
      }
    }
    final r = params.toEncodingResponse<Map<String, dynamic>>(response);
    if (params.api == StellarAPIType.soroban) {
      final error = r['error'];
      if (error != null) {
        final message = error['message'];
        throw RPCError(
          message: (message is String ? message : ServiceConst.defaultError),
          errorCode: IntUtils.tryParse(error['code']),
          jsonRpcErrpr: r,
          relatedNetwork: BlockchainNetwork.stellar,
          statusCode: response.statusCode,
        );
      }
      return ServiceProviderUtils.toResponse<SERVICERESPONSE>(
        object: r['result'],
        params: params,
      );
    }
    return ServiceProviderUtils.toResponse<SERVICERESPONSE>(
      object: r,
      params: params,
    );
  }

  /// The unique identifier for each JSON-RPC request.
  int _id = 0;

  /// Sends a request to the stellar network (horizon) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  @override
  Future<RESULT> request<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails> request, {
    Duration? timeout,
  }) async {
    final r = await requestDynamic<RESULT, SERVICERESPONSE>(
      request,
      timeout: timeout,
    );
    return request.onResonse(r);
  }

  /// Sends a request to the stellar network (Horizon) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  /// Whatever is received will be returned
  @override
  Future<SERVICERESPONSE> requestDynamic<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, StellarRequestDetails> request, {
    Duration? timeout,
  }) async {
    final params = request.buildRequest(_id++);
    final response = await service.doRequest(params, timeout: timeout);
    return _findError<SERVICERESPONSE>(params: params, response: response);
  }
}
