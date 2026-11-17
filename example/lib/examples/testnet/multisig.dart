// Stellar testnet: 2-of-2 multisig (add signer, raise threshold, co-sign, remove).

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// XLM sent by the co-signed payment.
const String paymentAmount = '5';

Future<void> main() async {
  final net = await StellarTestnet.connect();

  final master = stellarAccount(5);
  final masterKey = stellarKey(5);

  /// Only the key material is needed for the second signer; it never needs an
  /// account of its own.
  final second = stellarKey(7);
  final destination = await net.fundAccount(1);

  print('Stellar testnet: multisig');
  print(field('master', master.baseAddress));
  print(field('second signer', second.toPublicKey().toAddress().baseAddress));
  print(field('destination', destination.baseAddress));
  print('');

  await net.fund(master);
  await restore(net, master, masterKey, second);

  final account = await net.quick.getAccount(master);
  print(field(
      'start thresholds',
      'low ${account?.thresholds.lowThreshold} '
          'med ${account?.thresholds.medThreshold} '
          'high ${account?.thresholds.highThreshold}'));
  print(field('start signers', '${account?.signers.length ?? 0}'));

  /// ---- 1. add the second signer (1-of-2) -------------------------------
  await net.submit(
    source: master,
    signers: [masterKey],
    operations: [
      Operation(
        body: SetOptionsOperation(
          masterWeight: 1,
          lowThreshold: 1,
          medThreshold: 1,
          highThreshold: 1,
          signer: Signer(
            key: SignerKeyEd25519(second.toPublicKey().toBytes()),
            weight: 1,
          ),
        ),
      ),
    ],
  );
  print('');
  print(field('after setup', '1-of-2'));

  /// ---- 2. payments now need two signatures -----------------------------
  await net.submit(
    source: master,
    signers: [masterKey],
    operations: [
      Operation(body: SetOptionsOperation(medThreshold: 2)),
    ],
  );
  final updated = await net.quick.getAccount(master);
  print(field('medium threshold', '${updated?.thresholds.medThreshold}'));
  print(field('signers', '${updated?.signers.length ?? 0}'));
  print('');

  /// ---- 3. one signature is not enough ----------------------------------
  final destinationBefore = await net.balanceOf(destination);
  try {
    await net.submit(
      source: master,
      signers: [masterKey],
      operations: [payment(destination)],
    );
    print(field('one signature', 'accepted (unexpected)'));
  } on RPCError catch (error) {
    print(field('one signature', 'rejected'));
    print(field('  result', _resultCodes(error)));
  }
  print('');

  /// ---- 4. both signatures ---------------------------------------------
  final hash = await net.submit(
    source: master,
    signers: [masterKey, second],
    operations: [payment(destination)],
  );
  print(field('two signatures', hash));
  print(field('destination change',
      formatSigned(await net.balanceOf(destination) - destinationBefore)));
  print('');

  /// ---- 5. back to a single signer --------------------------------------
  await restore(net, master, masterKey, second);
  final restored = await net.quick.getAccount(master);
  print(field(
      'restored thresholds',
      'low ${restored?.thresholds.lowThreshold} '
          'med ${restored?.thresholds.medThreshold} '
          'high ${restored?.thresholds.highThreshold}'));
  print(field('restored signers', '${restored?.signers.length ?? 0}'));

  net.close();
  print('');
  print('done.');
}

/// A payment of [paymentAmount] XLM from the master account to [destination].
Operation payment(StellarAddress destination) {
  return Operation(
    body: PaymentOperation(
      destination: destination.toMuxedAccount(),
      asset: StellarAssetNative(),
      amount: StellarHelper.toStroop(paymentAmount),
    ),
  );
}

/// Puts [master] back to a single signer, signed by both keys.
///
/// The addresses are deterministic, so a rerun starts from whatever the
/// previous run left behind; this keeps the example repeatable.
Future<void> restore(
  StellarTestnet net,
  StellarAddress master,
  StellarPrivateKey masterKey,
  StellarPrivateKey second,
) async {
  final account = await net.quick.getAccount(master);
  final needsReset = account == null ||
      account.signers.length != 1 ||
      account.thresholds.medThreshold != 1 ||
      account.thresholds.highThreshold != 1;
  if (!needsReset) return;
  final operations = [
    Operation(
      body: SetOptionsOperation(
        masterWeight: 1,
        lowThreshold: 1,
        medThreshold: 1,
        highThreshold: 1,
        signer: Signer(
          key: SignerKeyEd25519(second.toPublicKey().toBytes()),
          weight: 0,
        ),
      ),
    ),
  ];

  /// A set-options transaction is a high-threshold operation. Start with the
  /// master signature alone: Stellar rejects surplus signatures with
  /// `tx_bad_auth_extra`, so the second key is only added when the account
  /// still requires it.
  try {
    await net.submit(
        source: master, signers: [masterKey], operations: operations);
  } on RPCError {
    await net.submit(
      source: master,
      signers: [masterKey, second],
      operations: operations,
    );
  }
}

/// `extras.result_codes` of a failed submission, for the transcript.
String _resultCodes(RPCError error) {
  final json = error.jsonRpcErrpr;
  if (json is! Map<String, dynamic>) return error.message;
  final extras = json['extras'];
  if (extras is! Map) return error.message;
  final codes = extras['result_codes'];
  return codes?.toString() ?? error.message;
}
