import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// The getTransaction method provides details about the specified transaction.
/// Clients are expected to periodically query this method to ascertain when a
/// transaction has been successfully recorded on the blockchain. The soroban-rpc system maintains
/// a restricted history of recently processed transactions, with the default retention window set at 1440 ledgers,
/// approximately equivalent to a 2-hour timeframe. For private soroban-rpc instances,
/// it is possible to modify the retention window value by adjusting the transaction-retention-window configuration setting.
/// For comprehensive debugging needs that extend beyond the 2-hour timeframe, it is advisable to retrieve
/// transaction information from Horizon, as it provides a lasting and persistent record.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getTransaction
class SorobanRequestGetTransaction extends SorobanRequestParam<
    SorobanTransactionResponse, Map<String, dynamic>> {
  /// Transaction hash to query as a hex-encoded string. This transaction hash should correspond to transaction that has been previously submitted to the network.
  final String txId;
  SorobanRequestGetTransaction(this.txId);

  @override
  Map<String, dynamic> get params => {"hash": txId};

  @override
  String get method => SorobanAPIMethods.getTransaction.name;
  @override
  SorobanTransactionResponse onResonse(Map<String, dynamic> result) {
    return SorobanTransactionResponse.fromJson(result);
  }
}
