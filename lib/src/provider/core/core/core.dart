import 'package:blockchain_utils/service/service.dart';
import 'package:blockchain_utils/utils/string/string.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/utils/utils.dart';

enum APIRequestType { get, post }

enum StellarAPIType { horizon, soroban }

abstract class HorizonRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  const HorizonRequest({this.paginationParams});
  final HorizonPaginationParams? paginationParams;
  List<String> get pathParameters => [];
  Map<String, dynamic> get queryParameters => {};
  Map<String, String>? get headers => null;
  abstract final String method;
  @override
  RequestServiceType get requestType => RequestServiceType.get;
  @override
  StellarRequestDetails buildRequest(int requestID) {
    final pathParams = StellarProviderUtils.extractParams(method);
    if (pathParams.length != pathParameters.length) {
      throw DartStellarPlugingException(
        'Invalid Path Parameters.',
        details: {'pathParams': pathParameters, 'expected': pathParams},
      );
    }
    String params = method;
    for (int i = 0; i < pathParams.length; i++) {
      params = params.replaceFirst(pathParams[i], pathParameters[i]);
    }
    final Map<String, dynamic> query = {
      ...queryParameters,
      ...paginationParams?.toJson() ?? {},
    }..removeWhere((k, v) => v == null);

    if (query.isNotEmpty) {
      params =
          Uri.parse(
            params,
          ).replace(queryParameters: query).normalizePath().toString();
    }
    return StellarRequestDetails(
      requestID: requestID,
      pathParams: params,
      headers: headers ?? ServiceConst.defaultPostHeaders,
      type: requestType,
    );
  }
}

abstract class HorizonPostRequest<RESULT, RESPONSE>
    extends HorizonRequest<RESULT, RESPONSE> {
  const HorizonPostRequest();
  @override
  RequestServiceType get requestType => RequestServiceType.post;
}

abstract class SorobanRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  abstract final String method;
  final SorobanPaginationParams? pagination;
  const SorobanRequest({this.pagination});
  Map<String, dynamic>? get params => null;
  @override
  RequestServiceType get requestType => RequestServiceType.post;

  @override
  StellarRequestDetails buildRequest(int requestID) {
    return StellarRequestDetails(
      requestID: requestID,
      pathParams: '',
      headers: ServiceConst.defaultPostHeaders,
      jsonBody: ServiceProviderUtils.buildJsonRPCParams(
        requestId: requestID,
        method: method,
        params: params,
      ),
      type: requestType,
      apiType: StellarAPIType.soroban,
    );
  }
}

class StellarRequestDetails extends BaseServiceRequestParams {
  const StellarRequestDetails({
    required super.requestID,
    required this.pathParams,
    required super.headers,
    required super.type,
    this.apiType = StellarAPIType.horizon,
    this.jsonBody,
  });

  StellarRequestDetails copyWith({
    int? requestID,
    String? pathParams,
    RequestServiceType? type,
    Map<String, String>? headers,
    Map<String, dynamic>? jsonBody,
    StellarAPIType? apiType,
  }) {
    return StellarRequestDetails(
      pathParams: pathParams ?? this.pathParams,
      jsonBody: jsonBody ?? this.jsonBody,
      apiType: apiType ?? this.apiType,
      headers: headers ?? this.headers,
      requestID: requestID ?? this.requestID,
      type: type ?? this.type,
    );
  }

  /// URL path parameters
  final String pathParams;

  // final Object? body;
  final StellarAPIType apiType;

  @override
  List<int>? body() {
    if (jsonBody != null) {
      return StringUtils.encode(StringUtils.fromJson(jsonBody!));
    }
    return null;
  }

  final Map<String, dynamic>? jsonBody;

  @override
  Map<String, dynamic> toJson() {
    return {
      'pahtParameters': pathParams,
      'body': jsonBody,
      'type': type.name,
      'apiType': apiType.name,
    };
  }

  @override
  Uri toUri(String uri) {
    if (apiType == StellarAPIType.soroban) return Uri.parse(uri);
    if (uri.endsWith('/')) {
      uri = uri.substring(0, uri.length - 1);
    }
    final finalUrl = '$uri$pathParams';
    return Uri.parse(finalUrl);
  }
}
