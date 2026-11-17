// Stellar testnet: two-hop path payment (XLM -> AAA -> TST).

import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// Asset sold for XLM.
const String hopCode = 'AAA';

/// Asset bought with the hop asset.
const String targetCode = 'TST';

/// XLM the sender pays.
const String sendAmount = '20';

/// Minimum TST the sender accepts.
const String destMin = '50';

/// Balance of `code`, issued by [issuer], in stroops.
Future<BigInt> assetBalance(
  StellarTestnet net,
  StellarAddress account,
  StellarAddress issuer,
  String code,
) {
  return net.quick.getAssetBalance(
    account: account,
    assetCode: code,
    issuer: issuer,
  );
}

/// Rebuilds a [StellarAsset] from a Horizon balance line.
StellarAsset _assetOf(HorizonBaseAsset asset, StellarAddress issuer) {
  if (asset.assetType == 'native') return StellarAssetNative();
  return stellarAsset(issuer: issuer, code: asset.assetCode ?? '');
}

Future<void> main() async {
  final net = await StellarTestnet.connect();

  final issuer = await net.fundAccount(2);

  /// The trader provides the liquidity.
  final trader = await net.fundAccount(4);
  final sender = await net.fundAccount(6);

  print('Stellar testnet: path payment');
  print(field('issuer', issuer.baseAddress));
  print(field('trader', trader.baseAddress));
  print(field('sender', sender.baseAddress));
  print('');

  final hop = stellarAsset(issuer: issuer, code: hopCode);
  final target = stellarAsset(issuer: issuer, code: targetCode);

  /// ---- 1. trustlines and balances --------------------------------------
  for (final account in [trader, sender]) {
    final key = account == trader ? stellarKey(4) : stellarKey(6);
    await net.submit(
      source: account,
      signers: [key],
      operations: [
        for (final asset in [target, hop])
          Operation(
            body: ChangeTrustOperation(
              asset: asset,
              limit: StellarHelper.toStroop('1000000'),
            ),
          ),
      ],
    );
  }

  for (final code in [targetCode, hopCode]) {
    await net.submit(
      source: issuer,
      signers: [stellarKey(2)],
      operations: [
        Operation(
          body: PaymentOperation(
            destination: trader.toMuxedAccount(),
            asset: stellarAsset(issuer: issuer, code: code),
            amount: StellarHelper.toStroop('1000'),
          ),
        ),
      ],
    );
  }
  print(field('trader $hopCode',
      formatStroops(await assetBalance(net, trader, issuer, hopCode))));
  print(field('trader $targetCode',
      formatStroops(await assetBalance(net, trader, issuer, targetCode))));
  print('');

  /// ---- 2. offers -------------------------------------------------------
  final existing = await net.quick.horizonProvider.request(
    HorizonRequestGetOffersByAccountId(accountId: trader.baseAddress),
  );
  for (final offer in existing.embedded?.records ?? const []) {
    await net.submit(
      source: trader,
      signers: [stellarKey(4)],
      operations: [
        Operation(
          body: ManageSellOfferOperation(
            selling: _assetOf(offer.selling, issuer),
            buying: _assetOf(offer.buying, issuer),
            amount: BigInt.zero,
            price: StellarPrice.fromDecimal(offer.price),
            offerId: BigInt.parse(offer.id),
          ),
        ),
      ],
    );
  }

  await net.submit(
    source: trader,
    signers: [stellarKey(4)],
    operations: [
      Operation(
        body: ManageSellOfferOperation(
          selling: hop,
          buying: StellarAssetNative(),
          amount: StellarHelper.toStroop('1000'),
          price: StellarPrice.fromDecimal('0.1'),
          offerId: BigInt.zero,
        ),
      ),
      Operation(
        body: ManageSellOfferOperation(
          selling: target,
          buying: hop,
          amount: StellarHelper.toStroop('1000'),
          price: StellarPrice.fromDecimal('2'),
          offerId: BigInt.zero,
        ),
      ),
    ],
  );
  print(field('offers placed', '2'));
  await Future<void>.delayed(const Duration(seconds: 2));

  final book = await net.quick.horizonProvider.request(
    HorizonRequestRetrieveAnOrderBook(
      sellingAssetType: HorizonBalanceLineAssetAssetType.creditAlphanum4,
      sellingAssetCode: targetCode,
      sellingAssetIssuer: issuer.baseAddress,
      buyingAssetType: HorizonBalanceLineAssetAssetType.creditAlphanum4,
      buyingAssetCode: hopCode,
      buyingAssetIssuer: issuer.baseAddress,
    ),
  );
  print(field('book $targetCode:$hopCode asks', '${book.asks?.length ?? 0}'));
  print('');

  /// ---- 3. swap ---------------------------------------------------------
  final senderBefore = await net.balanceOf(sender);
  final targetBefore = await assetBalance(net, sender, issuer, targetCode);

  final hash = await net.submit(
    source: sender,
    signers: [stellarKey(6)],
    operations: [
      Operation(
        body: PathPaymentStrictSendOperation(
          sendAsset: StellarAssetNative(),
          sendAmount: StellarHelper.toStroop(sendAmount),
          destination: sender.toMuxedAccount(),
          destAsset: target,
          destMin: StellarHelper.toStroop(destMin),
          path: [hop],
        ),
      ),
    ],
  );
  print(field('tx', hash));
  print('');

  final senderAfter = await net.balanceOf(sender);
  final targetAfter = await assetBalance(net, sender, issuer, targetCode);
  print(field('XLM change', formatSigned(senderAfter - senderBefore)));
  print(
      field('$targetCode received', formatSigned(targetAfter - targetBefore)));

  net.close();
  print('');
  print('done.');
}
