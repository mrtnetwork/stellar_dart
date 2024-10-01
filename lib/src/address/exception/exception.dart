import 'package:stellar_dart/src/exception/exception.dart';

class StellarAddressException extends DartStellarPlugingException {
  const StellarAddressException(String message, {Map<String, dynamic>? details})
      : super(message, details: details);
}
