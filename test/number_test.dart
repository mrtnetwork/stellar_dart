import 'package:stellar_dart/src/exception/exception.dart';
import 'package:stellar_dart/src/models/ledger/base.dart';
import 'package:test/test.dart';

void main() {
  _price();
  _int256Parts();
}

void _price() {
  test("Price ", () {
    const priceStr = "1.123333123";
    final price = StellarPrice.fromDecimal(priceStr);
    expect(price.numerator, 1123333123);
    expect(price.denominator, 1000000000);
    expect(price.toPrice(), priceStr);
    expect(price.toXDRHex(), "42f4b4033b9aca00");
  });
  test("Price ", () {
    const priceStr = "1";
    final price = StellarPrice.fromDecimal(priceStr);
    expect(price.numerator, 1);
    expect(price.denominator, 1);
    expect(price.toPrice(), priceStr);
    expect(price.toXDRHex(), "0000000100000001");
  });
  test("Price ", () {
    const priceStr = "0.003021";
    final price = StellarPrice.fromDecimal(priceStr);
    expect(price.numerator, 3021);
    expect(price.denominator, 1000000);
    expect(price.toPrice(), priceStr);
    expect(price.toXDRHex(), "00000bcd000f4240");
  });
  test("Price ", () {
    const priceStr = "10001233.12312111";
    final price = StellarPrice.fromDecimal(priceStr);
    expect(price.numerator, 650080153);
    expect(price.denominator, 65);
    expect(price.toXDRHex(), "26bf6f9900000041");
  });
}

void _int256Parts() {
  test("int256Parts 2", () {
    final number = BigInt.from(0);
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.zero);
    expect(n.hiLo, BigInt.zero);
    expect(n.loHi, BigInt.zero);
    expect(n.loLo, BigInt.zero);
  });
  test("int256Parts 3", () {
    final number = BigInt.from(1);
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.zero);
    expect(n.hiLo, BigInt.zero);
    expect(n.loHi, BigInt.zero);
    expect(n.loLo, BigInt.one);
  });
  test("int256Parts 4", () {
    final number = BigInt.parse("18446744073709551615");
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.zero);
    expect(n.hiLo, BigInt.zero);
    expect(n.loHi, BigInt.zero);
    expect(n.loLo, BigInt.parse("18446744073709551615"));
  });
  test("int256Parts 5", () {
    final number = BigInt.parse("340282366920938463463374607422231768211457");
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.zero);
    expect(n.hiLo, BigInt.parse("999"));
    expect(n.loHi, BigInt.parse("18446744073709551615"));
    expect(n.loLo, BigInt.parse("18446734537266307073"));
  });
  test("int256Parts 6", () {
    final number = BigInt.parse(
        "115792089237316195423570985008687907853269984665640564039457584007913129639935");
    final n = Int256Parts.fromNumber(number);
    expect(n.hiHi, BigInt.from(-1));
    expect(n.hiLo, BigInt.parse("18446744073709551615"));
    expect(n.loHi, BigInt.parse("18446744073709551615"));
    expect(n.loLo, BigInt.parse("18446744073709551615"));
  });
  test("int256Parts 7", () {
    final number = BigInt.parse(
        "-1684996666696914987166688442938726917102321526408785780068975640576");
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.from(-268435456));
    expect(n.hiLo, BigInt.zero);
    expect(n.loHi, BigInt.zero);
    expect(n.loLo, BigInt.zero);
  });
  test("int256Parts 8", () {
    final number = BigInt.parse(
        "-57896044618658097711785492504343953926634992332820282019728792003956564819967");
    final n = Int256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.parse("-9223372036854775808"));
    expect(n.hiLo, BigInt.zero);
    expect(n.loHi, BigInt.zero);
    expect(n.loLo, BigInt.one);
  });
  test("Int128Parts ", () {
    final number = BigInt.parse("-255");
    final n = Int128Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hi, BigInt.from(-1));
    expect(n.lo, BigInt.parse("18446744073709551361"));
  });
  test("Int128Parts 2", () {
    final number = BigInt.parse("23123123123123123");
    final n = Int128Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hi, BigInt.zero);
    expect(n.lo, BigInt.parse("23123123123123123"));
  });
  test("Int128Parts 2", () {
    final number = BigInt.parse("23123123123123123");
    final n = Int128Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hi, BigInt.zero);
    expect(n.lo, BigInt.parse("23123123123123123"));
  });
  test("UInt128Parts", () {
    final number = BigInt.parse("23123123123123123");
    final n = UInt128Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hi, BigInt.zero);
    expect(n.lo, BigInt.parse("23123123123123123"));
  });
  test("UInt128Parts", () {
    final number = BigInt.parse("23123123123123112312312312312312312312312323");
    final n = UInt256Parts.fromNumber(number);
    expect(n.toBigInt(), number);
    expect(n.hiHi, BigInt.zero);
    expect(n.hiLo, BigInt.from(67952));
    expect(n.loHi, BigInt.parse("13862940282578428842"));
    expect(n.loLo, BigInt.parse("2157334501225345539"));
  });
  test("UInt128Parts", () {
    final number =
        BigInt.parse("-23123123123123112312312312312312312312312323");
    expect(() => UInt256Parts.fromNumber(number),
        throwsA(isA<DartStellarPlugingException>()));
  });
  test("UInt128Parts", () {
    final number = BigInt.one << 129;
    expect(() => UInt128Parts.fromNumber(number),
        throwsA(isA<DartStellarPlugingException>()));
  });
}
