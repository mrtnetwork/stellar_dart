import 'package:blockchain_utils/blockchain_utils.dart';

import 'assets.dart';

class ThresholdsReponse {
  final int lowThreshold;
  final int medThreshold;
  final int highThreshold;

  ThresholdsReponse({
    required this.lowThreshold,
    required this.medThreshold,
    required this.highThreshold,
  });

  factory ThresholdsReponse.fromJson(Map<String, dynamic> json) {
    return ThresholdsReponse(
      lowThreshold: json['low_threshold'],
      medThreshold: json['med_threshold'],
      highThreshold: json['high_threshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'low_threshold': lowThreshold,
      'med_threshold': medThreshold,
      'high_threshold': highThreshold,
    };
  }
}

class FlagsResponse {
  final bool authRequired;
  final bool authRevocable;
  final bool authImmutable;
  final bool authClawbackEnabled;

  FlagsResponse({
    required this.authRequired,
    required this.authRevocable,
    required this.authImmutable,
    required this.authClawbackEnabled,
  });

  factory FlagsResponse.fromJson(Map<String, dynamic> json) {
    return FlagsResponse(
      authRequired: json['auth_required'],
      authRevocable: json['auth_revocable'],
      authImmutable: json['auth_immutable'],
      authClawbackEnabled: json['auth_clawback_enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_required': authRequired,
      'auth_revocable': authRevocable,
      'auth_immutable': authImmutable,
      'auth_clawback_enabled': authClawbackEnabled,
    };
  }
}

class SignerResponse {
  final int weight;
  final String key;
  final String type;

  SignerResponse({
    required this.weight,
    required this.key,
    required this.type,
  });

  factory SignerResponse.fromJson(Map<String, dynamic> json) {
    return SignerResponse(
      weight: json['weight'],
      key: json['key'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'key': key,
      'type': type,
    };
  }
}

class StellarAccountResponse {
  final String id;
  final String accountId;
  final BigInt sequence;
  final int subentryCount;
  final String? inflationDestination;
  final String? homeDomain;
  final int lastModifiedLedger;
  final int numSponsoring;
  final int numSponsored;
  final ThresholdsReponse thresholds;
  final FlagsResponse flags;
  final List<StellarAssetResponse> balances;
  final List<SignerResponse> signers;

  StellarAccountResponse({
    required this.id,
    required this.accountId,
    required this.sequence,
    required this.subentryCount,
    required this.inflationDestination,
    required this.homeDomain,
    required this.lastModifiedLedger,
    required this.numSponsoring,
    required this.numSponsored,
    required this.thresholds,
    required this.flags,
    required this.balances,
    required this.signers,
  });

  factory StellarAccountResponse.fromJson(Map<String, dynamic> json) {
    return StellarAccountResponse(
      id: json['id'],
      accountId: json['account_id'],
      sequence: BigintUtils.parse(json['sequence']),
      subentryCount: json['subentry_count'],
      inflationDestination: json['inflation_destination'],
      homeDomain: json['home_domain'],
      lastModifiedLedger: json['last_modified_ledger'] as int,
      numSponsoring: json['num_sponsoring'] as int,
      numSponsored: json['num_sponsored'] as int,
      thresholds: ThresholdsReponse.fromJson(json['thresholds']),
      flags: FlagsResponse.fromJson(json['flags']),
      balances: (json['balances'] as List<dynamic>)
          .map((balance) => StellarAssetResponse.fromJson(balance))
          .toList(),
      signers: (json['signers'] as List<dynamic>)
          .map((signer) => SignerResponse.fromJson(signer))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'sequence': sequence,
      'subentry_count': subentryCount,
      'inflation_destination': inflationDestination,
      'home_domain': homeDomain,
      'last_modified_ledger': lastModifiedLedger,
      'num_sponsoring': numSponsoring,
      'num_sponsored': numSponsored,
      'thresholds': thresholds.toJson(),
      'flags': flags.toJson(),
      'balances': balances.map((balance) => balance.toJson()).toList(),
      'signers': signers.map((signer) => signer.toJson()).toList(),
    };
  }
}
