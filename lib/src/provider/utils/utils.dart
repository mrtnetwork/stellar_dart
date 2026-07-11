import 'package:stellar_dart/src/provider/models/response/metadata.dart';

class StellarProviderUtils {
  static List<String> extractParams(String url) {
    final RegExp pathParamRegex = RegExp(r':\w+');
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
