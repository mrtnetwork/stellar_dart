import 'package:blockchain_utils/utils/string/string.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

class ResourcesCostResponse {
  final String cpuInsns;
  final String memBytes;
  const ResourcesCostResponse({required this.cpuInsns, required this.memBytes});
  factory ResourcesCostResponse.fromJson(Map<String, dynamic> json) {
    return ResourcesCostResponse(
        cpuInsns: json["cpuInsns"], memBytes: json["memBytes"]);
  }
  Map<String, dynamic> toJson() {
    return {"cpuInsns": cpuInsns, "memBytes": memBytes};
  }
}

class SorobanSimulateResponse {
  final int latestLedger;
  final String? minResourceFee;
  final ResourcesCostResponse? cost;

  /// This array will only have one element: the result for the Host Function invocation.
  /// Only present on successful simulation (i.e. no error) of InvokeHostFunction operations.
  final List<HostFunctionInvocationResult>? results;
  final String? transactionData;
  final List<String>? events;
  final RestorePreamble? restorePreamble;
  final List<StateChange>? stateChanges;
  final String? error;

  bool get isSuccess => error == null;

  SorobanTransactionData? get sorobanTransactionData {
    if (transactionData == null) return null;
    return SorobanTransactionData.fromXdr(
        StringUtils.encode(transactionData!, type: StringEncoding.base64));
  }

  ScVal? get xdrResult {
    if (results?.isEmpty ?? true) return null;
    final result = results![0];
    return result.xdrResult;
  }

  List<SorobanAuthorizationEntry> get auths {
    if (results?.isEmpty ?? true) return [];
    final result = results![0];
    return result.auths;
  }

  SorobanSimulateResponse({
    required this.latestLedger,
    this.minResourceFee,
    required this.cost,
    required this.results,
    this.transactionData,
    this.events,
    this.restorePreamble,
    this.stateChanges,
    this.error,
  });

  factory SorobanSimulateResponse.fromJson(Map<String, dynamic> json) {
    return SorobanSimulateResponse(
      latestLedger: json['latestLedger'] as int,
      minResourceFee: json['minResourceFee'] as String?,
      cost: json["cost"] == null
          ? null
          : ResourcesCostResponse.fromJson(json["cost"]),
      results: (json['results'] as List?)
          ?.map((result) => HostFunctionInvocationResult.fromJson(result))
          .toList(),
      transactionData: json['transactionData'] as String?,
      events: json['events'] != null ? List<String>.from(json['events']) : null,
      restorePreamble: json['restorePreamble'] != null
          ? RestorePreamble.fromJson(json['restorePreamble'])
          : null,
      stateChanges: json['stateChanges'] != null
          ? (json['stateChanges'] as List)
              .map((change) => StateChange.fromJson(change))
              .toList()
          : null,
      error: json['error'] as String?,
    );
  }
}

class HostFunctionInvocationResult {
  final String xdr;
  final List<String> auth;

  HostFunctionInvocationResult({required this.xdr, required this.auth});

  factory HostFunctionInvocationResult.fromJson(Map<String, dynamic> json) {
    return HostFunctionInvocationResult(
        xdr: json['xdr'], auth: (json["auth"] as List).cast());
  }
  ScVal? get xdrResult {
    return ScVal.fromXdr(StringUtils.encode(xdr, type: StringEncoding.base64));
  }

  List<SorobanAuthorizationEntry> get auths {
    return auth.map((e) {
      final xdrBytes = StringUtils.encode(e, type: StringEncoding.base64);
      return SorobanAuthorizationEntry.fromXdr(xdrBytes);
    }).toList();
  }
}

class RestorePreamble {
  final String minResourceFee;
  final String transactionData;

  RestorePreamble({
    required this.minResourceFee,
    required this.transactionData,
  });

  factory RestorePreamble.fromJson(Map<String, dynamic> json) {
    return RestorePreamble(
      minResourceFee: json['minResourceFee'],
      transactionData: json['transactionData'],
    );
  }
}

class StateChangeType {
  final String name;
  final int value;
  const StateChangeType._({required this.name, required this.value});
  static const StateChangeType created =
      StateChangeType._(name: "created", value: 1);
  static const StateChangeType updated =
      StateChangeType._(name: "updated", value: 2);
  static const StateChangeType deleted =
      StateChangeType._(name: "deleted", value: 1);
  // created (1), updated (2), or deleted (3)
  static const List<StateChangeType> values = [created, updated, deleted];

  static StateChangeType fromValue(Object? type) {
    return values.firstWhere(
      (e) => e.value == type || e.name == type,
      orElse: () => throw DartStellarPlugingException(
          "Invalid StateChange type.",
          details: {"type": type}),
    );
  }

  @override
  String toString() {
    return "StateChangeType.$name";
  }
}

class StateChange {
  final StateChangeType type;
  final String key;
  final String? before;
  final String? after;

  const StateChange(
      {required this.type, required this.key, this.before, this.after});

  factory StateChange.fromJson(Map<String, dynamic> json) {
    return StateChange(
      type: StateChangeType.fromValue(json['type']),
      key: json['key'],
      before: json['before'],
      after: json['after'],
    );
  }
}
