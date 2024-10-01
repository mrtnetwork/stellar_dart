import 'package:stellar_dart/src/provider/core/core.dart';
import 'package:stellar_dart/src/provider/models/models.dart';

mixin StellarServiceProvider {
  Future<HorizonServiceResponse> post(HorizonRequestDetails params,
      [Duration? timeout]);

  Future<HorizonServiceResponse> get(HorizonRequestDetails params,
      [Duration? timeout]);
}
