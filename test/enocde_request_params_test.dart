import 'package:blockchain_utils/networks/types/network.dart';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';

void main() {
  test('encodable provider params', () {
    const param = HorizonRequestAccount("account!");
    final request = param.buildRequest(0);
    final deserialize = StellarRequestDetails.deserialize(
      bytes: request.toCbor().encode(),
    );
    expect(deserialize.path, request.path);
    expect(deserialize.encodeBody(), request.encodeBody());
    expect(deserialize.successStatusCodes, request.successStatusCodes);
    expect(deserialize.errorStatusCodes, request.errorStatusCodes);
    expect(deserialize.network, BlockchainNetwork.stellar);
    expect(deserialize.responseEncoding, request.responseEncoding);
    expect(deserialize.requestMethod, request.requestMethod);
    expect(deserialize.api, request.api);
  });

  test('encodable provider params', () {
    final param = SorobanRequestGetLatestLedger();
    final request = param.buildRequest(0);
    final deserialize = StellarRequestDetails.deserialize(
      bytes: request.toCbor().encode(),
    );
    expect(deserialize.path, request.path);
    expect(deserialize.encodeBody(), request.encodeBody());
    expect(deserialize.successStatusCodes, request.successStatusCodes);
    expect(deserialize.errorStatusCodes, request.errorStatusCodes);
    expect(deserialize.network, BlockchainNetwork.stellar);
    expect(deserialize.responseEncoding, request.responseEncoding);
    expect(deserialize.requestMethod, request.requestMethod);
    expect(deserialize.api, request.api);
  });
}
