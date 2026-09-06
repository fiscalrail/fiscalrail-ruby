# frozen_string_literal: true

module FiscalRail
  module Resources
    class Events < Resource
      include AutoPagination

      def retrieve(event_id)
        request("retrieveEvent", path: { id: event_id }, retry_safe: true)
      end

      def list(types: nil, limit: nil, starting_after: nil, ending_before: nil)
        request("listEvents", params: { types: types&.join(","), limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
