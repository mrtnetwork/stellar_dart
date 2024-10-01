class StellarHorizonMethods {
  final String name;
  final String url;
  const StellarHorizonMethods._({required this.name, required this.url});

  static const StellarHorizonMethods health =
      StellarHorizonMethods._(name: "health", url: "/health");

  static const StellarHorizonMethods transactions =
      StellarHorizonMethods._(name: "transactions", url: "/transactions");
  static const StellarHorizonMethods transaction = StellarHorizonMethods._(
      name: "transaction", url: "/transactions/:transaction_id");
  static const StellarHorizonMethods transactionOperations =
      StellarHorizonMethods._(
          name: "transactionOperations",
          url: "/transactions/:transaction_id/operations");
  static const StellarHorizonMethods transactionEffects =
      StellarHorizonMethods._(
          name: "transactionEffects",
          url: "/transactions/:transaction_id/effects");
  static const StellarHorizonMethods submitTransaction =
      StellarHorizonMethods._(name: "submitTransaction", url: "/transactions");
  static const StellarHorizonMethods submitTransactionAsynchronously =
      StellarHorizonMethods._(
          name: "submitTransactionAsynchronously", url: "/transactions_async");

  static const StellarHorizonMethods accounts =
      StellarHorizonMethods._(name: "accounts", url: "/accounts");
  static const StellarHorizonMethods account =
      StellarHorizonMethods._(name: "account", url: "/accounts/:account_id");
  static const StellarHorizonMethods accountTransactions =
      StellarHorizonMethods._(
          name: "accountTransactions",
          url: "/accounts/:account_id/transactions");
  static const StellarHorizonMethods accountOperations =
      StellarHorizonMethods._(
          name: "accountOperations", url: "/accounts/:account_id/operations");
  static const StellarHorizonMethods accountPayments = StellarHorizonMethods._(
      name: "accountPayments", url: "/accounts/:account_id/payments");
  static const StellarHorizonMethods accountEffects = StellarHorizonMethods._(
      name: "accountEffects", url: "/accounts/:account_id/effects");
  static const StellarHorizonMethods accountOffers = StellarHorizonMethods._(
      name: "accountPayments", url: "/accounts/:account_id/offers");
  static const StellarHorizonMethods accountTrads = StellarHorizonMethods._(
      name: "accountPayments", url: "/accounts/:account_id/trades");
  static const StellarHorizonMethods accountData = StellarHorizonMethods._(
      name: "accountPayments", url: "/accounts/:account_id/data/:key");

  static const StellarHorizonMethods ledger =
      StellarHorizonMethods._(name: "ledger", url: "/ledgers/:sequence");
  static const StellarHorizonMethods ledgerTransactions =
      StellarHorizonMethods._(
          name: "ledgerTransactions", url: "/ledgers/:sequence/transactions");
  static const StellarHorizonMethods ledgerPayments = StellarHorizonMethods._(
      name: "ledgerPayments", url: "/ledgers/:sequence/payments");
  static const StellarHorizonMethods ledgerOperations = StellarHorizonMethods._(
      name: "ledgerOperations", url: "/ledgers/:sequence/operations");
  static const StellarHorizonMethods ledgerEffects = StellarHorizonMethods._(
      name: "ledgerEffects", url: "/ledgers/:sequence/effects");

  static const StellarHorizonMethods ledgers =
      StellarHorizonMethods._(name: "ledgers", url: "/ledgers");

  static const StellarHorizonMethods operations =
      StellarHorizonMethods._(name: "operations", url: "/operations");

  static const StellarHorizonMethods operation =
      StellarHorizonMethods._(name: "operation", url: "/operations/:id");
  static const StellarHorizonMethods operationEffects = StellarHorizonMethods._(
      name: "operationEffects", url: "/operations/:id/effects");

  static const StellarHorizonMethods effects =
      StellarHorizonMethods._(name: "effects", url: "/effects");

  static const StellarHorizonMethods offers =
      StellarHorizonMethods._(name: "offers", url: "/offers");
  static const StellarHorizonMethods offer =
      StellarHorizonMethods._(name: "offer", url: "/offers/:offer_id");
  static const StellarHorizonMethods offerTrades = StellarHorizonMethods._(
      name: "offerTrades", url: "/offers/:offer_id/trades");

  static const StellarHorizonMethods tradeAggregations =
      StellarHorizonMethods._(
          name: "tradeAggregations", url: "/trade_aggregations");

  static const StellarHorizonMethods feeStats =
      StellarHorizonMethods._(name: "feeStats", url: "/fee_stats");

  static const StellarHorizonMethods orderBook =
      StellarHorizonMethods._(name: "orderBook", url: "/order_book");

  static const StellarHorizonMethods assets =
      StellarHorizonMethods._(name: "assets", url: "/assets");

  static const StellarHorizonMethods claimableBalances =
      StellarHorizonMethods._(
          name: "claimableBalances", url: "/claimable_balances");
  static const StellarHorizonMethods claimableBalance = StellarHorizonMethods._(
      name: "claimableBalance",
      url: "/claimable_balances/:claimable_balance_id");
  static const StellarHorizonMethods claimableBalanceTransactions =
      StellarHorizonMethods._(
          name: "claimableBalanceById",
          url: "/claimable_balances/:claimable_balance_id/transactions");
  static const StellarHorizonMethods claimableBalanceOperations =
      StellarHorizonMethods._(
          name: "claimableBalanceById",
          url: "/claimable_balances/:claimable_balance_id/operations");

  static const StellarHorizonMethods liquidityPools =
      StellarHorizonMethods._(name: "liquidityPools", url: "/liquidity_pools");
  static const StellarHorizonMethods liquidityPool = StellarHorizonMethods._(
      name: "liquidityPool", url: "/liquidity_pools/:liquidity_pool_id");
  static const StellarHorizonMethods liquidityPoolEffects =
      StellarHorizonMethods._(
          name: "liquidityPoolEffects",
          url: "/liquidity_pools/:liquidity_pool_id/effects");
  static const StellarHorizonMethods liquidityPoolTrades =
      StellarHorizonMethods._(
          name: "liquidityPoolTrades",
          url: "/liquidity_pools/:liquidity_pool_id/trades");
  static const StellarHorizonMethods liquidityPoolTransactions =
      StellarHorizonMethods._(
          name: "liquidityPoolTransactions",
          url: "/liquidity_pools/:liquidity_pool_id/transactions");
  static const StellarHorizonMethods liquidityPoolOperations =
      StellarHorizonMethods._(
          name: "liquidityPoolOperations",
          url: "/liquidity_pools/:liquidity_pool_id/operations");

  static const StellarHorizonMethods payments =
      StellarHorizonMethods._(name: "payments", url: "/payments");
  static const StellarHorizonMethods transactionPayments =
      StellarHorizonMethods._(
          name: "transactionPayments", url: "/transactions/:tx_id/payments");

  static const StellarHorizonMethods trades =
      StellarHorizonMethods._(name: "trades", url: "/trades");
  static const StellarHorizonMethods paymentPaths = StellarHorizonMethods._(
      name: "paymentPaths", url: "/paths/strict-receive");
  static const StellarHorizonMethods sendPaymentPaths = StellarHorizonMethods._(
      name: "sendPaymentPaths", url: "/paths/strict-send");

  // List of all values
  static const List<StellarHorizonMethods> values = [
    sendPaymentPaths,
    paymentPaths,
    trades,
    payments,
    transactionPayments,
    liquidityPool,
    liquidityPoolEffects,
    liquidityPoolOperations,
    liquidityPoolTrades,
    liquidityPoolTransactions,
    liquidityPools,
    accountData,
    accountTrads,
    accountOffers,
    accountEffects,
    accountOperations,
    accountTransactions,
    accountPayments,
    accountOperations,
    health,
    transactions,
    transaction,
    transactionEffects,
    transactionOperations,
    transactionPayments,
    submitTransaction,
    submitTransactionAsynchronously,
    accounts,
    account,
    ledgers,
    ledgerEffects,
    ledgerOperations,
    ledgerPayments,
    ledger,
    ledgerTransactions,
    operations,
    operation,
    operationEffects,
    effects,
    offers,
    offer,
    offerTrades,
    tradeAggregations,
    orderBook,
    assets,
    claimableBalances,
    claimableBalance,
    claimableBalanceOperations,
    claimableBalanceTransactions
  ];
}
