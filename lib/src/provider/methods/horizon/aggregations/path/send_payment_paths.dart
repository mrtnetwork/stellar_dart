import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// The strict send payment path endpoint lists the paths a payment can take based on the amount of an asset you want to send.
/// The source asset amount stays constant, and the type and amount of an asset received varies based on offers in the order books.

/// For this search, Horizon loads a list of assets that the recipient can receive
/// (based on destination_account or destination_assets) and displays the possible
/// paths from the different source assets to the destination asset. Only paths that satisfy the source_amount are returned.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-strict-send-payment-paths
class HorizonRequestSendPaymentPaths
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  /// The Stellar address of the receiver. Any returned path must end with an asset that the recipient can receive.
  /// Using either source_account or source_assets as an argument is required for strict send path payments.
  final String? destinationAccount;

  /// A comma-separated list of assets that the recipient can receive.
  /// Any returned path must end with an asset in this list. Each asset is formatted as CODE:ISSUER_ACCOUNT.
  /// For example: USD:GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX.
  /// Using either source_account or source_assets as an argument is required for strict send path payments.
  final String? destinationAssets;

  /// The type for the source asset.
  final RequestAssetType sourceAssetType;

  /// The Stellar address of the issuer of the source asset. Required if the [sourceAssetType] is not native
  final String? sourceAssetIssuer;

  /// The Stellar address of the issuer of the source asset. Required if the [sourceAssetType] is not native
  final String? sourceAssetCode;

  /// The amount of the source asset that should be sent.
  final String sourceAmount;
  const HorizonRequestSendPaymentPaths({
    required this.sourceAssetType,
    required this.sourceAmount,
    this.destinationAccount,
    this.destinationAssets,
    this.sourceAssetCode,
    this.sourceAssetIssuer,
  });

  @override
  String get method => StellarHorizonMethods.sendPaymentPaths.url;

  @override
  Map<String, dynamic> get queryParameters => {
        "destination_account": destinationAccount,
        "destination_assets": destinationAssets,
        "source_asset_type": sourceAssetType.name,
        "source_asset_issuer": sourceAssetIssuer,
        "source_asset_code": sourceAssetCode,
        "source_amount": sourceAmount
      };
}
