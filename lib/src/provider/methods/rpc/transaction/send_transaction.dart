import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// Submit a real transaction to the Stellar network. This is the only way to make changes on-chain.
/// Unlike Horizon, this does not wait for transaction completion. It simply validates and enqueues the transaction. Clients should call getTransaction to learn about transaction success/failure.
/// This supports all transactions, not only smart contract-related transactions.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/sendTransaction
class SorobanRequestSendTransaction extends SorobanRequestParam<
    SorobanSendTransactionResponse, Map<String, dynamic>> {
  final String transaction;
  const SorobanRequestSendTransaction(this.transaction);

  @override
  Map<String, dynamic> get params => {"transaction": transaction};

  @override
  String get method => SorobanAPIMethods.sendTransaction.name;
  @override
  SorobanSendTransactionResponse onResonse(Map<String, dynamic> result) {
    return SorobanSendTransactionResponse.fromJson(result);
  }
}
