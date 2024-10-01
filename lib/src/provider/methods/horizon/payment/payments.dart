import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint lists all Successful payment-related operations and can be used in streaming mode.
/// Streaming mode allows you to listen for new payments as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known payment unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream payments created since your request time. Operations that can be returned
/// by this endpoint include: create_account, payment, path_payment_strict_recieve, path_payment_strict_send, and account_merge
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-payments
class HorizonRequestPayments
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  const HorizonRequestPayments(
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.payments.url;

  @override
  List<String> get pathParameters => [];
}
