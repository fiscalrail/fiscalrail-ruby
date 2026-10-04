# FiscalRail Ruby SDK

A Ruby client for issuing immutable invoices through FiscalRail. Ruby 3.3 or later; no Rails dependency.

Install with Bundler:

```ruby
gem "fiscalrail", "~> 0.6.0"
```

## Issue an invoice

```ruby
require "fiscalrail"

client = FiscalRail::Client.new(api_key: ENV.fetch("FISCALRAIL_API_KEY"))

invoice = client.invoices.issue(
  customer: "cus_...",
  lines: [
    {
      description: "Consulting services",
      unit_price: BigDecimal("2500.00"),
      taxes: [
        FiscalRail::TaxRegimes::ES::VAT.general,
        FiscalRail::TaxRegimes::ES::IRPF.professionals
      ]
    }
  ]
)

client.invoice_pdfs
  .render_content(invoice.id, locale: "en")
  .write_to_file("#{invoice.code}.pdf")

client.close
```

The API key is explicit: the SDK never reads process configuration. The key selects the Test or Live account; there is no separate environment switch.

Requests use ordinary keyword arguments and nested hashes. Both symbol and string keys work in nested hashes. Use `BigDecimal` or strings for precise monetary inputs. `Date` and `Time` are serialized as ISO 8601 strings. Omitted body fields stay omitted; explicit `nil`, `false` and empty arrays are preserved. Business validation stays on the API.

## Responses

Responses are generated, read-only objects under `FiscalRail::Models`:

```ruby
invoice.id                  # String
invoice.issue_date          # Date
invoice.created_at          # Time
invoice.totals.payable      # BigDecimal
invoice.request_id          # Request-Id header
invoice.idempotency_key      # Key used to issue this invoice
invoice.idempotent_replayed  # Original request ID, or nil
invoice.to_h                # Nested hashes with string keys and Ruby values
```

Unknown response fields are retained in `extra_fields`, accessible through `response["field"]` and, when the name does not collide with an existing method, `response.field`. Nested arrays, hashes and values are frozen. `to_h` creates fresh containers. Unknown enum strings are accepted for forward compatibility. Invalid required fields or structural types raise `FiscalRail::ResponseParseError` with the field path and request ID.

## Idempotency and retries

Invoice `issue` and `amend` calls generate an idempotency key when none is supplied. Every retry within that call uses the same key and serialized body. For durable jobs, create and persist a key with the job before its first attempt:

```ruby
invoice = client.invoices.issue(
  idempotency_key: saved_job_key,
  lines: [{ description: "Consulting", unit_price: "100.00",
            taxes: [FiscalRail::TaxRegimes::ES::VAT.general] }]
)

amendment = client.invoices.amend(
  invoice.id,
  reason: "issued_by_mistake",
  idempotency_key: saved_amendment_key
)
```

A new SDK call without a supplied key generates a new key. It does not deduplicate retries made by your job framework. Never reuse a key for a different operation or payload.

By default, the SDK makes at most two retries for connection failures, timeouts, HTTP 408/429 and 5xx responses, only for operations designated safe: reads, idempotency-protected issuance/amendments, PDF rendering, and destination enable/disable. Ordinary create/update/delete calls are not automatically retried. The SDK honors numeric and HTTP-date `Retry-After` values, bounded to 30 seconds; otherwise it uses exponential backoff. Set `max_retries: 0` to disable retries. Redirects are not followed. Response decoding failures are not retried.

## Resources

