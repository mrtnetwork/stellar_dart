import 'package:blockchain_utils/utils/string/string.dart';
import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/exception/exception.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/service/service.dart';

/// Facilitates communication with the stellar horizon api by making requests using a provided [HorizonProvider].
class HorizonProvider {
  /// The underlying horizon service provider used for network communication.
  final StellarServiceProvider rpc;

  /// Constructs a new [HorizonProvider] instance with the specified [rpc] service provider.
  HorizonProvider(this.rpc);

  int _id = 0;

  static dynamic _parseResponse(
      HorizonServiceResponse val, HorizonRequestDetails request) {
    final Map<String, dynamic>? response = StringUtils.tryToJson(val.body);
    if (response == null) {
      throw HorizonAPIError(message: val.body, errorCode: val.statusCode);
    }
    if (val.success) {
      if (request.apiType == StellarAPIType.soroban) {
        final error = response["error"];
        if (error != null) {
          throw HorizonAPIError(
              message: error["message"] ?? val.body,
              errorCode: int.tryParse(error["code"]?.toString() ?? ""),
              extras: Map<String, dynamic>.from(error));
        }
        return response["result"];
      }
      return response;
    }
    if (response.containsKey("errorResultXdr")) {
      return response;
    }
    throw HorizonAPIError(
        message: response["detail"] ?? response["title"] ?? val.body,
        type: response["type"],
        errorCode: int.tryParse(response["status"]?.toString() ?? ""),
        extras: response["extras"]);
  }

  /// Sends a request to the stellar network using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  /// Whatever is received will be returned
  Future<dynamic> requestDynamic(HorizonRequestParam request,
      [Duration? timeout]) async {
    final id = ++_id;
    final params = request.toRequest(id);
    final data = params.requestType == APIRequestType.post
        ? await rpc.post(params, timeout)
        : await rpc.get(params, timeout);
    return _parseResponse(data, params);
  }

  /// Sends a request to the stellar network using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  Future<T> request<T, E>(HorizonRequestParam<T, E> request,
      [Duration? timeout]) async {
    final data = await requestDynamic(request, timeout);
    final Object result;
    if (E == List<Map<String, dynamic>>) {
      result = (data as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList();
    } else {
      result = data;
    }
    return request.onResonse(result as E);
  }
}
