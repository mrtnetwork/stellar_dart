// Stellar testnet: account, balances and network state via the quick client.

import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

void main() async {
  final net = await StellarTestnet.connect();

  print('Stellar testnet: accounts');
  print(field('horizon', stellarHorizonUrl));
  print(field('rpc', stellarRpcUrl));
  print(field('ledger', '${await net.ledger()}'));
  print('');

  final address = stellarAccount(0);
  print(field('account', address.baseAddress));
  print(field('exists before', '${await net.exists(address)}'));

  await net.fund(address);
  print(field('funded', 'yes'));

  final account = await net.quick.getAccount(address);
  if (account == null) throw StateError('account disappeared');
  print('');
  print('account');
  print(field('  sequence', account.sequence));
  print(field(
      '  thresholds',
      'low ${account.thresholds.lowThreshold} '
          'med ${account.thresholds.medThreshold} '
          'high ${account.thresholds.highThreshold}'));
  print(field(
      '  flags',
      'auth-required ${account.flags.authRequired} '
          'auth-revocable ${account.flags.authRevocable}'));
  print(field('  signers', '${account.signers.length}'));
  print(field('  subentry count', '${account.subentryCount}'));
  print(field('  data entries', '${account.data.length}'));

  print('');
  final balances = await net.quick.getAccountBalances(address);
  print('balances');
  for (final balance in balances) {
    switch (balance) {
      case HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineNative(
          :final value,
        ):
        print(field('  native', value.balance));
      case HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineAsset(
          :final value,
        ):
        print(
          field(
            '  ${value.assetCode}',
            '${value.balance} (issuer ${value.assetIssuer})',
          ),
        );
      case HorizonAccountEmbeddedRecordsItemBalancesItemBalanceLineLiquidityPool(
          :final value,
        ):
        print(field('  liquidity pool', value.balance));
    }
  }

  final native = await net.quick.getNativeBalance(address);
  print('');
  print(field('native balance', '${formatStroops(native)} XLM'));

  print('');
  final reserve = await net.quick.getBaseReserve();
  print(field('base reserve', '${formatStroops(BigInt.from(reserve))} XLM'));

  final fees = await net.quick.feeStats();
  print('fee stats');
  print(field('  last ledger', '${fees.lastLedger}'));
  print(field('  base fee', '${fees.lastLedgerBaseFee} stroops'));
  print(field('  ledger capacity', '${fees.ledgerCapacityUsage}'));

  net.close();
  print('');
  print('done.');
}
