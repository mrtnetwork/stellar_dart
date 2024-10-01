class SorobanNetworkResponse {
  final String? friendbotUrl;
  final String passphrase;
  final int? protocolVersion;

  SorobanNetworkResponse({
    required this.friendbotUrl,
    required this.passphrase,
    required this.protocolVersion,
  });

  factory SorobanNetworkResponse.fromJson(Map<String, dynamic> json) {
    return SorobanNetworkResponse(
      friendbotUrl: json['friendbotUrl'],
      passphrase: json['passphrase'],
      protocolVersion: json['protocolVersion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendbotUrl': friendbotUrl,
      'passphrase': passphrase,
      'protocolVersion': protocolVersion,
    };
  }
}

class SorobanVersionInfoResponse {
  final String version;
  final String commitHash;
  final String buildTimeStamp;
  final String captiveCoreVersion;
  final int protocolVersion;
  final int? sorobanProtocolVersion;

  // Constructor
  SorobanVersionInfoResponse({
    required this.version,
    required this.commitHash,
    required this.buildTimeStamp,
    required this.captiveCoreVersion,
    required this.protocolVersion,
    required this.sorobanProtocolVersion,
  });

  // Factory method for creating an instance from JSON
  factory SorobanVersionInfoResponse.fromJson(Map<String, dynamic> json) {
    return SorobanVersionInfoResponse(
      version: json['version'],
      commitHash: json['commit_hash'],
      buildTimeStamp: json['build_time_stamp'],
      captiveCoreVersion: json['captive_core_version'],
      protocolVersion: json['protocol_version'],
      sorobanProtocolVersion: json['SorobanProtocolVersion'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'commit_hash': commitHash,
      'build_time_stamp': buildTimeStamp,
      'captive_core_version': captiveCoreVersion,
      'protocol_version': protocolVersion,
      'SorobanProtocolVersion': sorobanProtocolVersion,
    };
  }
}

class SorobanHealthResponse {
  final String status;
  final int latestLedger;
  final int oldestLedger;
  final int ledgerRetentionWindow;

  SorobanHealthResponse({
    required this.status,
    required this.latestLedger,
    required this.oldestLedger,
    required this.ledgerRetentionWindow,
  });

  factory SorobanHealthResponse.fromJson(Map<String, dynamic> json) {
    return SorobanHealthResponse(
      status: json['status'] as String,
      latestLedger: json['latestLedger'] as int,
      oldestLedger: json['oldestLedger'] as int,
      ledgerRetentionWindow:
          (json['latestLedger'] as int) - (json['oldestLedger'] as int) + 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'latestLedger': latestLedger,
      'oldestLedger': oldestLedger,
      'ledgerRetentionWindow': ledgerRetentionWindow,
    };
  }
}
