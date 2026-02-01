import 'package:stellar_dart/src/provider/utils/utils.dart';
import 'package:stellar_dart/stellar_dart.dart';

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
      displayDecimals: int.tryParse(map['display_decimals'] ?? '7') ?? 7,
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
      throw const DartStellarPlugingException(
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
