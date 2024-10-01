import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';

/// This endpoint represents a single data for a given account.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-data-by-account-id
class HorizonRequestAccountData
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  const HorizonRequestAccountData({required this.accountId, required this.key});

  /// This account’s public key encoded in a base32 string representation.
  final String accountId;

  /// The key name for this data.
  final String key;

  @override
  String get method => StellarHorizonMethods.accountData.url;

  @override
  List<String> get pathParameters => [accountId, key];
}
