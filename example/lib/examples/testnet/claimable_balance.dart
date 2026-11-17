// Stellar testnet: claimable balances (create for bob, bob claims).

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// Amount locked in the claimable balance, in XLM.
const String claimAmount = '5';

Future<void> main() async {
  final net = await StellarTestnet.connect();

  final alice = await net.fundAccount(0);
  final bob = await net.fundAccount(1);

  print('Stellar testnet: claimable balance');
  print(field('alice', alice.baseAddress));
  print(field('bob', bob.baseAddress));
  print('');

  final aliceBefore = await net.balanceOf(alice);
  final bobBefore = await net.balanceOf(bob);

  /// ---- 1. create --------------------------------------------------------
  /// The predicate is unconditional, so bob can claim at any time.
  final create = await net.submit(
    source: alice,
    signers: [stellarKey(0)],
    operations: [
      Operation(
        body: CreateClaimableBalanceOperation(
          asset: StellarAssetNative(),
          amount: StellarHelper.toStroop(claimAmount),
          claimants: [
            ClaimantV0(
              destination: bob.toPublicKey(),
              predicate: const ClaimPredicateUnconditional(),
            ),
          ],
        ),
      ),
    ],
  );
  print(field('create', create));

  /// The balance id is the `CREATE_CLAIMABLE_BALANCE_SUCCESS` result of the
  /// transaction. (`/claimable_balances` cannot be decoded by the library: see
  /// review.md, issue 1.)
  final balanceId = await claimableBalanceId(net, create);
  print(field('balance id', balanceId));
  print(field('alice after create',
      formatSigned(await net.balanceOf(alice) - aliceBefore)));
  print('');

  /// ---- 2. claim ---------------------------------------------------------
  final claim = await net.submit(
    source: bob,
    signers: [stellarKey(1)],
    operations: [
      Operation(
        body: ClaimClaimableBalanceOperation(
          ClaimableBalanceIdV0(BytesUtils.fromHexString(balanceId)),
        ),
      ),
    ],
  );
  print(field('claim', claim));
  print(
      field('bob change', formatSigned(await net.balanceOf(bob) - bobBefore)));
  print(field('bob balance', '${formatStroops(await net.balanceOf(bob))} XLM'));

  net.close();
  print('');
  print('done.');
}

/// Reads the claimable balance id created by [hash] out of its result XDR.
Future<String> claimableBalanceId(StellarTestnet net, String hash) async {
  final tx = await net.quick.horizonProvider.request(
    HorizonRequestRetrieveATransaction(transactionHash: hash),
  );
  final resultXdr = tx.resultXdr;
  if (resultXdr == null) throw StateError('transaction $hash has no result');
  final result = TransactionResult.fromXdr(
    const Base64Decoder().convert(resultXdr),
  );
  final code = result.code;
  if (code is! TransactionResultTxSuccess) {
    throw StateError('transaction $hash did not succeed');
  }
  for (final operation in code.operationResult) {
    if (operation case OperationResultOpInner(:final opInner)) {
      if (opInner
          case CreateClaimableBalanceResultSuccess(
            :final balanceId as ClaimableBalanceIdV0,
          )) {
        return BytesUtils.toHexString(balanceId.hash);
      }
    }
  }
  throw StateError('no claimable balance was created by $hash');
}
