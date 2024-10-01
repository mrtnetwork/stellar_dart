import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// This endpoint represents successful transactions referencing a given claimable balance and can be used in streaming mode.
/// Streaming mode allows you to listen for new transactions referencing this claimable balance as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known transaction unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now, you can stream transactions created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/cb-retrieve-related-transactions
class HorizonRequestClaimableBalanceTransactions
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// A unique identifier for this claimable balance.
  final String claimableBalanceId;

  const HorizonRequestClaimableBalanceTransactions(this.claimableBalanceId,
      {HorizonTransactionPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.claimableBalanceTransactions.url;

  @override
  List<String> get pathParameters => [claimableBalanceId];
}
