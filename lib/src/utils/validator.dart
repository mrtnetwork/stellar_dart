import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';

class StellarValidator {
  static String validateAssetCode(String code, {int? length}) {
    if (!StellarConst.assetCodeRegEx.hasMatch(code)) {
      throw DartStellarPlugingException(
        'Incorrect asset code.',
        details: {'code': code},
      );
    }
    length ??= StellarConst.assetMaximumCodeLength;
    if (code.length > length) {
      throw DartStellarPlugingException(
        'Invalid  assets code length.',
        details: {
          'maximum': length.toString(),
          'length': code.length.toString(),
          'code': code,
        },
      );
    }
    return code;
  }

  static String validateString({
    required String value,
    required int max,
    String? name,
  }) {
    if (value.length > max) {
      throw DartStellarPlugingException(
        "Incorrect ${name == null ? '' : '$name '}String length.",
        details: {'maximum': max.toString(), 'length': value.length.toString()},
      );
    }
    return value;
  }
}
