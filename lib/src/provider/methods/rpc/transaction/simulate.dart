import 'package:stellar_dart/src/provider/models/response/simulate_transaction.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// Submit a trial contract invocation to simulate how it would be executed by the network.
///  This endpoint calculates the effective transaction data, required authorizations,
/// and minimal resource fee. It provides a way to test and analyze the potential
/// outcomes of a transaction without actually submitting it to the network.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/simulateTransaction
class SorobanRequestSimulateTransaction
    extends SorobanRequestParam<SorobanSimulateResponse, Map<String, dynamic>> {
  final String tx;
  final int? instructionLeeway;
  const SorobanRequestSimulateTransaction(
      {required this.tx, this.instructionLeeway});

  @override
  Map<String, dynamic> get params => {
        "transaction": tx,
        "resourceConfig": {"instructionLeeway": instructionLeeway}
      };

  @override
  String get method => SorobanAPIMethods.simulateTransaction.name;
  @override
  SorobanSimulateResponse onResonse(Map<String, dynamic> result) {
    return SorobanSimulateResponse.fromJson(result);
  }
}
