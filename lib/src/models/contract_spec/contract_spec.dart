/// Dart mirrors of the Soroban contract-spec XDR (`Stellar-contract-spec.x`).
/// Each class corresponds to an XDR struct or union of the same name and
/// carries its `layout()` (wire format) plus `fromStruct`/`toLayoutStruct`
/// (de)serialization, following the same pattern as the ledger models.
///
/// Contract function names live in the `contractspecv0` custom section of
/// the compiled WASM (`ContractCodeEntry.code` bytes) as concatenated
/// `ScSpecEntry` XDR values with no count prefix. Use
/// [StellarContractSpec.functionNamesFromWasm] to extract them.
library;

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/serialization/serialization.dart';
import 'package:stellar_dart/src/utils/validator.dart';

/// XDR `SCSpecType` discriminant values (`Stellar-contract-spec.x`).
/// Note the gaps (15, 18) — they are intentional in the official enum.
class ScSpecType {
  final String name;
  final int value;
  const ScSpecType._(this.name, this.value);

  static const ScSpecType val = ScSpecType._('val', 0);
  static const ScSpecType boolType = ScSpecType._('bool', 1);
  static const ScSpecType voidType = ScSpecType._('void', 2);
  static const ScSpecType error = ScSpecType._('error', 3);
  static const ScSpecType u32 = ScSpecType._('u32', 4);
  static const ScSpecType i32 = ScSpecType._('i32', 5);
  static const ScSpecType u64 = ScSpecType._('u64', 6);
  static const ScSpecType i64 = ScSpecType._('i64', 7);
  static const ScSpecType timepoint = ScSpecType._('timepoint', 8);
  static const ScSpecType duration = ScSpecType._('duration', 9);
  static const ScSpecType u128 = ScSpecType._('u128', 10);
  static const ScSpecType i128 = ScSpecType._('i128', 11);
  static const ScSpecType u256 = ScSpecType._('u256', 12);
  static const ScSpecType i256 = ScSpecType._('i256', 13);
  static const ScSpecType bytes = ScSpecType._('bytes', 14);
  static const ScSpecType string = ScSpecType._('string', 16);
  static const ScSpecType symbol = ScSpecType._('symbol', 17);
  static const ScSpecType address = ScSpecType._('address', 19);
  static const ScSpecType muxedAddress = ScSpecType._('muxedAddress', 20);
  static const ScSpecType option = ScSpecType._('option', 1000);
  static const ScSpecType result = ScSpecType._('result', 1001);
  static const ScSpecType vec = ScSpecType._('vec', 1002);
  static const ScSpecType map = ScSpecType._('map', 1004);
  static const ScSpecType tuple = ScSpecType._('tuple', 1005);
  static const ScSpecType bytesN = ScSpecType._('bytesN', 1006);
  static const ScSpecType udt = ScSpecType._('udt', 2000);
  static const List<ScSpecType> values = [
    val,
    boolType,
    voidType,
    error,
    u32,
    i32,
    u64,
    i64,
    timepoint,
    duration,
    u128,
    i128,
    u256,
    i256,
    bytes,
    string,
    symbol,
    address,
    muxedAddress,
    option,
    result,
    vec,
    map,
    tuple,
    bytesN,
    udt,
  ];
  static ScSpecType fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(
                DefaultErrorType.notFound,
                'ScSpecType not found.',
                details: {
                  'name': name,
                  'values': values.map((e) => e.name).join(', '),
                },
              ),
    );
  }

  static ScSpecType fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse:
          () =>
              throw BuError(
                DefaultErrorType.notFound,
                'ScSpecType not found.',
                details: {
                  'value': value?.toString(),
                  'values': values.map((e) => e.value).join(', '),
                },
              ),
    );
  }

  @override
  String toString() => 'ScSpecType.$name';
}

