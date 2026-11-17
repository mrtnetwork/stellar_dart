import 'dart:convert';
import 'package:stellar_dart/stellar_dart.dart';
import 'package:test/test.dart';

/// Contract-spec parsing: WASM `contractspecv0` section walk + XDR entries.
void main() {
  List<int> leb(int v) {
    final out = <int>[];
    do {
      var b = v & 0x7f;
      v >>= 7;
      if (v != 0) b |= 0x80;
      out.add(b);
    } while (v != 0);
    return out;
  }

  List<int> customSection(String name, List<int> data) {
    final nameBytes = utf8.encode(name);
    final payload = [...leb(nameBytes.length), ...nameBytes, ...data];
    return [0, ...leb(payload.length), ...payload];
  }

  List<int> wasmWithSpec(List<int> specData) {
    final other = customSection('other', [1, 2, 3]);
    final spec = customSection('contractspecv0', specData);
    return [0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, ...other, ...spec];
  }

  ScSpecEntry fn(
    String name, {
    List<ScSpecFunctionInputV0> inputs = const [],
    List<ScSpecTypeDef> outputs = const [],
  }) {
    return ScSpecEntry.function(
      ScSpecFunctionV0(doc: '', name: name, inputs: inputs, outputs: outputs),
    );
  }

  test('function names are extracted from WASM spec section', () {
    final entries = [
      fn(
        'transfer',
        inputs: [
          ScSpecFunctionInputV0(
            doc: '',
            name: 'from',
            type: const ScSpecTypeDef.address(),
          ),
          ScSpecFunctionInputV0(
            doc: '',
            name: 'amount',
            type: const ScSpecTypeDef.option(
              ScSpecTypeOption(ScSpecTypeDef.u128()),
            ),
          ),
        ],
        outputs: [const ScSpecTypeDef.boolType()],
      ),
      fn('decimals', outputs: [const ScSpecTypeDef.u32()]),
      ScSpecEntry.udtStruct(
        ScSpecUDTStructV0(doc: '', lib: '', name: 'Token', fields: const []),
      ),
    ];
    final specData = [for (final e in entries) ...e.toVariantXDR()];
    final wasm = wasmWithSpec(specData);

    final parsed = StellarContractSpec.entriesFromWasm(wasm);
    expect(parsed.length, 3);
    expect(parsed[0].kind, ScSpecEntryKind.functionV0);
    expect(parsed[2].kind, ScSpecEntryKind.udtStructV0);

    expect(StellarContractSpec.functionNamesFromWasm(wasm), [
      'transfer',
      'decimals',
    ]);
    expect(StellarContractSpec.functionSignaturesFromWasm(wasm), [
      'transfer(from: address, amount: Option<u128>) -> bool',
      'decimals() -> u32',
    ]);
  });

  test('missing spec section throws', () {
    final wasm = [
      0x00,
      0x61,
      0x73,
      0x6d,
      0x01,
      0x00,
      0x00,
      0x00,
      ...customSection('other', [9, 9]),
    ];
    expect(
      () => StellarContractSpec.functionNamesFromWasm(wasm),
      throwsA(isA<BuError>()),
    );
  });
}
