# frozen_string_literal: true

module FiscalRail
  class Client
    attr_reader :accounts, :account_invoicing, :balances, :account_tax_regimes, :api_keys, :customers,
      :event_destinations, :events, :invoice_series, :invoices, :invoice_pdfs,
      :payment_instructions, :tax_ids, :tax_regimes

    def initialize(api_key:, base_url: "https://api.fiscalrail.com/v1", timeout: 30,
      open_timeout: timeout, read_timeout: timeout, write_timeout: timeout, max_retries: 2, adapter: nil)
      raise ArgumentError, "api_key must be a nonempty string" unless api_key.is_a?(String) && !api_key.empty?
      raise ArgumentError, "max_retries must be a nonnegative integer" unless max_retries.is_a?(Integer) && max_retries >= 0
      [open_timeout, read_timeout, write_timeout].each do |value|
        raise ArgumentError, "timeouts must be positive finite numbers" unless value.is_a?(Numeric) && value.finite? && value.positive?
      end
      uri = URI(base_url)
      raise ArgumentError, "base_url must be an HTTP(S) URL without credentials, query or fragment" unless %w[http https].include?(uri.scheme) && uri.host && !uri.userinfo && !uri.query && !uri.fragment

      @owns_adapter = adapter.nil?
      @adapter = adapter || NetHTTPAdapter.new(open_timeout: open_timeout, read_timeout: read_timeout, write_timeout: write_timeout)
      transport = Transport.new(api_key: api_key, base_url: base_url, max_retries: max_retries, adapter: @adapter)
      @accounts = Resources::Accounts.new(transport)
      @account_invoicing = Resources::AccountInvoicing.new(transport)
      @balances = Resources::Balances.new(transport)
      @account_tax_regimes = Resources::AccountTaxRegimes.new(transport)
      @api_keys = Resources::ApiKeys.new(transport)
      @customers = Resources::Customers.new(transport)
      @event_destinations = Resources::EventDestinations.new(transport)
      @events = Resources::Events.new(transport)
      @invoice_series = Resources::InvoiceSeries.new(transport)
      @invoices = Resources::Invoices.new(transport)
      @invoice_pdfs = Resources::InvoicePdfs.new(transport)
      @payment_instructions = Resources::PaymentInstructions.new(transport)
      @tax_ids = Resources::TaxIds.new(transport)
      @tax_regimes = Resources::TaxRegimes.new(transport)
    end

    def self.open(**options)
      client = new(**options)
      return client unless block_given?

      begin
        yield client
      ensure
        client.close
      end
    end

    def close
      @adapter.close if @owns_adapter
      nil
    end

    def inspect
      "#<#{self.class.name}>"
    end
  end
end
