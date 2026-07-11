import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/utils/utils.dart';

enum StellarAPIType {
  horizon(0),
  soroban(1);

  final int value;
  const StellarAPIType(this.value);
  static StellarAPIType fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ItemNotFoundException(name: "StellarAPIType"),
    );
  }
}

abstract class HorizonRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  const HorizonRequest({this.paginationParams});
  final HorizonPaginationParams? paginationParams;
  List<String> get pathParameters => [];
  Map<String, dynamic> get queryParameters => {};
  Map<String, String>? get headers => null;
  abstract final String method;
  @override
  RequestMethod get requestMethod => RequestMethod.get;
  @override
  StellarRequestDetails buildRequest(int requestID) {
    final pathParams = StellarProviderUtils.extractParams(method);
    if (pathParams.length != pathParameters.length) {
      throw DartStellarPlugingException(
        'Invalid Path Parameters.',
        details: {
          'pathParams': pathParameters.join(","),
          'expected': pathParams.join(","),
        },
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
      path: params,
      headers: headers ?? ServiceConst.defaultPostHeaders,
      errorStatusCodes: [504, 503, 410, 400, 404],
      requestMethod: requestMethod,
      responseEncoding: ServiceReponseEncoding.fromType<RESPONSE>(),
    );
  }
}

abstract class HorizonPostRequest<RESULT, RESPONSE>
    extends HorizonRequest<RESULT, RESPONSE> {
  const HorizonPostRequest();
  @override
  RequestMethod get requestMethod => RequestMethod.post;
}

abstract class SorobanRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  abstract final String method;
  final SorobanPaginationParams? pagination;
  const SorobanRequest({this.pagination});
  Map<String, dynamic>? get params => null;
  @override
  RequestMethod get requestMethod => RequestMethod.post;

  @override
  StellarRequestDetails buildRequest(int requestID) {
    return StellarRequestDetails(
      requestID: requestID,
      path: '',
      headers: ServiceConst.defaultPostHeaders,
      bodyString: StringUtils.fromJson(
        ServiceProviderUtils.buildJsonRPCParams(
          requestId: requestID,
          method: method,
          params: params,
        ),
      ),
      requestMethod: requestMethod,
      api: StellarAPIType.soroban,
      responseEncoding: ServiceReponseEncoding.map,
    );
  }
}

class StellarRequestDetails extends BaseServiceRequestParams {
  final StellarAPIType api;

  const StellarRequestDetails({
    required super.requestID,
    required super.path,
    required super.responseEncoding,
    required super.headers,
    super.successStatusCodes,
    super.errorStatusCodes,
    required super.requestMethod,
    super.bodyBytes,
    super.bodyString,
    this.api = StellarAPIType.horizon,
  }) : super(network: BlockchainNetwork.stellar);
  factory StellarRequestDetails.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: BlockchainNetwork.stellar.identifier,
      cborBytes: bytes,
      cborObject: obj,
    );
    return StellarRequestDetails(
      headers: values
          .mapAt<CborStringValue, CborStringValue>(0)
          .map((k, v) => MapEntry(k.value, v.value)),
      requestMethod: RequestMethod.fromValue(values.rawValueAt(1)),
      responseEncoding: ServiceReponseEncoding.fromValue(values.rawValueAt(2)),
      successStatusCodes:
          values
              .listAt<CborIntValue>(3)
              .map((e) => e.value)
              .toList()
              .emptyAsNull,
      errorStatusCodes:
          values
              .listAt<CborIntValue>(4)
              .map((e) => e.value)
              .toList()
              .emptyAsNull,
      bodyBytes: values.rawValueAt(5),
      bodyString: values.rawValueAt(6),
      path: values.rawValueAt(7),
      requestID: values.rawValueAt(8),
      api: StellarAPIType.fromValue(values.rawValueAt(9)),
    );
  }
  StellarRequestDetails copyWith({
    int? requestID,
    String? path,
    RequestMethod? requestMethod,
    Map<String, String>? headers,
    List<int>? bodyBytes,
    String? bodyString,
    ServiceReponseEncoding? responseEncoding,
    List<int>? errorStatusCodes,
    List<int>? successStatusCodes,
    StellarAPIType? api,
  }) {
    return StellarRequestDetails(
      requestID: requestID ?? this.requestID,
      headers: headers ?? this.headers,
      path: path ?? this.path,
      responseEncoding: responseEncoding ?? this.responseEncoding,
      requestMethod: requestMethod ?? this.requestMethod,
      bodyString: bodyString ?? this.bodyString,
      errorStatusCodes: errorStatusCodes ?? this.errorStatusCodes,
      bodyBytes: bodyBytes ?? this.bodyBytes,
      successStatusCodes: successStatusCodes ?? this.successStatusCodes,
      api: api ?? this.api,
    );
  }

  @override
  Uri encodeUrl(String uri) {
    if (api == StellarAPIType.soroban) return Uri.parse(uri);
    if (uri.endsWith('/')) {
      uri = uri.substring(0, uri.length - 1);
    }
    final finalUrl = '$uri${path ?? ''}';
    return Uri.parse(finalUrl);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': requestMethod.name,
      'api': api.name,
      'body': bodyString ?? BytesUtils.tryToHexString(bodyBytes),
    };
  }

  @override
  SerializationIdentifier get serializationIdentifier =>
      BlockchainNetwork.stellar.identifier;

  @override
  List<CborObject?> get serializationItems => [
    CborMapValue.definite(
      headers.map((k, v) => MapEntry(CborStringValue(k), CborStringValue(v))),
    ),
    requestMethod.value.toCbor(),
    responseEncoding.value.toCbor(),
    CborTagSerializable.listFromDynamic(
      successStatusCodes?.map((e) => CborIntValue(e)).toList() ?? [],
    ),
    CborTagSerializable.listFromDynamic(
      errorStatusCodes?.map((e) => CborIntValue(e)).toList() ?? [],
    ),
    bodyBytes?.toCborBytes(),
    bodyString?.toCbor(),
    path?.toCbor(),
    requestID.toCbor(),
    api.value.toCbor(),
  ];
}
