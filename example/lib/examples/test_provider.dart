import 'package:blockchain_utils/service/models/params.dart';
import 'package:http/http.dart' as http;
import 'package:stellar_dart/stellar_dart.dart';

class StellarHTTPProvider with StellarServiceProvider {
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
  Future<BaseServiceResponse> doRequest(StellarRequestDetails params,
      {Duration? timeout}) async {
    final corretUrl = params.api == StellarAPIType.horizon ? url : soroban;
    if (params.requestMethod.isPost) {
      final response = await client
          .post(params.encodeUrl(corretUrl),
              headers: params.headers, body: params.encodeBody())
          .timeout(timeout ?? defaultRequestTimeout);
      return params.toResponse(response.bodyBytes,
          statusCode: response.statusCode);
    }
    final response = await client
        .get(params.encodeUrl(corretUrl), headers: params.headers)
        .timeout(timeout ?? defaultRequestTimeout);
    return params.toResponse(response.bodyBytes,
        statusCode: response.statusCode);
  }
}

void main() async {
  final provider = StellarProvider(StellarHTTPProvider(
      url: "https://horizon-testnet.stellar.org",
      soroban: "https://soroban-testnet.stellar.org"));
  await provider.request(const HorizonRequestFeeStats());

  await provider.request(SorobanRequestGetNetwork());
  final account = StellarAccountAddress(
      'GCFIRY65OQE7DFP5KLNS2PF2LVZMUZYJX4OZIEQ36N2IQANUB5XVYOJR');
  await provider.request(HorizonRequestAccount(account.baseAddress));

  /// ...
}
