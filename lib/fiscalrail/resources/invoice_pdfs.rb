# frozen_string_literal: true

module FiscalRail
  module Resources
    class InvoicePdfs < Resource
      def retrieve(invoice_id)
        request("retrieveInvoicePdf", path: { invoice_id: invoice_id }, retry_safe: true)
      end

      def retrieve_content(invoice_id)
        request("retrieveInvoicePdf", path: { invoice_id: invoice_id }, retry_safe: true, binary: true)
      end

      def render(invoice_id, locale: nil)
        request("renderInvoicePdf", path: { invoice_id: invoice_id }, headers: locale ? { "Accept-Language" => locale } : {}, retry_safe: true)
      end

      def render_content(invoice_id, locale: nil)
        request("renderInvoicePdf", path: { invoice_id: invoice_id }, headers: locale ? { "Accept-Language" => locale } : {}, retry_safe: true, binary: true)
      end
    end
  end
end
