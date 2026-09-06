# frozen_string_literal: true

module FiscalRail
  module Resources
    class Accounts < Resource
      def list
        request("listAccounts", retry_safe: true)
      end

      def retrieve(account_id)
        request("retrieveAccount", path: { id: account_id }, retry_safe: true)
      end

      def update(account_id, **params)
        request("updateAccount", path: { id: account_id }, body: params)
      end
    end

    class Balances < Resource
      def retrieve(account_id)
        request("retrieveBalance", path: { account_id: account_id }, retry_safe: true)
      end
    end

    class AccountTaxRegimes < Resource
      def retrieve(account_id)
        request("retrieveAccountTaxRegime", path: { account_id: account_id }, retry_safe: true)
      end
    end
  end
end
