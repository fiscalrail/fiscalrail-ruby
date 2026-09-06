# frozen_string_literal: true

module FiscalRail
  module Resources
    class Customers < Resource
      include AutoPagination

      def create(**params)
        request("createCustomer", body: params)
      end

      def retrieve(customer_id)
        request("retrieveCustomer", path: { id: customer_id }, retry_safe: true)
      end

      def update(customer_id, **params)
        request("updateCustomer", path: { id: customer_id }, body: params)
      end

      def delete(customer_id)
        request("deleteCustomer", path: { id: customer_id })
      end

      def list(q: nil, country: nil, limit: nil, starting_after: nil, ending_before: nil)
        request("listCustomers", params: { q: q, country: country, limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
