# frozen_string_literal: true

module FiscalRail
  module TaxRegimes
    module ES
      module VAT
        def self.general = { tax: "vat", rule: "general" }.freeze
        def self.reduced = { tax: "vat", rule: "reduced" }.freeze
        def self.super_reduced = { tax: "vat", rule: "super_reduced" }.freeze
        def self.exempt_intra_eu_goods = { tax: "vat", rule: "exempt_intra_eu_goods" }.freeze
        def self.not_subject_place_of_supply = { tax: "vat", rule: "not_subject_place_of_supply" }.freeze
      end

      module IRPF
        def self.professionals = { tax: "irpf", rule: "professionals" }.freeze
        def self.new_professionals = { tax: "irpf", rule: "new_professionals" }.freeze
      end
    end
  end
end
