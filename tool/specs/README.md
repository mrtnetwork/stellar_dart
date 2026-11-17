# Vendored specs and live-API divergences

Specs:
- `horizon.json` <- `horizon-bundled.yml` (stellar-docs `openapi/horizon/bundled.yml`)
  plus live-API corrections (see `regen_v2.dart` header).
- `horizon_result_map.json`: operationId -> concrete RESULT model, for
  operations whose live wire shape differs from the schema (verified live on
  testnet). Current entries: single-item GETs return the flat record, and
  `SubmitATransaction` returns the flat transaction (`HorizonTransaction2`),
  not the `SubmitTransaction` `_embedded.records` envelope from the schema.

## Post-regen manual patches (regen wipes them — re-apply every time)

1. `lib/src/provider/methods/horizon/transactions.dart`
   (`HorizonRequestSubmitATransaction`): restore the
   `Content-Type: application/x-www-form-urlencoded` headers override.
   The generator emits no per-operation headers, but live Horizon answers
   `415 unsupported_media_type` to this endpoint when the Dart default
   (`application/json`) is sent — verified live on testnet.
