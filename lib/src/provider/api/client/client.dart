import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:stellar_dart/src/provider/core/core.dart';

import '../api/api.dart';

/// Quick client: high-level Stellar calls with unified result types.
///
/// Two providers (Horizon + Stellar RPC), each method pinned to its
/// backend(s) — see [StellarQuickClientApi] (both Stellar backends are
/// complementary, not alternatives).
abstract class StellarQuickClient with StellarQuickClientApi {
  const StellarQuickClient();
}

class DefaultStellarQuickClient extends StellarQuickClient {
  @override
  final IProvider<IServiceProvider, StellarRequestDetails> horizonProvider;

  @override
  final IProvider<IServiceProvider, StellarRequestDetails> rpcProvider;

  const DefaultStellarQuickClient({
    required this.horizonProvider,
    required this.rpcProvider,
  });
}
