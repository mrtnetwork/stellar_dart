import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// The strict receive payment path endpoint lists the paths a payment can take based on the amount of an asset
/// you want the recipient to receive. The destination asset amount stays constant,
/// and the type and amount of an asset sent varies based on offers in the order books.

/// For this search, Horizon loads a list of assets available to the sender (based on source_account or source_assets)
/// and displays the possible paths from the different source assets to the destination asset.
/// Only paths that satisfy the destination_amount are returned.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-strict-receive-payment-paths
class HorizonRequestPaymentPaths
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// The Stellar address of the sender. Any returned path must start with an asset that the sender holds.
  /// Using either source_account or source_assets as an argument is required for strict receive path payments.
  final String? sourceAccount;

  /// A comma-separated list of assets available to the sender.
  /// Any returned path must start with an asset in this list.
  /// Each asset is formatted as CODE:ISSUER_ACCOUNT.
  /// For example: USD:GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX.
  /// Using either source_account or source_assets as an argument is required for strict receive path payments.
  final String? sourceAssets;

  /// The type for the destination asset.
  final RequestAssetType destinationAssetType;

  /// The Stellar address of the issuer of the destination asset. Required if the [destinationAssetType] is not native
  final String? destinationAssetIssuer;

  /// he code for the destination asset. Required if the [destinationAssetType] is not native
  final String? destinationAssetCode;

  /// The amount of the destination asset that should be received.
  final String destinationAmount;
  const HorizonRequestPaymentPaths({
    required this.destinationAssetType,
    required this.destinationAmount,
    this.sourceAccount,
    this.sourceAssets,
    this.destinationAssetIssuer,
    this.destinationAssetCode,
  });

  @override
  String get method => StellarHorizonMethods.paymentPaths.url;

  @override
  Map<String, dynamic> get queryParameters => {
        "source_account": sourceAccount,
        "source_assets": sourceAssets,
        "destination_asset_type": destinationAssetType.name,
        "destination_asset_issuer": destinationAssetIssuer,
        "destination_asset_code": destinationAssetCode,
        "destination_amount": destinationAmount
      };
}
