import 'package:blockchain_utils/service/models/params.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

typedef StellarServiceResponse<T> = BaseServiceResponse<T>;

/// A mixin defining the service provider contract for interacting with the Ton network.
mixin StellarServiceProvider
    implements BaseServiceProvider<StellarRequestDetails> {
  /// Example:
  /// @override
  /// Future<`StellarServiceResponse<T>`> doRequest<`T`>(StellarRequestDetails params,
  ///     {Duration? timeout}) async {
  /// if (params.type.isPostRequest) {
  ///   final response = await client
  ///       .post(params.toUri(corretUrl),
  ///           headers: params.headers, body: params.body())
  ///       .timeout(timeout ?? defaultRequestTimeout);
  ///   return params.toResponse(response.bodyBytes, response.statusCode);
  /// }
  /// final response = await client
  ///     .get(params.toUri(corretUrl), headers: params.headers)
  ///     .timeout(timeout ?? defaultRequestTimeout);
  /// return params.toResponse(response.bodyBytes, response.statusCode);
  /// }
  @override
  Future<StellarServiceResponse<T>> doRequest<T>(
    StellarRequestDetails params, {
    Duration? timeout,
  });
}