/// XDR `SCSpecTypeOption`: the inner type of an option typedef.
class ScSpecTypeOption extends XDRSerialization {
  final ScSpecTypeDef valueType;
  const ScSpecTypeOption(this.valueType);
  factory ScSpecTypeOption.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeOption(
      ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('valueType'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScSpecTypeDef.layout(property: 'valueType'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'valueType': valueType.toVariantLayoutStruct()};
  }
}

/// XDR `SCSpecTypeResult`: ok/error typedefs of a result typedef.
class ScSpecTypeResult extends XDRSerialization {
  final ScSpecTypeDef okType;
  final ScSpecTypeDef errorType;
  const ScSpecTypeResult({required this.okType, required this.errorType});
  factory ScSpecTypeResult.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeResult(
      okType: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('okType'),
      ),
      errorType: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('errorType'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScSpecTypeDef.layout(property: 'okType'),
      ScSpecTypeDef.layout(property: 'errorType'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'okType': okType.toVariantLayoutStruct(),
      'errorType': errorType.toVariantLayoutStruct(),
    };
  }
}

/// XDR `SCSpecTypeVec`: the element type of a vec typedef.
class ScSpecTypeVec extends XDRSerialization {
  final ScSpecTypeDef elementType;
  const ScSpecTypeVec(this.elementType);
  factory ScSpecTypeVec.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeVec(
      ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('elementType'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScSpecTypeDef.layout(property: 'elementType'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'elementType': elementType.toVariantLayoutStruct()};
  }
}

/// XDR `SCSpecTypeMap`: key/value typedefs of a map typedef.
class ScSpecTypeMap extends XDRSerialization {
  final ScSpecTypeDef keyType;
  final ScSpecTypeDef valueType;
  const ScSpecTypeMap({required this.keyType, required this.valueType});
  factory ScSpecTypeMap.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeMap(
      keyType: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('keyType'),
      ),
      valueType: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('valueType'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      ScSpecTypeDef.layout(property: 'keyType'),
      ScSpecTypeDef.layout(property: 'valueType'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'keyType': keyType.toVariantLayoutStruct(),
      'valueType': valueType.toVariantLayoutStruct(),
    };
  }
}

/// XDR `SCSpecTypeTuple`: element typedefs of a tuple typedef.
class ScSpecTypeTuple extends XDRSerialization {
  final List<ScSpecTypeDef> valueTypes;
  ScSpecTypeTuple(List<ScSpecTypeDef> valueTypes)
    : valueTypes = valueTypes.immutable;
  factory ScSpecTypeTuple.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeTuple(
      json
          .valueEnsureAsList<Map<String, dynamic>>('valueTypes')
          .map((e) => ScSpecTypeDef.fromStruct(e))
          .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrVec(ScSpecTypeDef.layout(), property: 'valueTypes'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'valueTypes': valueTypes.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecTypeBytesN`: fixed length of a bytes-n typedef.
class ScSpecTypeBytesN extends XDRSerialization {
  final int n;
  ScSpecTypeBytesN(int n) : n = n.asU32;
  factory ScSpecTypeBytesN.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeBytesN(json.valueAs('n'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.u32be(property: 'n'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'n': n};
  }
}

/// XDR `SCSpecTypeUDT`: name of a user-defined typedef.
class ScSpecTypeUdt extends XDRSerialization {
  final String name;
  ScSpecTypeUdt(String name)
    : name = StellarValidator.validateString(value: name, max: 1024);
  factory ScSpecTypeUdt.fromStruct(Map<String, dynamic> json) {
    return ScSpecTypeUdt(json.valueAs('name'));
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'name'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'name': name};
  }
}

/// XDR `SCSpecTypeDef` union: the type of a function input/output or field.
class ScSpecTypeDef extends XDRVariantSerialization {
  final ScSpecType type;
  final XDRSerialization? value;
  const ScSpecTypeDef._(this.type, [this.value]);

  const ScSpecTypeDef.val() : this._(ScSpecType.val);
  const ScSpecTypeDef.boolType() : this._(ScSpecType.boolType);
  const ScSpecTypeDef.voidType() : this._(ScSpecType.voidType);
  const ScSpecTypeDef.error() : this._(ScSpecType.error);
  const ScSpecTypeDef.u32() : this._(ScSpecType.u32);
  const ScSpecTypeDef.i32() : this._(ScSpecType.i32);
  const ScSpecTypeDef.u64() : this._(ScSpecType.u64);
  const ScSpecTypeDef.i64() : this._(ScSpecType.i64);
  const ScSpecTypeDef.timepoint() : this._(ScSpecType.timepoint);
  const ScSpecTypeDef.duration() : this._(ScSpecType.duration);
  const ScSpecTypeDef.u128() : this._(ScSpecType.u128);
  const ScSpecTypeDef.i128() : this._(ScSpecType.i128);
  const ScSpecTypeDef.u256() : this._(ScSpecType.u256);
  const ScSpecTypeDef.i256() : this._(ScSpecType.i256);
  const ScSpecTypeDef.bytes() : this._(ScSpecType.bytes);
  const ScSpecTypeDef.string() : this._(ScSpecType.string);
  const ScSpecTypeDef.symbol() : this._(ScSpecType.symbol);
  const ScSpecTypeDef.address() : this._(ScSpecType.address);
  const ScSpecTypeDef.muxedAddress() : this._(ScSpecType.muxedAddress);
  const ScSpecTypeDef.option(ScSpecTypeOption v) : this._(ScSpecType.option, v);
  const ScSpecTypeDef.result(ScSpecTypeResult v) : this._(ScSpecType.result, v);
  const ScSpecTypeDef.vec(ScSpecTypeVec v) : this._(ScSpecType.vec, v);
  const ScSpecTypeDef.map(ScSpecTypeMap v) : this._(ScSpecType.map, v);
  const ScSpecTypeDef.tuple(ScSpecTypeTuple v) : this._(ScSpecType.tuple, v);
  const ScSpecTypeDef.bytesN(ScSpecTypeBytesN v) : this._(ScSpecType.bytesN, v);
  const ScSpecTypeDef.udt(ScSpecTypeUdt v) : this._(ScSpecType.udt, v);

  factory ScSpecTypeDef.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final type = ScSpecType.fromName(decode.variantName);
    switch (type) {
      case ScSpecType.val:
        return const ScSpecTypeDef.val();
      case ScSpecType.boolType:
        return const ScSpecTypeDef.boolType();
      case ScSpecType.voidType:
        return const ScSpecTypeDef.voidType();
      case ScSpecType.error:
        return const ScSpecTypeDef.error();
      case ScSpecType.u32:
        return const ScSpecTypeDef.u32();
      case ScSpecType.i32:
        return const ScSpecTypeDef.i32();
      case ScSpecType.u64:
        return const ScSpecTypeDef.u64();
      case ScSpecType.i64:
        return const ScSpecTypeDef.i64();
      case ScSpecType.timepoint:
        return const ScSpecTypeDef.timepoint();
      case ScSpecType.duration:
        return const ScSpecTypeDef.duration();
      case ScSpecType.u128:
        return const ScSpecTypeDef.u128();
      case ScSpecType.i128:
        return const ScSpecTypeDef.i128();
      case ScSpecType.u256:
        return const ScSpecTypeDef.u256();
      case ScSpecType.i256:
        return const ScSpecTypeDef.i256();
      case ScSpecType.bytes:
        return const ScSpecTypeDef.bytes();
      case ScSpecType.string:
        return const ScSpecTypeDef.string();
      case ScSpecType.symbol:
        return const ScSpecTypeDef.symbol();
      case ScSpecType.address:
        return const ScSpecTypeDef.address();
      case ScSpecType.muxedAddress:
        return const ScSpecTypeDef.muxedAddress();
      case ScSpecType.option:
        return ScSpecTypeDef.option(ScSpecTypeOption.fromStruct(decode.value));
      case ScSpecType.result:
        return ScSpecTypeDef.result(ScSpecTypeResult.fromStruct(decode.value));
      case ScSpecType.vec:
        return ScSpecTypeDef.vec(ScSpecTypeVec.fromStruct(decode.value));
      case ScSpecType.map:
        return ScSpecTypeDef.map(ScSpecTypeMap.fromStruct(decode.value));
      case ScSpecType.tuple:
        return ScSpecTypeDef.tuple(ScSpecTypeTuple.fromStruct(decode.value));
      case ScSpecType.bytesN:
        return ScSpecTypeDef.bytesN(ScSpecTypeBytesN.fromStruct(decode.value));
      case ScSpecType.udt:
        return ScSpecTypeDef.udt(ScSpecTypeUdt.fromStruct(decode.value));
      default:
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid ScSpecTypeDef.',
        );
    }
  }

  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ScSpecType.val.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.val.name,
      ),
      LazyVariantModel(
        index: ScSpecType.boolType.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.boolType.name,
      ),
      LazyVariantModel(
        index: ScSpecType.voidType.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.voidType.name,
      ),
      LazyVariantModel(
        index: ScSpecType.error.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.error.name,
      ),
      LazyVariantModel(
        index: ScSpecType.u32.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.u32.name,
      ),
      LazyVariantModel(
        index: ScSpecType.i32.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.i32.name,
      ),
      LazyVariantModel(
        index: ScSpecType.u64.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.u64.name,
      ),
      LazyVariantModel(
        index: ScSpecType.i64.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.i64.name,
      ),
      LazyVariantModel(
        index: ScSpecType.timepoint.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.timepoint.name,
      ),
      LazyVariantModel(
        index: ScSpecType.duration.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.duration.name,
      ),
      LazyVariantModel(
        index: ScSpecType.u128.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.u128.name,
      ),
      LazyVariantModel(
        index: ScSpecType.i128.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.i128.name,
      ),
      LazyVariantModel(
        index: ScSpecType.u256.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.u256.name,
      ),
      LazyVariantModel(
        index: ScSpecType.i256.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.i256.name,
      ),
      LazyVariantModel(
        index: ScSpecType.bytes.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.bytes.name,
      ),
      LazyVariantModel(
        index: ScSpecType.string.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.string.name,
      ),
      LazyVariantModel(
        index: ScSpecType.symbol.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.symbol.name,
      ),
      LazyVariantModel(
        index: ScSpecType.address.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.address.name,
      ),
      LazyVariantModel(
        index: ScSpecType.muxedAddress.value,
        layout: LayoutConst.noArgs,
        property: ScSpecType.muxedAddress.name,
      ),
      LazyVariantModel(
        index: ScSpecType.option.value,
        layout: ScSpecTypeOption.layout,
        property: ScSpecType.option.name,
      ),
      LazyVariantModel(
        index: ScSpecType.result.value,
        layout: ScSpecTypeResult.layout,
        property: ScSpecType.result.name,
      ),
      LazyVariantModel(
        index: ScSpecType.vec.value,
        layout: ScSpecTypeVec.layout,
        property: ScSpecType.vec.name,
      ),
      LazyVariantModel(
        index: ScSpecType.map.value,
        layout: ScSpecTypeMap.layout,
        property: ScSpecType.map.name,
      ),
      LazyVariantModel(
        index: ScSpecType.tuple.value,
        layout: ScSpecTypeTuple.layout,
        property: ScSpecType.tuple.name,
      ),
      LazyVariantModel(
        index: ScSpecType.bytesN.value,
        layout: ScSpecTypeBytesN.layout,
        property: ScSpecType.bytesN.name,
      ),
      LazyVariantModel(
        index: ScSpecType.udt.value,
        layout: ScSpecTypeUdt.layout,
        property: ScSpecType.udt.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return value?.createLayout(property: property) ?? LayoutConst.noArgs();
  }

  /// Human-readable type name (`Option<u128>`, `Vec<address>`, ...).
  String get displayName {
    switch (type) {
      case ScSpecType.option:
        return 'Option<${(value as ScSpecTypeOption).valueType.displayName}>';
      case ScSpecType.result:
        final v = value as ScSpecTypeResult;
        return 'Result<${v.okType.displayName}, ${v.errorType.displayName}>';
      case ScSpecType.vec:
        return 'Vec<${(value as ScSpecTypeVec).elementType.displayName}>';
      case ScSpecType.map:
        final v = value as ScSpecTypeMap;
        return 'Map<${v.keyType.displayName}, ${v.valueType.displayName}>';
      case ScSpecType.tuple:
        final items = (value as ScSpecTypeTuple).valueTypes.map(
          (e) => e.displayName,
        );
        return 'Tuple<${items.join(', ')}>';
      case ScSpecType.bytesN:
        return 'BytesN<${(value as ScSpecTypeBytesN).n}>';
      case ScSpecType.udt:
        return (value as ScSpecTypeUdt).name;
      default:
        return type.name;
    }
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return value?.toLayoutStruct() ?? {};
  }

  @override
  String get variantName => type.name;
}

/// XDR `SCSpecFunctionInputV0`: one function parameter.
class ScSpecFunctionInputV0 extends XDRSerialization {
  final String doc;
  final String name;
  final ScSpecTypeDef type;
  ScSpecFunctionInputV0({
    required String doc,
    required String name,
    required this.type,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 30);
  factory ScSpecFunctionInputV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecFunctionInputV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      type: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('type'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      ScSpecTypeDef.layout(property: 'type'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'doc': doc, 'name': name, 'type': type.toVariantLayoutStruct()};
  }
}

/// XDR `SCSpecFunctionV0`: a contract function declaration.
class ScSpecFunctionV0 extends XDRSerialization {
  final String doc;
  final String name;
  final List<ScSpecFunctionInputV0> inputs;
  final List<ScSpecTypeDef> outputs;
  ScSpecFunctionV0({
    required String doc,
    required String name,
    required List<ScSpecFunctionInputV0> inputs,
    required List<ScSpecTypeDef> outputs,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 32),
       inputs = inputs.immutable,
       outputs = outputs.immutable;
  factory ScSpecFunctionV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecFunctionV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      inputs:
          json
              .valueEnsureAsList<Map<String, dynamic>>('inputs')
              .map((e) => ScSpecFunctionInputV0.fromStruct(e))
              .toList(),
      outputs:
          json
              .valueEnsureAsList<Map<String, dynamic>>('outputs')
              .map((e) => ScSpecTypeDef.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecFunctionInputV0.layout(), property: 'inputs'),
      LayoutConst.xdrVec(ScSpecTypeDef.layout(), property: 'outputs'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'name': name,
      'inputs': inputs.map((e) => e.toLayoutStruct()).toList(),
      'outputs': outputs.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }

  /// Human-readable signature, e.g. `transfer(from: address, amount: i128)`.
  String get signature {
    final args = inputs.map((e) => '${e.name}: ${e.type.displayName}');
    final out = outputs.map((e) => e.displayName).join(', ');
    final head = '$name(${args.join(', ')})';
    return out.isEmpty ? head : '$head -> $out';
  }
}

/// XDR `SCSpecUDTStructFieldV0`: one struct field.
class ScSpecUDTStructFieldV0 extends XDRSerialization {
  final String doc;
  final String name;
  final ScSpecTypeDef type;
  ScSpecUDTStructFieldV0({
    required String doc,
    required String name,
    required this.type,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 30);
  factory ScSpecUDTStructFieldV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTStructFieldV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      type: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('type'),
      ),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      ScSpecTypeDef.layout(property: 'type'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'doc': doc, 'name': name, 'type': type.toVariantLayoutStruct()};
  }
}

/// XDR `SCSpecUDTStructV0`: a user-defined struct declaration.
class ScSpecUDTStructV0 extends XDRSerialization {
  final String doc;
  final String lib;
  final String name;
  final List<ScSpecUDTStructFieldV0> fields;
  ScSpecUDTStructV0({
    required String doc,
    required String lib,
    required String name,
    required List<ScSpecUDTStructFieldV0> fields,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       lib = StellarValidator.validateString(value: lib, max: 80),
       name = StellarValidator.validateString(value: name, max: 1024),
       fields = fields.immutable;
  factory ScSpecUDTStructV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTStructV0(
      doc: json.valueAs('doc'),
      lib: json.valueAs('lib'),
      name: json.valueAs('name'),
      fields:
          json
              .valueEnsureAsList<Map<String, dynamic>>('fields')
              .map((e) => ScSpecUDTStructFieldV0.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'lib'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecUDTStructFieldV0.layout(), property: 'fields'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'lib': lib,
      'name': name,
      'fields': fields.map((e) => e.toLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecUDTUnionCaseVoidV0`: a unit union case.
class ScSpecUDTUnionCaseVoidV0 extends XDRSerialization {
  final String doc;
  final String name;
  ScSpecUDTUnionCaseVoidV0({required String doc, required String name})
    : doc = StellarValidator.validateString(value: doc, max: 1024),
      name = StellarValidator.validateString(value: name, max: 60);
  factory ScSpecUDTUnionCaseVoidV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTUnionCaseVoidV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'doc': doc, 'name': name};
  }
}

/// XDR `SCSpecUDTUnionCaseTupleV0`: a tuple union case.
class ScSpecUDTUnionCaseTupleV0 extends XDRSerialization {
  final String doc;
  final String name;
  final List<ScSpecTypeDef> types;
  ScSpecUDTUnionCaseTupleV0({
    required String doc,
    required String name,
    required List<ScSpecTypeDef> types,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 60),
       types = types.immutable;
  factory ScSpecUDTUnionCaseTupleV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTUnionCaseTupleV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      types:
          json
              .valueEnsureAsList<Map<String, dynamic>>('type')
              .map((e) => ScSpecTypeDef.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecTypeDef.layout(), property: 'type'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'name': name,
      'type': types.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecUDTUnionCaseV0Kind` discriminant values.
class ScSpecUDTUnionCaseKind {
  final String name;
  final int value;
  const ScSpecUDTUnionCaseKind._(this.name, this.value);

  static const ScSpecUDTUnionCaseKind voidCase = ScSpecUDTUnionCaseKind._(
    'voidCase',
    0,
  );
  static const ScSpecUDTUnionCaseKind tupleCase = ScSpecUDTUnionCaseKind._(
    'tupleCase',
    1,
  );
  static const List<ScSpecUDTUnionCaseKind> values = [voidCase, tupleCase];
  static ScSpecUDTUnionCaseKind fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(
                DefaultErrorType.notFound,
                'ScSpecUDTUnionCaseKind not found.',
                details: {'name': name},
              ),
    );
  }

  @override
  String toString() => 'ScSpecUDTUnionCaseKind.$name';
}

/// XDR `SCSpecUDTUnionCaseV0` union: one union case.
class ScSpecUDTUnionCaseV0 extends XDRVariantSerialization {
  final ScSpecUDTUnionCaseKind kind;
  final XDRSerialization value;
  const ScSpecUDTUnionCaseV0._(this.kind, this.value);

  const ScSpecUDTUnionCaseV0.voidCase(ScSpecUDTUnionCaseVoidV0 v)
    : this._(ScSpecUDTUnionCaseKind.voidCase, v);
  const ScSpecUDTUnionCaseV0.tupleCase(ScSpecUDTUnionCaseTupleV0 v)
    : this._(ScSpecUDTUnionCaseKind.tupleCase, v);

  factory ScSpecUDTUnionCaseV0.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final kind = ScSpecUDTUnionCaseKind.fromName(decode.variantName);
    switch (kind) {
      case ScSpecUDTUnionCaseKind.voidCase:
        return ScSpecUDTUnionCaseV0.voidCase(
          ScSpecUDTUnionCaseVoidV0.fromStruct(decode.value),
        );
      case ScSpecUDTUnionCaseKind.tupleCase:
        return ScSpecUDTUnionCaseV0.tupleCase(
          ScSpecUDTUnionCaseTupleV0.fromStruct(decode.value),
        );
      default:
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid ScSpecUDTUnionCaseV0.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ScSpecUDTUnionCaseKind.voidCase.value,
        layout: ScSpecUDTUnionCaseVoidV0.layout,
        property: ScSpecUDTUnionCaseKind.voidCase.name,
      ),
      LazyVariantModel(
        index: ScSpecUDTUnionCaseKind.tupleCase.value,
        layout: ScSpecUDTUnionCaseTupleV0.layout,
        property: ScSpecUDTUnionCaseKind.tupleCase.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return value.createLayout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return value.toLayoutStruct();
  }

  @override
  String get variantName => kind.name;
}

/// XDR `SCSpecUDTUnionV0`: a user-defined union declaration.
class ScSpecUDTUnionV0 extends XDRSerialization {
  final String doc;
  final String lib;
  final String name;
  final List<ScSpecUDTUnionCaseV0> cases;
  ScSpecUDTUnionV0({
    required String doc,
    required String lib,
    required String name,
    required List<ScSpecUDTUnionCaseV0> cases,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       lib = StellarValidator.validateString(value: lib, max: 80),
       name = StellarValidator.validateString(value: name, max: 1024),
       cases = cases.immutable;
  factory ScSpecUDTUnionV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTUnionV0(
      doc: json.valueAs('doc'),
      lib: json.valueAs('lib'),
      name: json.valueAs('name'),
      cases:
          json
              .valueEnsureAsList<Map<String, dynamic>>('cases')
              .map((e) => ScSpecUDTUnionCaseV0.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'lib'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecUDTUnionCaseV0.layout(), property: 'cases'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'lib': lib,
      'name': name,
      'cases': cases.map((e) => e.toVariantLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecUDTEnumCaseV0`: one enum case.
class ScSpecUDTEnumCaseV0 extends XDRSerialization {
  final String doc;
  final String name;
  final int value;
  ScSpecUDTEnumCaseV0({
    required String doc,
    required String name,
    required int value,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 60),
       value = value.asU32;
  factory ScSpecUDTEnumCaseV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTEnumCaseV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      value: json.valueAs('value'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.u32be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'doc': doc, 'name': name, 'value': value};
  }
}

/// XDR `SCSpecUDTEnumV0`: a user-defined enum declaration.
class ScSpecUDTEnumV0 extends XDRSerialization {
  final String doc;
  final String lib;
  final String name;
  final List<ScSpecUDTEnumCaseV0> cases;
  ScSpecUDTEnumV0({
    required String doc,
    required String lib,
    required String name,
    required List<ScSpecUDTEnumCaseV0> cases,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       lib = StellarValidator.validateString(value: lib, max: 80),
       name = StellarValidator.validateString(value: name, max: 1024),
       cases = cases.immutable;
  factory ScSpecUDTEnumV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTEnumV0(
      doc: json.valueAs('doc'),
      lib: json.valueAs('lib'),
      name: json.valueAs('name'),
      cases:
          json
              .valueEnsureAsList<Map<String, dynamic>>('cases')
              .map((e) => ScSpecUDTEnumCaseV0.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'lib'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecUDTEnumCaseV0.layout(), property: 'cases'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'lib': lib,
      'name': name,
      'cases': cases.map((e) => e.toLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecUDTErrorEnumCaseV0`: one error-enum case.
class ScSpecUDTErrorEnumCaseV0 extends XDRSerialization {
  final String doc;
  final String name;
  final int value;
  ScSpecUDTErrorEnumCaseV0({
    required String doc,
    required String name,
    required int value,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 60),
       value = value.asU32;
  factory ScSpecUDTErrorEnumCaseV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTErrorEnumCaseV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      value: json.valueAs('value'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.u32be(property: 'value'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {'doc': doc, 'name': name, 'value': value};
  }
}

/// XDR `SCSpecUDTErrorEnumV0`: a user-defined error-enum declaration.
class ScSpecUDTErrorEnumV0 extends XDRSerialization {
  final String doc;
  final String lib;
  final String name;
  final List<ScSpecUDTErrorEnumCaseV0> cases;
  ScSpecUDTErrorEnumV0({
    required String doc,
    required String lib,
    required String name,
    required List<ScSpecUDTErrorEnumCaseV0> cases,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       lib = StellarValidator.validateString(value: lib, max: 80),
       name = StellarValidator.validateString(value: name, max: 1024),
       cases = cases.immutable;
  factory ScSpecUDTErrorEnumV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecUDTErrorEnumV0(
      doc: json.valueAs('doc'),
      lib: json.valueAs('lib'),
      name: json.valueAs('name'),
      cases:
          json
              .valueEnsureAsList<Map<String, dynamic>>('cases')
              .map((e) => ScSpecUDTErrorEnumCaseV0.fromStruct(e))
              .toList(),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'lib'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(ScSpecUDTErrorEnumCaseV0.layout(), property: 'cases'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'lib': lib,
      'name': name,
      'cases': cases.map((e) => e.toLayoutStruct()).toList(),
    };
  }
}

/// XDR `SCSpecEventParamV0`: one event parameter.
class ScSpecEventParamV0 extends XDRSerialization {
  final String doc;
  final String name;
  final ScSpecTypeDef type;
  final int location;
  ScSpecEventParamV0({
    required String doc,
    required String name,
    required this.type,
    required int location,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       name = StellarValidator.validateString(value: name, max: 30),
       location = location.asU32;
  factory ScSpecEventParamV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecEventParamV0(
      doc: json.valueAs('doc'),
      name: json.valueAs('name'),
      type: ScSpecTypeDef.fromStruct(
        json.valueEnsureAsMap<String, dynamic>('type'),
      ),
      location: json.valueAs('location'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'name'),
      ScSpecTypeDef.layout(property: 'type'),
      LayoutConst.u32be(property: 'location'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'name': name,
      'type': type.toVariantLayoutStruct(),
      'location': location,
    };
  }
}

/// XDR `SCSpecEventV0`: a contract event declaration.
class ScSpecEventV0 extends XDRSerialization {
  final String doc;
  final String lib;
  final String name;
  final List<String> prefixTopics;
  final List<ScSpecEventParamV0> params;
  final int dataFormat;
  ScSpecEventV0({
    required String doc,
    required String lib,
    required String name,
    required List<String> prefixTopics,
    required List<ScSpecEventParamV0> params,
    required int dataFormat,
  }) : doc = StellarValidator.validateString(value: doc, max: 1024),
       lib = StellarValidator.validateString(value: lib, max: 80),
       name = StellarValidator.validateString(value: name, max: 1024),
       prefixTopics = prefixTopics.immutable,
       params = params.immutable,
       dataFormat = dataFormat.asU32;
  factory ScSpecEventV0.fromStruct(Map<String, dynamic> json) {
    return ScSpecEventV0(
      doc: json.valueAs('doc'),
      lib: json.valueAs('lib'),
      name: json.valueAs('name'),
      prefixTopics: json.valueEnsureAsList<String>('prefixTopics'),
      params:
          json
              .valueEnsureAsList<Map<String, dynamic>>('params')
              .map((e) => ScSpecEventParamV0.fromStruct(e))
              .toList(),
      dataFormat: json.valueAs('dataFormat'),
    );
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.struct([
      LayoutConst.xdrString(property: 'doc'),
      LayoutConst.xdrString(property: 'lib'),
      LayoutConst.xdrString(property: 'name'),
      LayoutConst.xdrVec(LayoutConst.xdrString(), property: 'prefixTopics'),
      LayoutConst.xdrVec(ScSpecEventParamV0.layout(), property: 'params'),
      LayoutConst.u32be(property: 'dataFormat'),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return {
      'doc': doc,
      'lib': lib,
      'name': name,
      'prefixTopics': prefixTopics,
      'params': params.map((e) => e.toLayoutStruct()).toList(),
      'dataFormat': dataFormat,
    };
  }
}

/// XDR `SCSpecEntryKind` discriminant values.
class ScSpecEntryKind {
  final String name;
  final int value;
  const ScSpecEntryKind._(this.name, this.value);

  static const ScSpecEntryKind functionV0 = ScSpecEntryKind._('functionV0', 0);
  static const ScSpecEntryKind udtStructV0 = ScSpecEntryKind._(
    'udtStructV0',
    1,
  );
  static const ScSpecEntryKind udtUnionV0 = ScSpecEntryKind._('udtUnionV0', 2);
  static const ScSpecEntryKind udtEnumV0 = ScSpecEntryKind._('udtEnumV0', 3);
  static const ScSpecEntryKind udtErrorEnumV0 = ScSpecEntryKind._(
    'udtErrorEnumV0',
    4,
  );
  static const ScSpecEntryKind eventV0 = ScSpecEntryKind._('eventV0', 5);
  static const List<ScSpecEntryKind> values = [
    functionV0,
    udtStructV0,
    udtUnionV0,
    udtEnumV0,
    udtErrorEnumV0,
    eventV0,
  ];
  static ScSpecEntryKind fromName(String? name) {
    return values.firstWhere(
      (e) => e.name == name,
      orElse:
          () =>
              throw BuError(
                DefaultErrorType.notFound,
                'ScSpecEntryKind not found.',
                details: {'name': name},
              ),
    );
  }

  @override
  String toString() => 'ScSpecEntryKind.$name';
}

/// XDR `SCSpecEntry` union: one contract-spec entry.
class ScSpecEntry extends XDRVariantSerialization {
  final ScSpecEntryKind kind;
  final XDRSerialization value;
  const ScSpecEntry._(this.kind, this.value);

  const ScSpecEntry.function(ScSpecFunctionV0 v)
    : this._(ScSpecEntryKind.functionV0, v);
  const ScSpecEntry.udtStruct(ScSpecUDTStructV0 v)
    : this._(ScSpecEntryKind.udtStructV0, v);
  const ScSpecEntry.udtUnion(ScSpecUDTUnionV0 v)
    : this._(ScSpecEntryKind.udtUnionV0, v);
  const ScSpecEntry.udtEnum(ScSpecUDTEnumV0 v)
    : this._(ScSpecEntryKind.udtEnumV0, v);
  const ScSpecEntry.udtErrorEnum(ScSpecUDTErrorEnumV0 v)
    : this._(ScSpecEntryKind.udtErrorEnumV0, v);
  const ScSpecEntry.event(ScSpecEventV0 v) : this._(ScSpecEntryKind.eventV0, v);

  factory ScSpecEntry.fromStruct(Map<String, dynamic> json) {
    final decode = XDRVariantSerialization.toVariantDecodeResult(json);
    final kind = ScSpecEntryKind.fromName(decode.variantName);
    switch (kind) {
      case ScSpecEntryKind.functionV0:
        return ScSpecEntry.function(ScSpecFunctionV0.fromStruct(decode.value));
      case ScSpecEntryKind.udtStructV0:
        return ScSpecEntry.udtStruct(
          ScSpecUDTStructV0.fromStruct(decode.value),
        );
      case ScSpecEntryKind.udtUnionV0:
        return ScSpecEntry.udtUnion(ScSpecUDTUnionV0.fromStruct(decode.value));
      case ScSpecEntryKind.udtEnumV0:
        return ScSpecEntry.udtEnum(ScSpecUDTEnumV0.fromStruct(decode.value));
      case ScSpecEntryKind.udtErrorEnumV0:
        return ScSpecEntry.udtErrorEnum(
          ScSpecUDTErrorEnumV0.fromStruct(decode.value),
        );
      case ScSpecEntryKind.eventV0:
        return ScSpecEntry.event(ScSpecEventV0.fromStruct(decode.value));
      default:
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid ScSpecEntry.',
        );
    }
  }
  static Layout<Map<String, dynamic>> layout({String? property}) {
    return LayoutConst.lazyEnumU32Be([
      LazyVariantModel(
        index: ScSpecEntryKind.functionV0.value,
        layout: ScSpecFunctionV0.layout,
        property: ScSpecEntryKind.functionV0.name,
      ),
      LazyVariantModel(
        index: ScSpecEntryKind.udtStructV0.value,
        layout: ScSpecUDTStructV0.layout,
        property: ScSpecEntryKind.udtStructV0.name,
      ),
      LazyVariantModel(
        index: ScSpecEntryKind.udtUnionV0.value,
        layout: ScSpecUDTUnionV0.layout,
        property: ScSpecEntryKind.udtUnionV0.name,
      ),
      LazyVariantModel(
        index: ScSpecEntryKind.udtEnumV0.value,
        layout: ScSpecUDTEnumV0.layout,
        property: ScSpecEntryKind.udtEnumV0.name,
      ),
      LazyVariantModel(
        index: ScSpecEntryKind.udtErrorEnumV0.value,
        layout: ScSpecUDTErrorEnumV0.layout,
        property: ScSpecEntryKind.udtErrorEnumV0.name,
      ),
      LazyVariantModel(
        index: ScSpecEntryKind.eventV0.value,
        layout: ScSpecEventV0.layout,
        property: ScSpecEntryKind.eventV0.name,
      ),
    ], property: property);
  }

  @override
  Layout<Map<String, dynamic>> createVariantLayout({String? property}) {
    return layout(property: property);
  }

  @override
  Layout<Map<String, dynamic>> createLayout({String? property}) {
    return value.createLayout(property: property);
  }

  @override
  Map<String, dynamic> toLayoutStruct() {
    return value.toLayoutStruct();
  }

  @override
  String get variantName => kind.name;
}

/// Reads Soroban contract-spec entries from compiled WASM bytes
/// (`ContractCodeEntry.code`).
///
/// The spec lives in the `contractspecv0` custom section as concatenated
/// `ScSpecEntry` XDR values with no count prefix (mirrors
/// `soroban-spec::from_wasm`).
class StellarContractSpec {
  /// All spec entries declared by the contract WASM.
  static List<ScSpecEntry> entriesFromWasm(List<int> wasm) {
    final spec = _specSectionBytes(wasm);
    final layout = ScSpecEntry.layout();
    final entries = <ScSpecEntry>[];
    var offset = 0;
    while (offset < spec.length) {
      final decoded = layout.deserialize(spec, offset: offset);
      entries.add(ScSpecEntry.fromStruct(decoded.value));
      if (decoded.consumed <= 0) {
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid contract spec entry.',
        );
      }
      offset += decoded.consumed;
    }
    return entries;
  }

  /// Names of all functions declared by the contract WASM.
  static List<String> functionNamesFromWasm(List<int> wasm) {
    return entriesFromWasm(wasm)
        .where((e) => e.kind == ScSpecEntryKind.functionV0)
        .map((e) => (e.value as ScSpecFunctionV0).name)
        .toList();
  }

  /// Readable signatures of all functions, e.g. `transfer(from: address)`.
  static List<String> functionSignaturesFromWasm(List<int> wasm) {
    return entriesFromWasm(wasm)
        .where((e) => e.kind == ScSpecEntryKind.functionV0)
        .map((e) => (e.value as ScSpecFunctionV0).signature)
        .toList();
  }

  /// Raw bytes of the `contractspecv0` custom section.
  static List<int> _specSectionBytes(List<int> wasm) {
    if (wasm.length < 8 ||
        wasm[0] != 0x00 ||
        wasm[1] != 0x61 ||
        wasm[2] != 0x73 ||
        wasm[3] != 0x6d) {
      throw const BuError(
        DefaultErrorType.invalidArgument,
        'Invalid WASM bytes.',
      );
    }
    final layout = LEB128U32OffsetLayout();
    var pos = 8;
    int readLeb() {
      try {
        final decode = layout.deserialize(wasm, offset: pos);
        pos += decode.consumed;
        return decode.value;
      } catch (_) {
        throw BuError(
          DefaultErrorType.invalidArgument,
          'Invalid WASM section: truncated LEB128 at offset $pos.',
        );
      }
    }

    while (pos < wasm.length) {
      final sectionId = readLeb();
      final size = readLeb();
      final end = pos + size;
      if (end > wasm.length) {
        throw const BuError(
          DefaultErrorType.invalidArgument,
          'Invalid WASM section.',
        );
      }
      if (sectionId == 0) {
        final nameLen = readLeb();

        if (pos + nameLen > end) {
          throw BuError(
            DefaultErrorType.invalidArgument,
            'Invalid WASM section: name length $nameLen exceeds section end.',
          );
        }
        final nameBytes = wasm.sublist(pos, pos + nameLen);
        pos += nameLen;
        if (StringUtils.decode(nameBytes) == 'contractspecv0') {
          return wasm.sublist(pos, end);
        }
      }
      pos = end;
    }
    throw const BuError(
      DefaultErrorType.notFound,
      'Contract spec not found in WASM.',
    );
  }
}
