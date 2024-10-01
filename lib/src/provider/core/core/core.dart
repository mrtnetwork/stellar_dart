import 'package:blockchain_utils/utils/string/string.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/utils/utils.dart';

enum APIRequestType { get, post }

enum StellarAPIType { horizon, soroban }

abstract class HorizonRequestParams {
  abstract final String method;
}

abstract class HorizonRequestParam<RESULT, RESPONSE>
    implements HorizonRequestParams {
  const HorizonRequestParam({this.paginationParams});
  final HorizonPaginationParams? paginationParams;
  List<String> get pathParameters => [];
  Map<String, dynamic> get queryParameters => {};

  RESULT onResonse(RESPONSE result) {
    return result as RESULT;
  }

  HorizonRequestDetails toRequest(int v) {
    final pathParams = StellarProviderUtils.extractParams(method);
    if (pathParams.length != pathParameters.length) {
      throw DartStellarPlugingException("Invalid Path Parameters.",
          details: {"pathParams": pathParameters, "excepted": pathParams});
    }
    String params = method;
    for (int i = 0; i < pathParams.length; i++) {
      params = params.replaceFirst(pathParams[i], pathParameters[i]);
    }
    final Map<String, dynamic> query = {
      ...queryParameters,
      ...paginationParams?.toJson() ?? {}
    }..removeWhere((k, v) => v == null);

    if (query.isNotEmpty) {
      params = Uri.parse(params)
          .replace(queryParameters: query)
          .normalizePath()
          .toString();
    }
    return HorizonRequestDetails(id: v, pathParams: params);
  }
}

abstract class HorizonPostRequestParam<RESULT, RESPONSE>
    extends HorizonRequestParam<RESULT, RESPONSE> {
  const HorizonPostRequestParam();
  Object? get body => null;

  final Map<String, String>? header = null;

  @override
  HorizonRequestDetails toRequest(int v) {
    final request = super.toRequest(v);
    return request.copyWith(header: header, requestType: APIRequestType.post);
  }
}

abstract class SorobanRequestParam<RESULT, RESPONSE>
    extends HorizonRequestParam<RESULT, RESPONSE> {
  final SorobanPaginationParams? pagination;
  const SorobanRequestParam({this.pagination});
  Map<String, dynamic>? get params => null;

  final Map<String, String>? header = null;

  @override
  HorizonRequestDetails toRequest(int v) {
    return HorizonRequestDetails(
        id: v,
        pathParams: '',
        header: header ?? {},
        body: StringUtils.fromJson(
            {"id": v, "params": params, "jsonrpc": "2.0", "method": method}),
        requestType: APIRequestType.post,
        apiType: StellarAPIType.soroban);
  }
}

class HorizonRequestDetails {
  const HorizonRequestDetails(
      {required this.id,
      required this.pathParams,
      this.header = const {},
      this.requestType = APIRequestType.get,
      this.apiType = StellarAPIType.horizon,
      this.body});

  HorizonRequestDetails copyWith({
    int? id,
    String? pathParams,
    APIRequestType? requestType,
    Map<String, String>? header,
    Object? body,
    StellarAPIType? apiType,
  }) {
    return HorizonRequestDetails(
        id: id ?? this.id,
        pathParams: pathParams ?? this.pathParams,
        requestType: requestType ?? this.requestType,
        header: header ?? this.header,
        body: body ?? this.body,
        apiType: apiType ?? this.apiType);
  }

  /// Unique identifier for the request.
  final int id;

  /// URL path parameters
  final String pathParams;

  final APIRequestType requestType;

  final Map<String, String> header;

  final Object? body;
  final StellarAPIType apiType;

  /// Generates the complete request URL by combining the base URI and method-specific URI.
  String url({required String horizonUri, String? sorobanUri}) {
    if (apiType == StellarAPIType.soroban && sorobanUri == null) {
      throw const DartStellarPlugingException(
          "Please provide the Soroban API provider URL before sending a Soroban request.");
    }
    if (apiType == StellarAPIType.soroban) return sorobanUri!;
    String url = horizonUri;
    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }
    final finalUrl = "$url$pathParams";
    return finalUrl;
  }
}
