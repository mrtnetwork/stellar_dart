import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/utils/utils.dart';

/// Stringify one query value for [Uri.replace] (which needs strings).
/// [queryParameters] holds primitives as-is and models/enums via `toJson()`.
String _stringifyQueryValue(dynamic v) {
  if (v is String) return v;
  if (v is num || v is bool || v is BigInt) return v.toString();
  if (v is List) return v.map(_stringifyQueryValue).join(',');
  return v.toString();
}

/// v2 base for generated Horizon REST requests.
///
/// Matches generator output (`path` template + `pathParameters` +
/// `queryParameters` as `Map<String, dynamic>` with primitives as-is and
/// models/enums via `.toJson()`).
abstract class HorizonRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, StellarRequestDetails> {
  const HorizonRequest();

  String? get path;
  List<String> get pathParameters => const [];
  Map<String, dynamic> get queryParameters => const {};
  Map<String, String>? get headers => null;

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  StellarRequestDetails buildRequest(int requestID) {
    final template = path ?? '';
    final pathParams = StellarProviderUtils.extractParams(template);
    if (pathParams.length != pathParameters.length) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Invalid Path Parameters.',
        details: {
          'pathParams': pathParameters.join(","),
          'expected': pathParams.join(","),
        },
      );
    }
    String resolved = template;
    for (int i = 0; i < pathParams.length; i++) {
      resolved = resolved.replaceFirst(pathParams[i], pathParameters[i]);
    }
    // queryParameters is Map<String, dynamic>: primitives stay primitive,
    // models/enums arrive via toJson(). Uri needs strings.
    final Map<String, String> query = {
      for (final e in queryParameters.entries)
        if (e.value != null) e.key: _stringifyQueryValue(e.value),
    };
    if (query.isNotEmpty) {
      resolved =
          Uri.parse(
            resolved,
          ).replace(queryParameters: query).normalizePath().toString();
    }
    return StellarRequestDetails(
      requestID: requestID,
      path: resolved,
      headers: headers ?? ServiceConst.defaultPostHeaders,
      errorStatusCodes: [504, 503, 410, 400, 404, 415],
      requestMethod: requestMethod,
      responseEncoding: ServiceReponseEncoding.fromType<RESPONSE>(),
    );
  }
}
