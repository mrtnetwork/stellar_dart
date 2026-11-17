// Stellar testnet: issue TST (trustline, pay, pay back).

import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// Asset code issued by the issuer account.
const String assetCode = 'TST';

/// Trustline limit the holder sets, in TST.
///
/// The addresses are deterministic, so a rerun finds the balance left by the
/// previous run; a generous limit keeps the example idempotent.
const String trustLimit = '1000000';

/// Amount the issuer pays to the holder, in TST.
const String issueAmount = '500';

/// Amount the holder sends back to the issuer, in TST.
const String returnAmount = '50';

void main() async {
  final net = await StellarTestnet.connect();

  final issuer = await net.fundAccount(2);
  final holder = await net.fundAccount(3);

  print('Stellar testnet: issuing an asset');
  print(field('issuer', issuer.baseAddress));
  print(field('holder', holder.baseAddress));
  print(field('asset', '$assetCode:${issuer.baseAddress}'));
  print('');

  final asset = stellarAsset(issuer: issuer, code: assetCode);

  /// ---- 1. trustline ----------------------------------------------------
  final trustHash = await net.submit(
    source: holder,
    signers: [stellarKey(3)],
    operations: [
      Operation(
        body: ChangeTrustOperation(
          asset: asset,
          limit: StellarHelper.toStroop(trustLimit),
        ),
      ),
    ],
  );
  print(field('change trust', trustHash));
  print('');

  /// ---- 2. issue --------------------------------------------------------
  final holderBefore = await net.quick.getAssetBalance(
    account: holder,
    assetCode: assetCode,
    issuer: issuer,
  );
  final issueHash = await net.submit(
    source: issuer,
    signers: [stellarKey(2)],
    operations: [
      Operation(
        body: PaymentOperation(
          destination: holder.toMuxedAccount(),
          asset: asset,
          amount: StellarHelper.toStroop(issueAmount),
        ),
      ),
    ],
  );
  print(field('issue', issueHash));
  final issued = await net.quick.getAssetBalance(
    account: holder,
    assetCode: assetCode,
    issuer: issuer,
  );
  print(field(
      'holder balance',
      '${formatStroops(issued)} TST '
          '(${formatSigned(issued - holderBefore)})'));
  print('');

  /// ---- 3. send back ----------------------------------------------------
  final returnHash = await net.submit(
    source: holder,
    signers: [stellarKey(3)],
    operations: [
      Operation(
        body: PaymentOperation(
          destination: issuer.toMuxedAccount(),
          asset: asset,
          amount: StellarHelper.toStroop(returnAmount),
        ),
      ),
    ],
  );
  print(field('return', returnHash));
  print('');

  final holderBalance = await net.quick.getAssetBalance(
    account: holder,
    assetCode: assetCode,
    issuer: issuer,
  );
  print(field(
      'holder balance',
      '${formatStroops(holderBalance)} TST '
          '(${formatSigned(holderBalance - issued)})'));
  print(field('back at issuer', 'issuer holds the rest'));

  final account = await net.quick.getAccount(holder);
  for (final balance in account?.balances ?? const []) {
    if (balance
        case HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset(
          :final value,
        )
        when value.assetCode == assetCode &&
            value.assetIssuer == issuer.baseAddress) {
      print(field(
        'trustline limit',
        '${formatStroops(StellarQuickClientApi.parseBalanceToStroops(value.limit))} TST',
      ));
      print(field('authorized', '${value.isAuthorized}'));
    }
  }

  net.close();
  print('');
  print('done.');
}
