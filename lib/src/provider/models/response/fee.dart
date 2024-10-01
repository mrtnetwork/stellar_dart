class StellarFeeStatsResponse {
  final String lastLedger;
  final String lastLedgerBaseFee;
  final String ledgerCapacityUsage;
  final FeeStatsResponse feeCharged;
  final FeeStatsResponse maxFee;

  StellarFeeStatsResponse({
    required this.lastLedger,
    required this.lastLedgerBaseFee,
    required this.ledgerCapacityUsage,
    required this.feeCharged,
    required this.maxFee,
  });

  factory StellarFeeStatsResponse.fromJson(Map<String, dynamic> json) {
    return StellarFeeStatsResponse(
      lastLedger: json['last_ledger'],
      lastLedgerBaseFee: json['last_ledger_base_fee'],
      ledgerCapacityUsage: json['ledger_capacity_usage'],
      feeCharged: FeeStatsResponse.fromJson(json['fee_charged']),
      maxFee: FeeStatsResponse.fromJson(json['max_fee']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_ledger': lastLedger,
      'last_ledger_base_fee': lastLedgerBaseFee,
      'ledger_capacity_usage': ledgerCapacityUsage,
      'fee_charged': feeCharged.toJson(),
      'max_fee': maxFee.toJson(),
    };
  }
}

class FeeStatsResponse {
  final String max;
  final String min;
  final String mode;
  final String p10;
  final String p20;
  final String p30;
  final String p40;
  final String p50;
  final String p60;
  final String p70;
  final String p80;
  final String p90;
  final String p95;
  final String p99;

  FeeStatsResponse({
    required this.max,
    required this.min,
    required this.mode,
    required this.p10,
    required this.p20,
    required this.p30,
    required this.p40,
    required this.p50,
    required this.p60,
    required this.p70,
    required this.p80,
    required this.p90,
    required this.p95,
    required this.p99,
  });

  factory FeeStatsResponse.fromJson(Map<String, dynamic> json) {
    return FeeStatsResponse(
      max: json['max'],
      min: json['min'],
      mode: json['mode'],
      p10: json['p10'],
      p20: json['p20'],
      p30: json['p30'],
      p40: json['p40'],
      p50: json['p50'],
      p60: json['p60'],
      p70: json['p70'],
      p80: json['p80'],
      p90: json['p90'],
      p95: json['p95'],
      p99: json['p99'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max': max,
      'min': min,
      'mode': mode,
      'p10': p10,
      'p20': p20,
      'p30': p30,
      'p40': p40,
      'p50': p50,
      'p60': p60,
      'p70': p70,
      'p80': p80,
      'p90': p90,
      'p95': p95,
      'p99': p99,
    };
  }
}

class SorobanFeeStatsResponse {
  final FeeStatsResponse sorobanInclusionFee;
  final FeeStatsResponse inclusionFee;
  final int latestLedger;

  const SorobanFeeStatsResponse({
    required this.sorobanInclusionFee,
    required this.inclusionFee,
    required this.latestLedger,
  });

  factory SorobanFeeStatsResponse.fromJson(Map<String, dynamic> json) {
    return SorobanFeeStatsResponse(
      sorobanInclusionFee:
          FeeStatsResponse.fromJson(json['sorobanInclusionFee']),
      inclusionFee: FeeStatsResponse.fromJson(json['inclusionFee']),
      latestLedger: json['latestLedger'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sorobanInclusionFee': sorobanInclusionFee.toJson(),
      'inclusionFee': inclusionFee.toJson(),
      'latestLedger': latestLedger,
    };
  }
}
