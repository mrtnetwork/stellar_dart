import 'package:http/http.dart' as http;
import 'package:stellar_dart/stellar_dart.dart';

class StellarHTTPProvider implements StellarServiceProvider {
  StellarHTTPProvider(
      {required this.url,
      required this.soroban,
      http.Client? client,
      this.defaultRequestTimeout = const Duration(seconds: 30)})
      : client = client ?? http.Client();

  final String url;
  final String soroban;
  final http.Client client;
  final Duration defaultRequestTimeout;

  @override
  Future<HorizonServiceResponse> get(HorizonRequestDetails params,
      [Duration? timeout]) async {
    final response = await client.get(
        Uri.parse(params.url(horizonUri: url, sorobanUri: soroban)),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        }).timeout(timeout ?? defaultRequestTimeout);
    return HorizonServiceResponse(
        body: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HorizonServiceResponse> post(HorizonRequestDetails params,
      [Duration? timeout]) async {
    final response = await client
        .post(Uri.parse(params.url(sorobanUri: soroban, horizonUri: url)),
            headers: {
              "Accept": "application/json",
              'Content-Type': 'application/json',
              ...params.header,
            },
            body: params.body)
        .timeout(timeout ?? defaultRequestTimeout);
    return HorizonServiceResponse(
        body: response.body, statusCode: response.statusCode);
  }
}