| Resource | Methods |
| --- | --- |
| `accounts` | `retrieve`, `update` |
| `account_invoicing` | `retrieve`, `update` |
| `balances` | `retrieve` |
| `account_tax_regimes` | `retrieve` |
| `api_keys` | `list`, `create`, `retrieve`, `delete` |
| `customers` | `list`, `create`, `retrieve`, `update`, `delete` |
| `event_destinations` | `list`, `create`, `retrieve`, `update`, `delete`, `enable`, `disable` |
| `events` | `list`, `retrieve` |
| `invoice_series` | `list`, `create`, `retrieve`, `update`, `delete` |
| `invoices` | `list`, `issue`, `retrieve`, `amend` |
| `invoice_pdfs` | `retrieve`, `render`, `retrieve_content`, `render_content` |
| `payment_instructions` | `list`, `create`, `retrieve`, `update`, `delete` |
| `tax_ids` | `retrieve` |
| `tax_regimes` | `list`, `retrieve` |

`invoice_pdfs.retrieve` and `render` return metadata. Their `_content` variants return `FiscalRail::BinaryContent`, with `content`, `content_type`, `request_id` and `write_to_file(path)`. PDF content is buffered in memory. `locale:` on rendering becomes `Accept-Language`.

## Pagination

`list` retrieves one page, exposing `data`, `has_more`, `request_id` and Enumerable methods over that page. Paginated resources also expose `auto_paging_each`, which fetches subsequent pages lazily:

```ruby
page = client.customers.list(country: "ES", limit: 25)
page.each { |customer| puts customer.name }

client.invoices.auto_paging_each(customer: "cus_...", page_size: 100) do |invoice|
  puts invoice.code
end

first_ten = client.customers.auto_paging_each.lazy.take(10).to_a
```

Automatic iteration proceeds forward and preserves filters. Use `list(starting_after: ...)` or `list(ending_before: ...)` to manage cursors yourself. Account, account invoicing, balance, and account tax regime resources return single objects.

## Payment instructions

```ruby
instruction = client.payment_instructions.create(
  label: "Main EUR account",
  type: "bank_transfer",
  bank_transfer: {
    beneficiary: "Example supplier",
    iban: "ES9121000418450200051332",
    bic: "CAIXESBBXXX"
  }
)

client.account_invoicing.update(default_payment_instructions: [instruction.id])

invoice = client.invoices.issue(
  payment_terms: { due_date: Date.new(2026, 9, 30) },
  lines: [{ description: "Consulting", unit_price: "100.00",
            taxes: [FiscalRail::TaxRegimes::ES::VAT.general] }]
)
```

Use `payment_terms: { options: [instruction.id] }` to override account defaults, or `options: []` to omit payment instructions.

## Webhooks

Verify the exact raw body before parsing or processing it. For example, in a Rails controller:

```ruby
event = FiscalRail::Webhooks.construct_event(
  request.raw_post,
  request.headers["FiscalRail-Signature"],
  signing_secret
)
```

The verifier uses constant-time HMAC comparison and a five-minute timestamp tolerance in both directions. It accepts multiple `v1` signatures, returns a hash with string keys, and raises `FiscalRail::WebhookSignatureError` on failure. `verify_signature` verifies without parsing and returns the timestamp. Tests can inject `now:`; `tolerance: nil` explicitly disables the age check.

## Errors

```ruby
begin
  client.invoices.issue(idempotency_key: saved_job_key, **params)
rescue FiscalRail::InvalidInvoiceError => error
  warn error.message
  error.details.each { |detail| warn "#{detail['field']}: #{detail['message']}" }
rescue FiscalRail::APIConnectionError => error
  # Includes APITimeoutError. Retain the key if the outcome is uncertain.
  warn "Request failed; idempotency key: #{error.idempotency_key}"
rescue FiscalRail::APIError => error
  warn "#{error.code}: HTTP #{error.status_code}, request #{error.request_id}"
end
```

All SDK errors inherit from `FiscalRail::Error`. API errors retain `code`, `status_code`, `request_id`, `details`, `body` and `idempotency_key`. Known error codes have subclasses; unknown codes remain `APIError`. Parse errors also retain the request ID and idempotency key.

## Connections and configuration

```ruby
FiscalRail::Client.open(
  api_key: secret,
  open_timeout: 5,
  read_timeout: 30,
  write_timeout: 30,
  max_retries: 2
) do |client|
  client.accounts.retrieve
end
```

