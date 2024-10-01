import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/transaction_operation.dart';

/// The single operation endpoint provides information about a specific operation.
/// https://developers.stellar.org/docs/data/horizon/api-reference/retrieve-an-operation
class HorizonRequestOperation extends HorizonRequestParam<
    StellarTransactionOperationResponse, Map<String, dynamic>> {
  /// The ID number for this operation.
  final String id;

  /// Set to transactions to include the transactions which created each of the operations in the response.
  final Object? join;
  const HorizonRequestOperation(this.id, {this.join});

  @override
  String get method => StellarHorizonMethods.operation.url;

  @override
  List<String> get pathParameters => [id];

  @override
  Map<String, dynamic> get queryParameters => {"join": join};

  @override
  StellarTransactionOperationResponse onResonse(Map<String, dynamic> result) {
    return StellarTransactionOperationResponse.fromJson(result);
  }
}
