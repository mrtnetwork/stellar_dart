import 'package:stellar_dart/src/provider/core/core/core.dart';
import 'package:stellar_dart/src/provider/core/core/methods.dart';
import 'package:stellar_dart/src/provider/models/request/request_types.dart';

/// This endpoint lists all effects and can be used in streaming mode.
/// Streaming mode allows you to listen for new effects as they are added to the Stellar ledger.
///  If called in streaming mode, Horizon will start at the earliest known effect unless a cursor is set,
/// in which case it will start from that cursor. By setting the cursor value to now,
/// you can stream effects created since your request time.
/// https://developers.stellar.org/docs/data/horizon/api-reference/list-all-effects
class HorizonRequestEffects
    extends HorizonRequestParam<Map<String, dynamic>, Map<String, dynamic>> {
  const HorizonRequestEffects({HorizonPaginationParams? paginationParams})
      : super(paginationParams: paginationParams);

  @override
  String get method => StellarHorizonMethods.effects.url;

  @override
  List<String> get pathParameters => [];
}
