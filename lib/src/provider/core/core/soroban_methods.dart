class SorobanAPIMethods {
  final String name;
  const SorobanAPIMethods._(this.name);
  static const SorobanAPIMethods getEvents = SorobanAPIMethods._("getEvents");
  static const SorobanAPIMethods simulateTransaction =
      SorobanAPIMethods._("simulateTransaction");
  static const SorobanAPIMethods getFeeStats =
      SorobanAPIMethods._("getFeeStats");
  static const SorobanAPIMethods getLatestLedger =
      SorobanAPIMethods._("getLatestLedger");
  static const SorobanAPIMethods getLedgerEntries =
      SorobanAPIMethods._("getLedgerEntries");
  static const SorobanAPIMethods getNetwork = SorobanAPIMethods._("getNetwork");
  static const SorobanAPIMethods getTransaction =
      SorobanAPIMethods._("getTransaction");
  static const SorobanAPIMethods getTransactions =
      SorobanAPIMethods._("getTransactions");
  static const SorobanAPIMethods getVersionInfo =
      SorobanAPIMethods._("getVersionInfo");
  static const SorobanAPIMethods sendTransaction =
      SorobanAPIMethods._("sendTransaction");
  static const SorobanAPIMethods getHealth = SorobanAPIMethods._("getHealth");

  @override
  String toString() {
    return "SorobanAPIMethods.$name";
  }
}
