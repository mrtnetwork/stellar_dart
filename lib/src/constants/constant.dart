class StellarConst {
  static const int hash256Length = 32;
  static const int payloadLength = 64;
  static const int ed25519PubKeyLength = 32;
  static const int assetMaximumCodeLength = 12;
  static final assetCodeRegEx = RegExp(r'^[a-zA-Z0-9]{1,12}$');
  static const int lumenDecimal = 7;
  static const int str64 = 64;
  static const int dataValueLength = 64;
  static const int maxTransactionOperationLength = 100;
  static const int pubkeyHintBytesLength = 4;
  static const int ed25519SignatureLength = 64;
  static const int envlopSignaturesLength = 20;
  static const int thresHoldsLen = 4;
}
