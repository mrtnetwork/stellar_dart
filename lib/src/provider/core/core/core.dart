import 'package:blockchain_utils/blockchain_utils.dart';

/// Which Stellar API a request targets (Horizon or Stellar RPC).
enum StellarAPIType {
  horizon(0),
  soroban(1);

  final int value;
  const StellarAPIType(this.value);
  static StellarAPIType fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw BuError(
                DefaultErrorType.invalidArgument,
                'Unknown StellarAPIType value "$value".',
              ),
    );
  }
}

/// Resolved URL, method and body for an outgoing request.
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
      bodyBytes: values.rawValueAt<List<int>?>(5),
      bodyString: values.rawValueAt<String?>(6),
      path: values.rawValueAt<String?>(7),
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
