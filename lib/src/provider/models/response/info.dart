import 'package:blockchain_utils/utils/json/json.dart';

class HorizonNodeInfo {
  final String horizonVersion;
  final String coreVersion;
  final int ingestLatestLedger;
  final int historyLatestLedger;
  final DateTime historyLatestLedgerClosedAt;
  final int historyElderLedger;
  final int coreLatestLedger;
  final String networkPassphrase;
  final int currentProtocolVersion;
  final int supportedProtocolVersion;
  final int coreSupportedProtocolVersion;

  HorizonNodeInfo({
    required this.horizonVersion,
    required this.coreVersion,
    required this.ingestLatestLedger,
    required this.historyLatestLedger,
    required this.historyLatestLedgerClosedAt,
    required this.historyElderLedger,
    required this.coreLatestLedger,
    required this.networkPassphrase,
    required this.currentProtocolVersion,
    required this.supportedProtocolVersion,
    required this.coreSupportedProtocolVersion,
  });

  factory HorizonNodeInfo.fromJson(Map<String, dynamic> json) {
    return HorizonNodeInfo(
      horizonVersion: json.valueAs("horizon_version"),
      coreVersion: json.valueAs("core_version"),
      ingestLatestLedger: json.valueAsInt("ingest_latest_ledger"),
      historyLatestLedger: json.valueAsInt("history_latest_ledger"),
      historyLatestLedgerClosedAt: DateTime.parse(
        json.valueAsString("history_latest_ledger_closed_at"),
      ),
      historyElderLedger: json.valueAsInt("history_elder_ledger"),
      coreLatestLedger: json.valueAsInt("core_latest_ledger"),
      networkPassphrase: json.valueAsString("network_passphrase"),
      currentProtocolVersion: json.valueAsInt("current_protocol_version"),
      supportedProtocolVersion: json.valueAsInt("supported_protocol_version"),
      coreSupportedProtocolVersion: json.valueAsInt(
        "core_supported_protocol_version",
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horizon_version': horizonVersion,
      'core_version': coreVersion,
      'ingest_latest_ledger': ingestLatestLedger,
      'history_latest_ledger': historyLatestLedger,
      'history_latest_ledger_closed_at':
          historyLatestLedgerClosedAt.toUtc().toIso8601String(),
      'history_elder_ledger': historyElderLedger,
      'core_latest_ledger': coreLatestLedger,
      'network_passphrase': networkPassphrase,
      'current_protocol_version': currentProtocolVersion,
      'supported_protocol_version': supportedProtocolVersion,
      'core_supported_protocol_version': coreSupportedProtocolVersion,
    };
  }
}
