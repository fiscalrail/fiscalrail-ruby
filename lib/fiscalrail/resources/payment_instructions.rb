# frozen_string_literal: true

module FiscalRail
  module Resources
    class PaymentInstructions < Resource
      include AutoPagination

      def create(**params)
        request("createPaymentInstruction", body: params)
      end

      def retrieve(instruction_id)
        request("retrievePaymentInstruction", path: { id: instruction_id }, retry_safe: true)
      end

      def update(instruction_id, **params)
        request("updatePaymentInstruction", path: { id: instruction_id }, body: params)
      end

      def delete(instruction_id)
        request("deletePaymentInstruction", path: { id: instruction_id })
      end

      def list(limit: nil, starting_after: nil, ending_before: nil)
        request("listPaymentInstructions", params: { limit: limit, starting_after: starting_after, ending_before: ending_before }, retry_safe: true)
      end
    end
  end
end
