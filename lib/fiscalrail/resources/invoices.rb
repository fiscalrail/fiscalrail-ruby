# frozen_string_literal: true

module FiscalRail
  module Resources
    class Invoices < Resource
      include AutoPagination

      def issue(idempotency_key: nil, **params)
        request("issueInvoice", body: params, retry_safe: true, idempotency_key: request_key(idempotency_key))
      end

      def retrieve(invoice_id)
        request("retrieveInvoice", path: { id: invoice_id }, retry_safe: true)
      end

      def amend(invoice_id, reason:, replacement: nil, idempotency_key: nil)
        body = { reason: reason }
        body[:replacement] = replacement unless replacement.nil?
        request("amendInvoice", path: { invoice_id: invoice_id }, body: body,
          retry_safe: true, idempotency_key: request_key(idempotency_key))
      end

      def list(q: nil, customer: nil, issue_date_from: nil, issue_date_to: nil, limit: nil, starting_after: nil, ending_before: nil)
        request("listInvoices", params: { q: q, customer: customer, issue_date_from: issue_date_from, issue_date_to: issue_date_to,
          limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
