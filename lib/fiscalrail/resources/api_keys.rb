# frozen_string_literal: true

module FiscalRail
  module Resources
    class ApiKeys < Resource
      include AutoPagination

      def create(**params)
        request("createApiKey", body: params)
      end

      def retrieve(api_key_id)
        request("retrieveApiKey", path: { id: api_key_id }, retry_safe: true)
      end

      def delete(api_key_id)
        request("deleteApiKey", path: { id: api_key_id })
      end

      def list(limit: nil, starting_after: nil, ending_before: nil)
        request("listApiKeys", params: { limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
