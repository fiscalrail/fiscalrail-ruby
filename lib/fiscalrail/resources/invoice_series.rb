# frozen_string_literal: true

module FiscalRail
  module Resources
    class InvoiceSeries < Resource
      include AutoPagination

      def create(**params)
        request("createInvoiceSeries", body: params)
      end

      def retrieve(series_id)
        request("retrieveInvoiceSeries", path: { id: series_id }, retry_safe: true)
      end

      def update(series_id, **params)
        request("updateInvoiceSeries", path: { id: series_id }, body: params)
      end

      def delete(series_id)
        request("deleteInvoiceSeries", path: { id: series_id })
      end

      def list(limit: nil, starting_after: nil, ending_before: nil)
        request("listInvoiceSeries", params: { limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
