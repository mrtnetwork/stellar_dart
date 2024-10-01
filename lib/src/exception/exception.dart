import 'package:blockchain_utils/exception/exceptions.dart';

class DartStellarPlugingException extends BlockchainUtilsException {
  const DartStellarPlugingException(String message,
      {Map<String, dynamic>? details})
      : super(message, details: details);
}
