import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

typedef StellarServiceResponse = BaseServiceResponse;

/// A mixin defining the service provider contract for interacting with the Stellar network.
mixin StellarServiceProvider
    implements
        IServiceProvider<StellarRequestDetails, BaseGRPCServiceRequestParams> {
  @override
  Future<StellarServiceResponse> doRequest(
    StellarRequestDetails params, {
    Duration? timeout,
  });

  @override
  Future<BaseServiceSubscribtionResponse> doSubscribtionRequest({
    required StellarRequestDetails params,
    required BaseServiceSubscribtionRequest<
      dynamic,
      dynamic,
      BaseSubscribtionEvent<dynamic>,
      StellarRequestDetails
    >
    request,
    Duration? timeout,
  }) {
    throw const BuError(DefaultErrorType.unsupported, 
      "Subscription requests are not supported by this service.",
    );
  }

  @override
  Future<List<int>> doGrpcRequest(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(DefaultErrorType.unsupported, 
      "gRPC requests are not supported by this service.",
    );
  }

  @override
  Stream<List<int>> doGrpcRequestStream(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(DefaultErrorType.unsupported, 
      "gRPC requests are not supported by this service.",
    );
  }

  @override
  Future<Stream<List<int>>> doGrpcRequestStreamAsync(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(DefaultErrorType.unsupported, 
      "gRPC requests are not supported by this service.",
    );
  }
}
