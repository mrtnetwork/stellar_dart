import 'package:stellar_dart/stellar_dart.dart';

class StellarNetwork {
  final List<int> passphraseHash;
  final String name;
  final String passphrase;
  const StellarNetwork._(
      {required this.passphrase,
      required this.passphraseHash,
      required this.name});
  static const StellarNetwork mainnet = StellarNetwork._(
      passphrase: _StellarNetworkConst.mainnet,
      passphraseHash: _StellarNetworkConst.mainnetHash,
      name: "Mainnet");
  static const StellarNetwork testnet = StellarNetwork._(
      passphrase: _StellarNetworkConst.testnet,
      passphraseHash: _StellarNetworkConst.testnetHash,
      name: "Testnet");
  static const StellarNetwork futurenet = StellarNetwork._(
      passphrase: _StellarNetworkConst.future,
      passphraseHash: _StellarNetworkConst.futureHash,
      name: "Futurenet");
  static const List<StellarNetwork> values = [mainnet, testnet, futurenet];
  static StellarNetwork fromPassphrase(String? passphrase) {
    return values.firstWhere((e) => e.passphrase == passphrase,
        orElse: () => throw DartStellarPlugingException(
            "Network not found with the provided passphrase.",
            details: {"passphrase": passphrase}));
  }
}

class _StellarNetworkConst {
  static const mainnet = "Public Global Stellar Network ; September 2015";
  static const testnet = "Test SDF Network ; September 2015";
  static const future = "Test SDF Future Network ; October 2022";

  static const List<int> mainnetHash = [
    122,
    195,
    57,
    151,
    84,
    78,
    49,
    117,
    210,
    102,
    189,
    2,
    36,
    57,
    178,
    44,
    219,
    22,
    80,
    140,
    1,
    22,
    63,
    38,
    229,
    203,
    42,
    62,
    16,
    69,
    169,
    121
  ];
  static const List<int> testnetHash = [
    206,
    224,
    48,
    45,
    89,
    132,
    77,
    50,
    189,
    202,
    145,
    92,
    130,
    3,
    221,
    68,
    179,
    63,
    187,
    126,
    220,
    25,
    5,
    30,
    163,
    122,
    190,
    223,
    40,
    236,
    212,
    114
  ];
  static const List<int> futureHash = [
    163,
    161,
    198,
    167,
    130,
    134,
    113,
    62,
    41,
    190,
    14,
    151,
    133,
    103,
    15,
    168,
    56,
    209,
    57,
    23,
    205,
    142,
    174,
    180,
    163,
    87,
    159,
    241,
    222,
    188,
    127,
    213
  ];
}
