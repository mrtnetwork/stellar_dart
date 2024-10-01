import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';
import 'package:stellar_dart/src/provider/models/response/account_operation.dart';

/// This endpoint represents successful operations for a given account and can be used in streaming mode.
/// Streaming mode allows you to listen for new operations for this account as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known operation unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now, you can stream operations created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-operations-by-account-id
class HorizonRequestAccountOperations extends HorizonRequestParam<
    AccountOperationResponse, Map<String, dynamic>> {
  const HorizonRequestAccountOperations(this.accountId,
      {HorizonPaymentPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  /// This account’s public key encoded in a base32 string representation.
  final String accountId;

  @override
  String get method => StellarHorizonMethods.accountOperations.url;

  @override
  List<String> get pathParameters => [accountId];
}
