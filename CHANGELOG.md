# Changelog

## 0.6.0

- Add ES-scoped issuer certificate file uploads, representation verification,
  submission-verification retries and pending-change cancellation.
- Expose active submission readiness and pending verification results from the
  deployed API contract (47 operations).
- Keep certificate uploads as native multipart requests without automatic retries.


## 0.5.0 — 2026-09-28

- Match the deployed current-account API routes and split invoicing settings into a dedicated resource.
- Use `/tax-ids/{id}` for tax ID retrieval.
- Regenerate response and request types from the updated FiscalRail OpenAPI contract.

## 0.4.0 — 2026-09-07

- Start at 0.4.0 to match the Python SDK release with full resource coverage.
- Initial Ruby SDK covering all 42 operations in the current FiscalRail OpenAPI contract.
- Handwritten resources with generated response models and operation metadata.
- Precise decimals, date/time decoding, deeply frozen responses and unknown-field preservation.
- Explicit client configuration, persistent HTTP connections, safe retries and invoice idempotency.
- Lazy pagination, PDF metadata/downloads, webhook verification and Spanish tax conveniences.
- Standalone tests, optional Rails integration verification and gem CI.
