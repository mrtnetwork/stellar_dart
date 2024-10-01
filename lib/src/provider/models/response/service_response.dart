class HorizonServiceResponse {
  final String body;
  final int statusCode;
  const HorizonServiceResponse({required this.body, required this.statusCode});
  bool get success => statusCode >= 200 && statusCode < 300;
}
