import 'package:blockchain_utils/blockchain_utils.dart';

class HorizonAPIError extends RPCError {
  final String? type;

  HorizonAPIError({
    required String message,
    required int? errorCode,
    this.type,
    Map<String, dynamic>? request,
    Map<String, dynamic>? extras,
  }) : super(
            message: message,
            errorCode: errorCode,
            request: request,
            details: extras);
  bool get isNotFound => errorCode == 404;
}
