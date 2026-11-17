import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/helper/helper.dart';

/// Base for a type that can be encoded to / decoded from Stellar XDR.
abstract class XDRSerialization {
  static Map<String, dynamic> deserialize({
    required List<int> bytes,
    required Layout<Map<String, dynamic>> layout,
  }) {
    final decode = layout.deserialize(bytes);
    return decode.value;
  }

  const XDRSerialization();

  Layout<Map<String, dynamic>> createLayout({String? property});
  Map<String, dynamic> toLayoutStruct();
  BuBytes toXDR({String? property}) {
    final layout = createLayout(property: property);
    return layout.serialize(toLayoutStruct());
  }

  String toXDRHex() {
    return BytesUtils.toHexString(toXDR());
  }

  String toXDRBase64() {
    return StringUtils.decode(toXDR(), encoding: StringEncoding.base64);
  }

  Map<String, dynamic> toJson() {
    final toReadable = StellarHelper.toReadableObject(toLayoutStruct());
    return (toReadable as Map).cast();
  }
}

/// A decoded XDR union: the selected variant's name and its payload.
class XDRVariantDecodeResult {
  final Map<String, dynamic> result;
  String get variantName => result['key'];
  Map<String, dynamic> get value => result['value'];
  XDRVariantDecodeResult(Map<String, dynamic> result)
    : result = result.immutable;

  @override
  String toString() {
    return '$variantName: $value';
  }
}

/// Base for an XDR union (discriminated variant) type.
abstract class XDRVariantSerialization extends XDRSerialization {
  const XDRVariantSerialization();
  static XDRVariantDecodeResult toVariantDecodeResult(
    Map<String, dynamic> json,
  ) {
    if (json['key'] is! String || !json.containsKey('value')) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Invalid variant layout. Only enum layouts can be deserialized with `XDRVariantSerialization.deserialize`.',
      );
    }
    return XDRVariantDecodeResult(json);
  }

  static Map<String, dynamic> deserialize({
    required List<int> bytes,
    required Layout<Map<String, dynamic>> layout,
  }) {
    final json = layout.deserialize(bytes).value;
    if (json['key'] is! String || !json.containsKey('value')) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Invalid variant layout. Only enum layouts can be deserialized with `XDRVariantSerialization.deserialize`.',
      );
    }
    return json;
  }

  String get variantName;
  Layout<Map<String, dynamic>> createVariantLayout({String? property});
  Map<String, dynamic> toVariantLayoutStruct() {
    return {variantName: toLayoutStruct()};
  }

  BuBytes toVariantXDR({String? property}) {
    final layout = createVariantLayout(property: property);
    return layout.serialize(toVariantLayoutStruct());
  }

  String toVariantXDRHex() {
    return BytesUtils.toHexString(toVariantXDR());
  }

  String toVariantXDRBase64() {
    return StringUtils.decode(toVariantXDR(), encoding: StringEncoding.base64);
  }

  @override
  Map<String, dynamic> toJson() {
    final toReadable = StellarHelper.toReadableObject(toVariantLayoutStruct());
    return (toReadable as Map).cast();
  }
}
