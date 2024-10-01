import 'package:blockchain_utils/utils/utils.dart';
import 'package:stellar_dart/src/constants/constant.dart';
import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';

class StellarHelper {
  static final BigRational _lumenDecimalRational =
      BigRational(BigInt.from(10).pow(StellarConst.lumenDecimal));

  /// /// Converts a string representation of Lumen to Stroop (as BigInt).
  static BigInt toStroop(String lumen) {
    final parse = BigRational.parseDecimal(lumen);
    return (parse * _lumenDecimalRational).toBigInt();
  }

  /// Converts a Stroop value (as BigInt) back to Lumen in decimal format.
  static String fromStroop(BigInt stroop) {
    final parse = BigRational(stroop);
    return (parse / _lumenDecimalRational)
        .toDecimal(digits: StellarConst.lumenDecimal);
  }

  static String toAssetsCode(List<int> data) {
    int end = data.length - 1;
    while (end >= 0 && data[end] == 0) {
      end--;
    }
    return StringUtils.decode(data.sublist(0, end + 1));
  }

  static StellarPrice approximatePriceUsingContinuedFraction(String price) {
    final BigInt maxInt =
        BigInt.from(2147483647); // Equivalent to max 32-bit int
    BigRational number = BigRational.parseDecimal(price);

    // Initialize with [n0, d0] = [0, 1] and [n1, d1] = [1, 0] for continued fraction calculation
    List<BigRational> numerators = [BigRational.zero, BigRational.one];
    List<BigRational> denominators = [BigRational.one, BigRational.zero];

    while (true) {
      BigRational integerPart = number.floor();
      BigRational fractionalPart = number - integerPart;

      BigRational newNumerator = (numerators[1] * integerPart) + numerators[0];
      BigRational newDenominator =
          (denominators[1] * integerPart) + denominators[0];

      // Stop if the new numerator or denominator exceeds the max int limit
      if (newNumerator.toBigInt() > maxInt ||
          newDenominator.toBigInt() > maxInt) {
        break;
      }

      numerators[0] = numerators[1];
      numerators[1] = newNumerator;

      denominators[0] = denominators[1];
      denominators[1] = newDenominator;

      if (fractionalPart.isZero) {
        break;
      }

      // Recalculate the next approximation
      number = BigRational.one / fractionalPart;
    }

    final BigInt finalNumerator = numerators[1].toBigInt();
    final BigInt finalDenominator = denominators[1].toBigInt();

    if (finalNumerator == BigInt.zero || finalDenominator == BigInt.zero) {
      throw DartStellarPlugingException("Couldn't find approximation",
          details: {"price": price});
    }

    return StellarPrice(
        numerator: finalNumerator.toInt(),
        denominator: finalDenominator.toInt());
  }

  static List<int> toAlphanumAssetCode(
      {required String code, required int length}) {
    final codeBytes = StringUtils.encode(code);
    if (code.length > length) {
      throw DartStellarPlugingException("Invalid asset code length.", details: {
        "excepted": length,
        "length": codeBytes.length,
        "code": code
      });
    }
    final toBytes = List<int>.filled(length, 0);
    toBytes.setAll(0, codeBytes);
    return toBytes;
  }

  static Object? toReadableObject(Object? val) {
    if (val is Map) {
      final newMap =
          val.map((key, value) => MapEntry(key, toReadableObject(value)));
      return newMap..removeWhere((e, k) => k == null);
    }
    if (val is String || val is int) {
      return val;
    }
    if (val is BigInt) {
      return val.toString();
    }
    if (val is List<int>) {
      return BytesUtils.tryToHexString(val, prefix: "0x") ?? val;
    }
    if (val is List) {
      return val.map(toReadableObject).toList();
    }
    return val.toString();
  }

  static bool isValidIssueAsset(
      {required String code, required AssetType type}) {
    assert(type != AssetType.native);
    switch (type) {
      case AssetType.creditAlphanum12:
        final RegExp regExp = RegExp(r'^[a-zA-Z0-9]{5,12}$');
        return regExp.hasMatch(code);
      case AssetType.creditAlphanum4:
        final RegExp regExp = RegExp(r'^[a-zA-Z0-9]{1,4}$');
        return regExp.hasMatch(code);
      case AssetType.poolShare:
        final toBytes = BytesUtils.tryFromHexString(code);
        return toBytes?.length == StellarConst.hash256Length;
      default:
        return false;
    }
  }
}
