import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint represents all offers a given account has currently open and can be used in streaming mode.
/// Streaming mode allows you to listen for new offers for this account as they are added to the Stellar ledger.
/// If called in streaming mode, Horizon will start at the earliest known offer unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now, you can stream offers created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/get-offers-by-account-id
class HorizonRequestAccountOffers
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  const HorizonRequestAccountOffers(this.accountId,
      {HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  /// This account’s public key encoded in a base32 string representation.
  final String accountId;

  @override
  String get method => StellarHorizonMethods.accountOffers.url;

  @override
  List<String> get pathParameters => [accountId];

  @override
  Map<String, dynamic> get queryParameters => {};
}
