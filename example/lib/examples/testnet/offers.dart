// Stellar testnet: order book (place, read, cancel a sell offer).

import 'package:example/examples/local/stellar_node.dart';
import 'package:stellar_dart/stellar_dart.dart';

/// Asset the trader sells.
const String assetCode = 'TST';

/// Amount sold by the resting offer, in TST.
const String sellAmount = '100';

/// Price of the offer in XLM per TST.
const String offerPrice = '0.5';

void main() async {
  final net = await StellarTestnet.connect();

  final issuer = await net.fundAccount(2);

  /// A separate trader keeps the offer example independent from the others.
  final trader = await net.fundAccount(4);

  print('Stellar testnet: offers');
  print(field('issuer', issuer.baseAddress));
  print(field('trader', trader.baseAddress));
  print('');

  final asset = stellarAsset(issuer: issuer, code: assetCode);

  /// The trader needs a trustline and a balance before it can sell.
  await net.submit(
    source: trader,
    signers: [stellarKey(4)],
    operations: [
      Operation(
        body: ChangeTrustOperation(
          asset: asset,
          limit: StellarHelper.toStroop('1000000'),
        ),
      ),
    ],
  );
  await net.submit(
    source: issuer,
    signers: [stellarKey(2)],
    operations: [
      Operation(
        body: PaymentOperation(
          destination: trader.toMuxedAccount(),
          asset: asset,
          amount: StellarHelper.toStroop('1000'),
        ),
      ),
    ],
  );
  print(field(
      'trader balance',
      '${formatStroops(await net.quick.getAssetBalance(
        account: trader,
        assetCode: assetCode,
        issuer: issuer,
      ))} TST'));
  print('');

  /// The trader address is deterministic, so an earlier run may have left
  /// offers behind; clear them before placing a new one.
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
            selling: asset,
            buying: StellarAssetNative(),
            amount: BigInt.zero,
            price: StellarPrice.fromDecimal(offerPrice),
            offerId: BigInt.parse(offer.id),
          ),
        ),
      ],
    );
  }
  print(field(
      'stale offers cleared', '${existing.embedded?.records?.length ?? 0}'));

  /// ---- 1. place the offer ----------------------------------------------
  final create = await net.submit(
    source: trader,
    signers: [stellarKey(4)],
    operations: [
      Operation(
        body: ManageSellOfferOperation(
          selling: asset,
          buying: StellarAssetNative(),
          amount: StellarHelper.toStroop(sellAmount),
          price: StellarPrice.fromDecimal(offerPrice),
          offerId: BigInt.zero,
        ),
      ),
    ],
  );
  print(field('create offer', create));
  await Future<void>.delayed(const Duration(seconds: 2));

  final offers = await net.quick.horizonProvider.request(
    HorizonRequestGetOffersByAccountId(accountId: trader.baseAddress),
  );
  final records = offers.embedded?.records ?? const [];
  print(field('open offers', '${records.length}'));
  for (final offer in records) {
    print(field('  offer id', offer.id));
    print(field('    selling', '${offer.amount} $assetCode'));
    print(field('    buying', 'XLM at ${offer.price}'));
  }
  if (records.isEmpty) throw StateError('the offer was not created');
  print('');

  /// ---- 2. read the book -----------------------------------------------
  final book = await net.quick.horizonProvider.request(
    HorizonRequestRetrieveAnOrderBook(
      sellingAssetType: HorizonBalanceLineAssetAssetType.creditAlphanum4,
      sellingAssetCode: assetCode,
      sellingAssetIssuer: issuer.baseAddress,
      buyingAssetType: HorizonBalanceLineAssetAssetType.native,
    ),
  );
  print('order book TST:XLM');
  print(field('  asks', '${book.asks?.length ?? 0}'));
  for (final ask in book.asks ?? const []) {
    print(field('    price', '${ask.price}'));
    print(field('    amount', '${ask.amount} TST'));
  }
  print('');

  /// ---- 3. cancel -------------------------------------------------------
  final cancel = await net.submit(
    source: trader,
    signers: [stellarKey(4)],
    operations: [
      Operation(
        body: ManageSellOfferOperation(
          selling: asset,
          buying: StellarAssetNative(),
          amount: BigInt.zero,
          price: StellarPrice.fromDecimal(offerPrice),
          offerId: BigInt.parse(records.first.id),
        ),
      ),
    ],
  );
  print(field('cancel', cancel));

  final after = await net.quick.horizonProvider.request(
    HorizonRequestGetOffersByAccountId(accountId: trader.baseAddress),
  );
  print(field('open offers', '${after.embedded?.records?.length ?? 0}'));

  net.close();
  print('');
  print('done.');
}
