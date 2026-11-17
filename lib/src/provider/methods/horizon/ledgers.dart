// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/methods/horizon/core.dart';
import 'types.dart';

/// GET /ledgers/{sequence}
class HorizonRequestRetrieveALedger
    extends
        HorizonRequest<HorizonLedgerEmbeddedRecordsItem, Map<String, dynamic>> {
  final int sequence;

  const HorizonRequestRetrieveALedger({required this.sequence});

  @override
  String? get path => '/ledgers/{sequence}';

  @override
  List<String> get pathParameters => [sequence.toString()];

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  HorizonLedgerEmbeddedRecordsItem onResponse(Map<String, dynamic> result) {
    return HorizonLedgerEmbeddedRecordsItem.fromJson(result);
  }
}

/// GET /ledgers
class HorizonRequestListAllLedgers
    extends HorizonRequest<HorizonLedger, Map<String, dynamic>> {
  final int? cursor;
  final HorizonOrder? order;
  final int? limit;

  const HorizonRequestListAllLedgers({this.cursor, this.order, this.limit});

  @override
  String? get path => '/ledgers';

  @override
  RequestMethod get requestMethod => RequestMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {
    'cursor': cursor,
    'order': order?.toJson(),
    'limit': limit,
  };

  @override
  HorizonLedger onResponse(Map<String, dynamic> result) {
    return HorizonLedger.fromJson(result);
  }
}
