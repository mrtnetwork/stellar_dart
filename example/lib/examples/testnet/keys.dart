// Stellar testnet: key/address encoding (offline, no network).

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

void main() {
  print('Stellar testnet: keys and addresses');
  print(field('network', StellarNetwork.testnet.passphrase));
  print('');

  final alice = stellarKey(0);
  final bob = stellarKey(1);

  print('alice (index 0)');
  print(field(
      'public key', BytesUtils.toHexString(alice.toPublicKey().toBytes())));
  print(field('address', alice.toPublicKey().toAddress().baseAddress));
  print(field('secret seed', alice.toBase32()));
  print(field('secret hex', alice.toHex()));

  print('');
  print('bob (index 1)');
  print(
      field('public key', BytesUtils.toHexString(bob.toPublicKey().toBytes())));
  print(field('address', bob.toPublicKey().toAddress().baseAddress));

  print('');
  print('same seed, different indexes give unrelated accounts:');
  print(field('same address', '${alice.toPublicKey() == bob.toPublicKey()}'));

  print('');
  print('a signature verifies against the public key:');
  final message = utf8.encode('stellar_dart example');
  final signature = alice.sign(message);
  print(field('hint', BytesUtils.toHexString(signature.hint)));
  print(
    field(
      'verified',
      '${alice.toPublicKey().verify(digest: message, signature: signature.signature)}',
    ),
  );

  print('');
  print('addresses decode back to the same key:');
  final address = alice.toPublicKey().toAddress();
  final decoded = StellarAddress.fromBase32Addr(address.baseAddress);
  print(field('type', '${decoded.type}'));
  print(field('round trip', '${decoded.baseAddress == address.baseAddress}'));
  print(field(
      'public key match', '${decoded.toPublicKey() == alice.toPublicKey()}'));
}
