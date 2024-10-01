import 'package:stellar_dart/src/provider/models/models.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

/// For reading the current value of ledger entries directly.
/// This method enables the retrieval of various ledger states, such as accounts, trustlines, offers, data, claimable balances,
/// and liquidity pools. It also provides direct access to inspect a contract's current state, its code, or any other ledger entry.
/// This serves as a primary method to access your contract data which may not be available via events or simulateTransaction.
/// To fetch contract wasm byte-code, use the ContractCode ledger entry key.
/// https://developers.stellar.org/docs/data/rpc/api-reference/methods/getLedgerEntries
class SorobanRequestGetLedgerEntries extends SorobanRequestParam<
    SorobanLedgerEntriesResponse, Map<String, dynamic>> {
  /// Array containing the keys of the ledger entries you wish to retrieve.
  /// (an array of serialized base64 strings)
  final List<String> keys;
  SorobanRequestGetLedgerEntries({required this.keys});

  @override
  Map<String, dynamic> get params => {"keys": keys};

  @override
  String get method => SorobanAPIMethods.getLedgerEntries.name;
  @override
  SorobanLedgerEntriesResponse onResonse(Map<String, dynamic> result) {
    return SorobanLedgerEntriesResponse.fromJson(result);
  }
}
