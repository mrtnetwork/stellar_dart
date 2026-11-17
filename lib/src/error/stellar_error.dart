import 'package:blockchain_utils/blockchain_utils.dart';

/// Stellar-specific error types. Phase 2: taxonomy only, no serialization.
enum StellarErrorType implements BuErrorType {
  plugin(15000),
  address(15001);

  @override
  String get domain => 'stellar';

  @override
  String get errName => name;

  @override
  final int id;
  const StellarErrorType(this.id);

  @override
  bool isValid(int? tag) {
    return values.any((e) => e.id == tag);
  }
}
