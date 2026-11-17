// Stellar testnet: native XLM payment + account data entry.

import 'dart:convert';

import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// Amount sent from alice to bob, in XLM.
const String paymentAmount = '10';

/// Data entry written to alice's account.
const String dataName = 'stellar_dart';

void main() async {
  final net = await StellarTestnet.connect();

  final alice = stellarAccount(0);
  final bob = await net.fundAccount(1);

  print('Stellar testnet: payment and manage data');
  print(field('alice', alice.baseAddress));
  print(field('bob', bob.baseAddress));
  print('');

  final aliceBefore = await net.balanceOf(alice);
  final bobBefore = await net.balanceOf(bob);
  print(field('alice before', '${formatStroops(aliceBefore)} XLM'));
  print(field('bob before', '${formatStroops(bobBefore)} XLM'));
  print('');

  final hash = await net.submit(
    source: alice,
    signers: [stellarKey(0)],
    operations: [
      Operation(
        body: PaymentOperation(
          destination: bob.toMuxedAccount(),
          asset: StellarAssetNative(),
          amount: StellarHelper.toStroop(paymentAmount),
        ),
      ),
      Operation(
        body: ManageDataOperation(
          dataName: dataName,
          dataValue: utf8.encode('paid $paymentAmount XLM'),
        ),
      ),
    ],
  );
  print(field('tx', hash));
  print(field('explorer', 'https://stellar.expert/explorer/testnet/tx/$hash'));
  print('');

  final aliceAfter = await net.balanceOf(alice);
  final bobAfter = await net.balanceOf(bob);
  print(field('alice change', formatSigned(aliceAfter - aliceBefore)));
  print(field('bob change', formatSigned(bobAfter - bobBefore)));

  final account = await net.quick.getAccount(alice);
  final data = account?.data[dataName];
  final decoded = data == null ? null : utf8.decode(base64Decode(data));
  print(field('data entry', decoded ?? '-'));

  net.close();
  print('');
  print('done.');
}
