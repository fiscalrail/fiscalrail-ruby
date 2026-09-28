# frozen_string_literal: true

module FiscalRail
  module Resources
    class Accounts < Resource
      def retrieve
        request("retrieveAccount", retry_safe: true)
      end

      def update(**params)
        request("updateAccount", body: params)
      end
    end

    class AccountInvoicing < Resource
      def retrieve
        request("retrieveAccountInvoicing", retry_safe: true)
      end

      def update(**params)
        request("updateAccountInvoicing", body: params)
      end
    end

    class Balances < Resource
      def retrieve
        request("retrieveBalance", retry_safe: true)
      end
    end

    class AccountTaxRegimes < Resource
      def retrieve
        request("retrieveAccountTaxRegime", retry_safe: true)
      end
    end
  end
end
