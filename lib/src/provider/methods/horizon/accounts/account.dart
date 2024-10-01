import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

/// The single account endpoint provides information on a specific account.
/// The balances section in the response will also list all the trustlines this account has established,
/// including trustlines that haven’t been authorized yet.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-an-account
class HorizonRequestAccount
    extends HorizonRequestParam<StellarAccountResponse, Map<String, dynamic>> {
  const HorizonRequestAccount(this.accountId);

  /// This account’s public key encoded in a base32 string representation.
  final String accountId;
  @override
  String get method => StellarHorizonMethods.account.url;

  @override
  List<String> get pathParameters => [accountId];

  @override
  StellarAccountResponse onResonse(Map<String, dynamic> result) {
    return StellarAccountResponse.fromJson(result);
  }
}
