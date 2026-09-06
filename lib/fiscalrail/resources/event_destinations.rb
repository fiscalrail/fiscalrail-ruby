# frozen_string_literal: true

module FiscalRail
  module Resources
    class EventDestinations < Resource
      include AutoPagination

      def create(**params)
        request("createEventDestination", body: params)
      end

      def retrieve(destination_id)
        request("retrieveEventDestination", path: { id: destination_id }, retry_safe: true)
      end

      def update(destination_id, **params)
        request("updateEventDestination", path: { id: destination_id }, body: params)
      end

      def delete(destination_id)
        request("deleteEventDestination", path: { id: destination_id })
      end

      def enable(destination_id)
        request("enableEventDestination", path: { id: destination_id }, retry_safe: true)
      end

      def disable(destination_id)
        request("disableEventDestination", path: { id: destination_id }, retry_safe: true)
      end

      def list(limit: nil, starting_after: nil, ending_before: nil)
        request("listEventDestinations", params: { limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