`timeout:` sets all three timeout defaults. The default `Net::HTTP` adapter reuses one connection and serializes concurrent requests with a mutex. Use separate clients for concurrent HTTP throughput. A new connection is opened after a process fork. The SDK disables the HTTP library's own retries so requests are not retried twice. `close` releases the connection; the next request can reconnect.

For custom proxy, TLS or observability behavior, inject `adapter:`. It must implement:

```ruby
def call(method:, uri:, headers:, body:)
  # Return FiscalRail::NetHTTPAdapter::Response.new(
  #   status: 200, headers: { "content-type" => "application/json" }, body: "..."
  # )
end
```

`uri` is a `URI` object; `body` is already serialized JSON or nil. Use standard socket/timeout exceptions for transport failures, and disable adapter-level retries. Injected adapters remain caller-owned and are never closed by the SDK. The SDK does not inspect environment variables; the default HTTP library can use its standard proxy environment configuration.

## Development

```sh
bundle install
bundle exec rake test
bundle exec rake generate
bundle exec rake check_generated
bundle exec rake build
```

Generation defaults to the current [published OpenAPI document](https://docs.fiscalrail.com/openapi.yml). To work against a local contract:

```sh
bundle exec rake generate SCHEMA=../path/to/api.oas.yml
bundle exec rake check_generated SCHEMA=../path/to/api.oas.yml
```

The generator emits Ruby response readers and schema/operation metadata under `lib/fiscalrail/generated`. Resource methods, transport, decoding, errors, pagination, webhook verification and tax conveniences are handwritten. Do not edit generated files. There is no RBS support, vendored schema or pinned schema revision. Regular tests are offline; `check_generated` needs the published schema unless a local path is supplied, and intentionally fails when that contract changes.

The fixtures contain public OpenAPI examples plus synthetic webhook, event and amendment payloads. HTTP tests run against a loopback TCP server. An optional test exercises the actual Rails application, test database and PDF renderer:

```sh
# Run in the FiscalRail Rails checkout with its local dependencies running.
FISCALRAIL_APP_ROOT="$PWD" bundle exec ruby /absolute/path/to/ruby/test/rails_integration.rb
```

It creates a Test account inside a test transaction and checks customer creation, null clearing, payment defaults, issuance/replay, pagination, PDF download and amendment. Set `FISCALRAIL_SDK_PDF=/tmp/sdk-invoice.pdf` to retain the rendered PDF for inspection. This test is optional and is not part of the standalone gem CI.

See [RELEASING.md](RELEASING.md) for the release checklist.


## Spanish AEAT submission

Use a Live Spanish account key. Upload a `.p12`/`.pfx` file (up to 128 KiB),
including its private key, using native multipart upload. Omit the password for
an unprotected bundle. The certificate's issuer NIF must match the account.

```ruby
File.open("issuer.p12", "rb") do |certificate|
  setup = client.account_tax_regimes.es.upload_certificate(
    certificate_file: certificate,
    certificate_password: ENV.fetch("CERTIFICATE_PASSWORD")
  )
end
setup = client.account_tax_regimes.retrieve
# Inspect setup.es.pending_submission.status / error_code and setup.es.submission.ready.
client.account_tax_regimes.es.verify_submission # retry the pending or active check
client.account_tax_regimes.es.cancel_submission_change
client.account_tax_regimes.es.verify_representation # after granting AEAT authority
```

Each mutation above is a separate operation; choose the one needed. Upload and
verification return the account setup while AEAT checks run asynchronously.
Poll the generic account tax-regime resource for pending verification status,
error code and the active setup's readiness. A working setup remains active until
a replacement verifies; failed checks retain the pending certificate for retry.
Cancelling removes only the pending change. Uploads are not automatically retried.
The ES mutations use `/account/tax-regime/es/...`; reads use `/account/tax-regime`.
