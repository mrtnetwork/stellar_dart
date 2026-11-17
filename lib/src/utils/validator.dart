import 'package:stellar_dart/src/constants/constant.dart';
import 'package:blockchain_utils/blockchain_utils.dart';

/// Internal argument validation helpers.
class StellarValidator {
  static String validateAssetCode(String code, {int? length}) {
    if (!StellarConst.assetCodeRegEx.hasMatch(code)) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Incorrect asset code.',
        details: {'code': code},
      );
    }
    length ??= StellarConst.assetMaximumCodeLength;
    if (code.length > length) {
      throw BuError(DefaultErrorType.invalidLength, 
        'Invalid asset code length.',
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
      throw BuError(DefaultErrorType.invalidLength, 
        "Incorrect ${name == null ? '' : '$name '}String length.",
        details: {'maximum': max.toString(), 'length': value.length.toString()},
      );
    }
    return value;
  }
}
