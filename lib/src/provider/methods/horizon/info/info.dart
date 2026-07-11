import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/response/info.dart';

class HorizonRequestNodeInfo
    extends HorizonRequest<HorizonNodeInfo, Map<String, dynamic>> {
  const HorizonRequestNodeInfo({super.paginationParams});

  @override
  String get method => StellarHorizonMethods.info.url;

  @override
  List<String> get pathParameters => [];
  @override
  HorizonNodeInfo onResonse(Map<String, dynamic> result) {
    return HorizonNodeInfo.fromJson(result);
  }
}
