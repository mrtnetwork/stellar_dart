import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/address/address.dart';

/// Asset metadata resolved from an issuer's stellar.toml.
class StellarAssetMetadata {
  final String code;
  final StellarAddress issuer;
  final String name;
  final int displayDecimals;
  final String? desc;
  final String? image;
  final String? conditions;
  final bool? isAnchored;

  factory StellarAssetMetadata.fromJson(Map<String, String> map) {
    return StellarAssetMetadata(
      code: map['code']!,
      issuer: StellarAddress.fromBase32Addr(map['issuer']!),
      name: map['name']!,
      displayDecimals: IntUtils.tryParse(map['display_decimals'] ?? '7') ?? 7,
      desc: map['desc'],
      image: map['image'],
      conditions: map['conditions'],
      isAnchored: map['is_asset_anchored']?.toLowerCase() == 'true',
    );
  }

  static List<StellarAssetMetadata> fromToml(String toml) {
    try {
      return StellarProviderUtils.parseTomlCurrencies(toml);
    } catch (_) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        "Failed to parse Stellar TOML data: Invalid or unexpected format.",
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "issuer": issuer,
      "name": name,
      "displayDecimals": displayDecimals,
      "desc": desc,
      "image": image,
      "conditions": conditions,
      "isAnchored": isAnchored,
    };
  }

  StellarAssetMetadata({
    required this.code,
    required this.issuer,
    required this.name,
    required this.displayDecimals,
    this.desc,
    this.image,
    this.conditions,
    this.isAnchored,
  });
}

/// Internal helpers for building provider request URLs and parsing responses.
class StellarProviderUtils {
  static List<String> extractParams(String url) {
    final RegExp pathParamRegex = RegExp(r':\w+|\{[^}]+\}');
    final Iterable<Match> matches = pathParamRegex.allMatches(url);
    final List<String> params = [];
    for (final Match match in matches) {
      params.add(match.group(0)!);
    }
    return List<String>.unmodifiable(params);
  }

  static List<StellarAssetMetadata> parseTomlCurrencies(String content) {
    final lines = content.split('\n');
    final List<StellarAssetMetadata> assets = [];
    Map<String, String> current = {};
    bool inCurrency = false;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      if (trimmed == '[[CURRENCIES]]') {
        if (inCurrency && current.isNotEmpty) {
          assets.add(StellarAssetMetadata.fromJson(current));
          current = {};
        }
        inCurrency = true;
        continue;
      }

      if (inCurrency) {
        final index = trimmed.indexOf('=');
        if (index != -1) {
          final key = trimmed.substring(0, index).trim();
          var value = trimmed.substring(index + 1).trim();
          value = value.replaceAll(RegExp(r'^"|"$'), ''); // remove quotes
          current[key] = value;
        }
      }
    }

    if (current.isNotEmpty) {
      assets.add(StellarAssetMetadata.fromJson(current));
    }

    return assets;
  }
}
