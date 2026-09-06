# frozen_string_literal: true

module FiscalRail
  module Resources
    class TaxRegimes < Resource
      def list
        request("listTaxRegimes", retry_safe: true)
      end

      def retrieve(regime_id)
        request("retrieveTaxRegime", path: { id: regime_id }, retry_safe: true)
      end
    end

    class TaxIds < Resource
      def retrieve(tax_id)
        request("retrieveTaxId", path: { id: tax_id }, retry_safe: true)
      end
    end
  end
end
