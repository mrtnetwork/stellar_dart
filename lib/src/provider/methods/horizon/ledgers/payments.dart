import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint returns all payment-related operations in a specific ledger.
/// Operation types that can be returned by this endpoint include: create_account,
/// payment, path_payment, and account_merge.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-a-ledgers-payments
class HorizonRequestLedgerPayments
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// The sequence number of a specific ledger.
  final int sequence;
  const HorizonRequestLedgerPayments(this.sequence,
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.ledgerPayments.url;

  @override
  List<String> get pathParameters => [sequence.toString()];
}
