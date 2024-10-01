import 'package:blockchain_utils/helper/helper.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:stellar_dart/src/utils/validator.dart';

class RequestAssetType {
  final String name;
  const RequestAssetType._(this.name);
  static const RequestAssetType native = RequestAssetType._("native");
  static const RequestAssetType creditAlphanum4 =
      RequestAssetType._("credit_alphanum4");
  static const RequestAssetType creditAlphanum12 =
      RequestAssetType._("credit_alphanum12");
  static const List<RequestAssetType> values = [
    native,
    creditAlphanum4,
    creditAlphanum12
  ];
  static RequestAssetType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw DartStellarPlugingException("Asset type not found.",
          details: {
            "name": name,
            "values": values.map((e) => e.name).join(", ")
          }),
    );
  }

  AssetType get assetType {
    switch (this) {
      case RequestAssetType.native:
        return AssetType.native;
      case RequestAssetType.creditAlphanum12:
        return AssetType.creditAlphanum12;
      case RequestAssetType.creditAlphanum4:
        return AssetType.creditAlphanum4;
      default:
        throw DartStellarPlugingException("Invalid response asset type.",
            details: {"type": name});
    }
  }

  @override
  String toString() {
    return "RequestAssetType.$name";
  }
}

class RequestTradeType {
  final String name;
  const RequestTradeType._(this.name);
  static const RequestTradeType all = RequestTradeType._("all");
  static const RequestTradeType orderbook = RequestTradeType._("orderbook");
  static const RequestTradeType liquidityPools =
      RequestTradeType._("liquidity_pools");
  @override
  String toString() {
    return "RequestTradeType.$name";
  }
}

enum HorizonQueryOrder { asc, desc }

/// https://developers.stellar.org/docs/data/rpc/api-reference/pagination
class SorobanPaginationParams {
  /// A string ID that points to a specific location in a collection of
  /// responses and is pulled from the pagingtoken value of a record. When a cursor
  /// is provided Soroban-RPC will _not include the element whose id matches the cursor in the response.
  /// Only elements which appear after the cursor are included.
  final String? cursor;

  /// The maximum number of records returned. The limit for getEvents can range from 1 to 10000 - an upper limit that is
  /// hardcoded in Soroban-RPC for performance reasons. If this argument isn't designated, it defaults to 100.
  final int? limit;

  const SorobanPaginationParams({this.cursor, this.limit});
  Map<String, dynamic> toJson() {
    return {"cursor": cursor, "limit": limit};
  }
}

class HorizonPaginationParams {
  /// A number that points to a specific location in a collection of
  /// responses and is pulled from the paging_token value of a record.
  final int? cursor;

  /// A designation of the order in which records should appear.
  /// Options include asc (ascending) or desc (descending).
  /// If this argument isn’t set, it defaults to asc.
  final HorizonQueryOrder? order;

  /// The maximum number of records returned. The limit can range from 1 to 200 -
  /// an upper limit that is hardcoded in Horizon for performance reasons. If this argument isn’t designated, it defaults to 10.
  final int? limit;

  const HorizonPaginationParams({this.cursor, this.order, this.limit});
  Map<String, dynamic> toJson() {
    return {
      "cursor": cursor?.toString(),
      "order": order?.name,
      "limit": limit?.toString()
    };
  }
}

class HorizonTransactionPaginationParams extends HorizonPaginationParams {
  HorizonTransactionPaginationParams(
      {required int? cursor,
      required HorizonQueryOrder? order,
      required int? limit,
      this.includeFailed})
      : super(cursor: cursor, order: order, limit: limit);

  /// Set to true to include failed operations in results. Options include true and false.
  final bool? includeFailed;

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "include_failed": includeFailed};
  }
}

class HorizonPaymentPaginationParams
    extends HorizonTransactionPaginationParams {
  HorizonPaymentPaginationParams(
      {int? cursor,
      HorizonQueryOrder? order,
      int? limit,
      bool? includeFailed,
      this.join})
      : super(
            cursor: cursor,
            order: order,
            limit: limit,
            includeFailed: includeFailed);

  /// Set to transactions to include the transactions which created each of the operations in the response.
  final Object? join;
  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "join": join};
  }
}

enum SorobanEventType { system, contract, diagnostic }

class SorobanEventFilter {
  final SorobanEventType type;
  final List<String> contractIds;
  final List<String> topics;
  SorobanEventFilter(
      {required List<String> topics,
      required List<String> contractIds,
      required this.type})
      : topics = topics.immutable.max(5, name: "topics"),
        contractIds = contractIds.immutable.max(5, name: "contractIds");
  Map<String, dynamic> toJson() {
    return {"type": type.name, "contractIds": contractIds, "topics": topics};
  }
}
