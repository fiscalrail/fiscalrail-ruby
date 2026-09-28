# frozen_string_literal: true
# Generated from FiscalRail's OpenAPI contract. Do not edit by hand.

require "json"

module FiscalRail
  module Generated
    CONTRACT = JSON.parse(<<~'JSON')
{
  "version": "1.0.0",
  "schemas": {
    "Account": {
      "model": "Account",
      "properties": {
        "address": {
          "$ref": "#/components/schemas/Address"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "id": {
          "$ref": "#/components/schemas/AccountId"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "name": {
          "type": "string"
        },
        "object": {
          "const": "account",
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        },
        "tax_id": {
          "$ref": "#/components/schemas/TaxId"
        },
        "tax_regime": {
          "type": "string"
        },
        "timezone": {
          "type": "string"
        },
        "updated_at": {
          "format": "date-time",
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "name",
        "tax_id",
        "email",
        "phone",
        "address",
        "tax_regime",
        "timezone",
        "created_at",
        "updated_at"
      ],
      "type": "object"
    },
    "AccountDefaultSeries": {
      "model": "AccountDefaultSeries",
      "properties": {
        "amendment": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceSeriesId"
            },
            {
              "type": "null"
            }
          ]
        },
        "credit_note": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceSeriesId"
            },
            {
              "type": "null"
            }
          ]
        },
        "invoice": {
          "$ref": "#/components/schemas/InvoiceSeriesId"
        }
      },
      "required": [
        "invoice",
        "credit_note",
        "amendment"
      ],
      "type": "object"
    },
    "AccountId": {
      "type": "string"
    },
    "AccountInvoiceNumberingScope": {
      "type": "string"
    },
    "AccountInvoicing": {
      "model": "AccountInvoicing",
      "properties": {
        "default_payment_instructions": {
          "items": {
            "$ref": "#/components/schemas/PaymentInstructionId"
          },
          "type": "array"
        },
        "default_series": {
          "$ref": "#/components/schemas/AccountDefaultSeries"
        },
        "footer": {
          "type": [
            "string",
            "null"
          ]
        },
        "locale": {
          "type": "string"
        },
        "numbering_scope": {
          "$ref": "#/components/schemas/AccountInvoiceNumberingScope"
        },
        "object": {
          "const": "account_invoicing",
          "type": "string"
        }
      },
      "required": [
        "object",
        "locale",
        "footer",
        "numbering_scope",
        "default_series",
        "default_payment_instructions"
      ],
      "type": "object"
    },
    "AccountInvoicingUpdate": {
      "model": "AccountInvoicingUpdate",
      "properties": {
        "default_payment_instructions": {
          "items": {
            "$ref": "#/components/schemas/PaymentInstructionId"
          },
          "type": "array"
        },
        "default_series": {
          "$ref": "#/components/schemas/AccountDefaultSeries"
        },
        "footer": {
          "type": [
            "string",
            "null"
          ]
        },
        "locale": {
          "type": "string"
        },
        "numbering_scope": {
          "$ref": "#/components/schemas/AccountInvoiceNumberingScope"
        }
      },
      "type": "object"
    },
    "AccountNotConfiguredErrorResponse": {
      "model": "AccountNotConfiguredErrorResponse",
      "properties": {
        "error": {
          "model": "AccountNotConfiguredError",
          "properties": {
            "code": {
              "const": "account_not_configured",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "AccountTaxRegime": {
      "discriminator": {
        "propertyName": "key",
        "mapping": {
          "global": "#/components/schemas/GlobalAccountTaxRegime",
          "es": "#/components/schemas/SpanishAccountTaxRegime"
        }
      },
      "oneOf": [
        {
          "$ref": "#/components/schemas/GlobalAccountTaxRegime"
        },
        {
          "$ref": "#/components/schemas/SpanishAccountTaxRegime"
        }
      ]
    },
    "AccountUpdate": {
      "model": "AccountUpdate",
      "properties": {
        "address": {
          "$ref": "#/components/schemas/AddressUpdate"
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "name": {
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "type": "object"
    },
    "Address": {
      "model": "Address",
      "properties": {
        "city": {
          "type": "string"
        },
        "country": {
          "type": "string"
        },
        "line_1": {
          "type": "string"
        },
        "line_2": {
          "type": [
            "string",
            "null"
          ]
        },
        "postal_code": {
          "type": "string"
        },
        "state": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "line_1",
        "line_2",
        "city",
        "postal_code",
        "state",
        "country"
      ],
      "type": "object"
    },
    "AddressCreate": {
      "model": "AddressCreate",
      "properties": {
        "city": {
          "type": "string"
        },
        "country": {
          "type": "string"
        },
        "line_1": {
          "type": "string"
        },
        "line_2": {
          "type": [
            "string",
            "null"
          ]
        },
        "postal_code": {
          "type": "string"
        },
        "state": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "line_1",
        "city",
        "postal_code",
        "country"
      ],
      "type": "object"
    },
    "AddressUpdate": {
      "model": "AddressUpdate",
      "properties": {
        "city": {
          "type": [
            "string",
            "null"
          ]
        },
        "country": {
          "type": [
            "string",
            "null"
          ]
        },
        "line_1": {
          "type": [
            "string",
            "null"
          ]
        },
        "line_2": {
          "type": [
            "string",
            "null"
          ]
        },
        "postal_code": {
          "type": [
            "string",
            "null"
          ]
        },
        "state": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "type": "object"
    },
    "ApiKey": {
      "model": "ApiKey",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "id": {
          "$ref": "#/components/schemas/ApiKeyId"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "name": {
          "type": "string"
        },
        "object": {
          "const": "api_key",
          "type": "string"
        },
        "secret": {
          "type": [
            "string",
            "null"
          ]
        },
        "suffix": {
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "name",
        "suffix",
        "secret",
        "created_at"
      ],
      "type": "object"
    },
    "ApiKeyCreate": {
      "model": "ApiKeyCreate",
      "properties": {
        "name": {
          "type": "string"
        }
      },
      "required": [
        "name"
      ],
      "type": "object"
    },
    "ApiKeyId": {
      "type": "string"
    },
    "ApiKeyList": {
      "model": "ApiKeyList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/ApiKey"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "AuthenticationErrorResponse": {
      "model": "AuthenticationErrorResponse",
      "properties": {
        "error": {
          "model": "AuthenticationError",
          "properties": {
            "code": {
              "const": "authentication_required",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "Balance": {
      "model": "Balance",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "amount": {
          "$ref": "#/components/schemas/Money"
        },
        "currency": {
          "type": "string"
        },
        "id": {
          "$ref": "#/components/schemas/BalanceId"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "balance",
          "type": "string"
        },
        "updated_at": {
          "format": "date-time",
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "amount",
        "currency",
        "updated_at"
      ],
      "type": "object"
    },
    "BalanceExhaustedErrorResponse": {
      "model": "BalanceExhaustedErrorResponse",
      "properties": {
        "error": {
          "model": "BalanceExhaustedError",
          "properties": {
            "code": {
              "const": "balance_exhausted",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "BalanceId": {
      "type": "string"
    },
    "BalanceTransaction": {
      "model": "BalanceTransaction",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "amount_cents": {
          "type": "integer"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "currency": {
          "type": "string"
        },
        "id": {
          "type": "string"
        },
        "kind": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "balance_transaction",
          "type": "string"
        },
        "source_event": {
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "kind",
        "amount_cents",
        "currency",
        "source_event",
        "created_at"
      ],
      "type": "object"
    },
    "Customer": {
      "model": "Customer",
      "properties": {
        "address": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/Address"
            },
            {
              "type": "null"
            }
          ]
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "id": {
          "$ref": "#/components/schemas/CustomerId"
        },
        "invoice_prefix": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "name": {
          "type": "string"
        },
        "object": {
          "const": "customer",
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        },
        "tax_id": {
          "$ref": "#/components/schemas/TaxId"
        },
        "updated_at": {
          "format": "date-time",
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "name",
        "invoice_prefix",
        "tax_id",
        "email",
        "phone",
        "address",
        "created_at",
        "updated_at"
      ],
      "type": "object"
    },
    "CustomerCreate": {
      "model": "CustomerCreate",
      "properties": {
        "address": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/AddressCreate"
            },
            {
              "type": "null"
            }
          ]
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "invoice_prefix": {
          "type": "string"
        },
        "name": {
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        },
        "tax_id": {
          "$ref": "#/components/schemas/TaxIdInput"
        }
      },
      "required": [
        "name",
        "tax_id"
      ],
      "type": "object"
    },
    "CustomerId": {
      "type": "string"
    },
    "CustomerList": {
      "model": "CustomerList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/Customer"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "CustomerNotFoundErrorResponse": {
      "model": "CustomerNotFoundErrorResponse",
      "properties": {
        "error": {
          "model": "CustomerNotFoundError",
          "properties": {
            "code": {
              "const": "customer_not_found",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "CustomerUpdate": {
      "model": "CustomerUpdate",
      "properties": {
        "address": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/AddressUpdate"
            },
            {
              "type": "null"
            }
          ]
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "invoice_prefix": {
          "type": "string"
        },
        "name": {
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        },
        "tax_id": {
          "$ref": "#/components/schemas/TaxIdInput"
        }
      },
      "type": "object"
    },
    "Decimal": {
      "format": "decimal",
      "type": "string"
    },
    "DecimalInput": {
      "oneOf": [
        {
          "type": "number"
        },
        {
          "type": "string"
        }
      ]
    },
    "Event": {
      "model": "Event",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "actor": {
          "$ref": "#/components/schemas/EventActor"
        },
        "data": {
          "model": "EventData",
          "properties": {
            "object": {
              "additionalProperties": true,
              "type": "object"
            },
            "previous_attributes": {
              "additionalProperties": true,
              "type": "object"
            }
          },
          "required": [
            "object"
          ],
          "type": "object"
        },
        "id": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "event",
          "type": "string"
        },
        "occurred_at": {
          "format": "date-time",
          "type": "string"
        },
        "related_object": {
          "$ref": "#/components/schemas/RelatedObject"
        },
        "type": {
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "type",
        "occurred_at",
        "actor",
        "related_object",
        "data"
      ],
      "type": "object"
    },
    "EventActor": {
      "model": "EventActor",
      "properties": {
        "id": {
          "type": [
            "string",
            "null"
          ]
        },
        "request_id": {
          "type": [
            "string",
            "null"
          ]
        },
        "type": {
          "type": "string"
        }
      },
      "required": [
        "type",
        "id",
        "request_id"
      ],
      "type": "object"
    },
    "EventDestination": {
      "model": "EventDestination",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "disabled_reason": {
          "type": [
            "string",
            "null"
          ]
        },
        "enabled_events": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "id": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "name": {
          "type": "string"
        },
        "object": {
          "const": "event_destination",
          "type": "string"
        },
        "status": {
          "type": "string"
        },
        "type": {
          "const": "webhook",
          "type": "string"
        },
        "updated_at": {
          "format": "date-time",
          "type": "string"
        },
        "webhook": {
          "model": "EventDestinationWebhook",
          "properties": {
            "signing_secret": {
              "type": [
                "string",
                "null"
              ]
            },
            "url": {
              "format": "uri",
              "type": "string"
            }
          },
          "required": [
            "url",
            "signing_secret"
          ],
          "type": "object"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "name",
        "type",
        "status",
        "enabled_events",
        "webhook",
        "disabled_reason",
        "created_at",
        "updated_at"
      ],
      "type": "object"
    },
    "EventDestinationCreate": {
      "model": "EventDestinationCreate",
      "properties": {
        "enabled_events": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "name": {
          "type": "string"
        },
        "url": {
          "format": "uri",
          "type": "string"
        }
      },
      "required": [
        "name",
        "url",
        "enabled_events"
      ],
      "type": "object"
    },
    "EventDestinationList": {
      "model": "EventDestinationList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/EventDestination"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "EventDestinationUpdate": {
      "model": "EventDestinationUpdate",
      "properties": {
        "enabled_events": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "name": {
          "type": "string"
        },
        "url": {
          "format": "uri",
          "type": "string"
        }
      },
      "type": "object"
    },
    "EventList": {
      "model": "EventList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/Event"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "GlobalAccountTaxRegime": {
      "model": "GlobalAccountTaxRegime",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "key": {
          "const": "global",
          "type": "string"
        },
        "object": {
          "const": "account_tax_regime",
          "type": "string"
        }
      },
      "required": [
        "object",
        "account",
        "key"
      ],
      "type": "object"
    },
    "GlobalInvoiceTaxRegime": {
      "model": "GlobalInvoiceTaxRegime",
      "properties": {
        "key": {
          "const": "global",
          "type": "string"
        }
      },
      "required": [
        "key"
      ],
      "type": "object"
    },
    "IdempotencyConflictErrorResponse": {
      "model": "IdempotencyConflictErrorResponse",
      "properties": {
        "error": {
          "model": "IdempotencyConflictError",
          "properties": {
            "code": {
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "InvalidCustomerErrorResponse": {
      "model": "InvalidCustomerErrorResponse",
      "properties": {
        "error": {
          "model": "InvalidCustomerError",
          "properties": {
            "code": {
              "const": "invalid_customer",
              "type": "string"
            },
            "details": {
              "items": {
                "$ref": "#/components/schemas/ValidationDetail"
              },
              "type": "array"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message",
            "details"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "InvalidInvoiceErrorResponse": {
      "model": "InvalidInvoiceErrorResponse",
      "properties": {
        "error": {
          "model": "InvalidInvoiceError",
          "properties": {
            "code": {
              "const": "invalid_invoice",
              "type": "string"
            },
            "details": {
              "items": {
                "$ref": "#/components/schemas/ValidationDetail"
              },
              "type": "array"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message",
            "details"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "InvalidRequestErrorResponse": {
      "model": "InvalidRequestErrorResponse",
      "properties": {
        "error": {
          "model": "InvalidRequestError",
          "properties": {
            "code": {
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "InvalidResourceErrorResponse": {
      "model": "InvalidResourceErrorResponse",
      "properties": {
        "error": {
          "model": "InvalidResourceError",
          "properties": {
            "code": {
              "type": "string"
            },
            "details": {
              "items": {
                "model": "BasicValidationDetail",
                "properties": {
                  "field": {
                    "type": "string"
                  },
                  "message": {
                    "type": "string"
                  }
                },
                "required": [
                  "field",
                  "message"
                ],
                "type": "object"
              },
              "type": "array"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message",
            "details"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "Invoice": {
      "model": "Invoice",
      "properties": {
        "account": {
          "type": "string"
        },
        "amendments": {
          "items": {
            "$ref": "#/components/schemas/InvoiceAmendment"
          },
          "type": "array"
        },
        "code": {
          "type": "string"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "currency": {
          "const": "EUR",
          "type": "string"
        },
        "customer": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceParty"
            },
            {
              "type": "null"
            }
          ]
        },
        "id": {
          "type": "string"
        },
        "issue_date": {
          "format": "date",
          "type": "string"
        },
        "kind": {
          "type": "string"
        },
        "lines": {
          "items": {
            "$ref": "#/components/schemas/InvoiceLine"
          },
          "type": "array"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "invoice",
          "type": "string"
        },
        "payment_terms": {
          "$ref": "#/components/schemas/InvoicePaymentTerms"
        },
        "preceding_invoice": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceReference"
            },
            {
              "type": "null"
            }
          ]
        },
        "series": {
          "type": "string"
        },
        "supplier": {
          "$ref": "#/components/schemas/InvoiceParty"
        },
        "supply_period": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceSupplyPeriod"
            },
            {
              "type": "null"
            }
          ]
        },
        "tax_regime": {
          "$ref": "#/components/schemas/InvoiceTaxRegime"
        },
        "tax_totals": {
          "items": {
            "$ref": "#/components/schemas/InvoiceTaxTotal"
          },
          "type": "array"
        },
        "totals": {
          "$ref": "#/components/schemas/InvoiceTotals"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "kind",
        "code",
        "series",
        "issue_date",
        "supply_period",
        "preceding_invoice",
        "currency",
        "supplier",
        "customer",
        "payment_terms",
        "lines",
        "tax_totals",
        "totals",
        "created_at",
        "tax_regime",
        "amendments"
      ],
      "type": "object"
    },
    "InvoiceAmendment": {
      "model": "InvoiceAmendment",
      "properties": {
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "credit_note": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceReference"
            },
            {
              "type": "null"
            }
          ]
        },
        "id": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "invoice_amendment",
          "type": "string"
        },
        "original": {
          "$ref": "#/components/schemas/InvoiceReference"
        },
        "reason": {
          "$ref": "#/components/schemas/InvoiceAmendmentReason"
        },
        "replacement": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/InvoiceReference"
            },
            {
              "type": "null"
            }
          ]
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "reason",
        "original",
        "credit_note",
        "replacement",
        "created_at"
      ],
      "type": "object"
    },
    "InvoiceAmendmentCreate": {
      "model": "InvoiceAmendmentCreate",
      "properties": {
        "reason": {
          "$ref": "#/components/schemas/InvoiceAmendmentReason"
        },
        "replacement": {
          "$ref": "#/components/schemas/InvoiceCreate"
        }
      },
      "required": [
        "reason"
      ],
      "type": "object"
    },
    "InvoiceAmendmentReason": {
      "type": "string"
    },
    "InvoiceCreate": {
      "model": "InvoiceCreate",
      "properties": {
        "customer": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/CustomerId"
            },
            {
              "type": "null"
            }
          ]
        },
        "issue_date": {
          "format": "date",
          "type": "string"
        },
        "lines": {
          "items": {
            "$ref": "#/components/schemas/InvoiceLineCreate"
          },
          "type": "array"
        },
        "payment_terms": {
          "$ref": "#/components/schemas/InvoicePaymentTermsCreate"
        },
        "series": {
          "type": "string"
        },
        "supply_period": {
          "$ref": "#/components/schemas/InvoiceSupplyPeriodCreate"
        }
      },
      "required": [
        "lines"
      ],
      "type": "object"
    },
    "InvoiceLine": {
      "model": "InvoiceLine",
      "properties": {
        "description": {
          "type": "string"
        },
        "index": {
          "type": "integer"
        },
        "quantity": {
          "$ref": "#/components/schemas/Decimal"
        },
        "subtotal": {
          "$ref": "#/components/schemas/Money"
        },
        "taxes": {
          "items": {
            "$ref": "#/components/schemas/InvoiceTax"
          },
          "type": "array"
        },
        "unit_price": {
          "$ref": "#/components/schemas/Money"
        }
      },
      "required": [
        "index",
        "description",
        "quantity",
        "unit_price",
        "subtotal",
        "taxes"
      ],
      "type": "object"
    },
    "InvoiceLineCreate": {
      "model": "InvoiceLineCreate",
      "properties": {
        "description": {
          "type": "string"
        },
        "quantity": {
          "$ref": "#/components/schemas/DecimalInput"
        },
        "taxes": {
          "items": {
            "$ref": "#/components/schemas/TaxReference"
          },
          "type": "array"
        },
        "unit_price": {
          "$ref": "#/components/schemas/DecimalInput"
        }
      },
      "required": [
        "description",
        "unit_price",
        "taxes"
      ],
      "type": "object"
    },
    "InvoiceList": {
      "model": "InvoiceList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/Invoice"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "InvoiceParty": {
      "model": "InvoiceParty",
      "properties": {
        "address": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/Address"
            },
            {
              "type": "null"
            }
          ]
        },
        "email": {
          "type": [
            "string",
            "null"
          ]
        },
        "name": {
          "type": "string"
        },
        "phone": {
          "type": [
            "string",
            "null"
          ]
        },
        "source": {
          "$ref": "#/components/schemas/InvoicePartySource"
        },
        "tax_id": {
          "$ref": "#/components/schemas/TaxIdSnapshot"
        }
      },
      "required": [
        "source",
        "name",
        "tax_id",
        "email",
        "phone",
        "address"
      ],
      "type": "object"
    },
    "InvoicePartySource": {
      "model": "InvoicePartySource",
      "properties": {
        "id": {
          "type": "string"
        },
        "type": {
          "type": "string"
        }
      },
      "required": [
        "type",
        "id"
      ],
      "type": "object"
    },
    "InvoicePaymentOption": {
      "model": "InvoicePaymentOption",
      "properties": {
        "bank_transfer": {
          "$ref": "#/components/schemas/PaymentInstructionBankTransfer"
        },
        "payment_instruction": {
          "$ref": "#/components/schemas/PaymentInstructionId"
        },
        "reference": {
          "type": "string"
        },
        "type": {
          "const": "bank_transfer",
          "type": "string"
        }
      },
      "required": [
        "payment_instruction",
        "type",
        "reference",
        "bank_transfer"
      ],
      "type": "object"
    },
    "InvoicePaymentTerms": {
      "model": "InvoicePaymentTerms",
      "properties": {
        "due_date": {
          "format": "date",
          "type": [
            "string",
            "null"
          ]
        },
        "options": {
          "items": {
            "$ref": "#/components/schemas/InvoicePaymentOption"
          },
          "type": "array"
        }
      },
      "required": [
        "due_date",
        "options"
      ],
      "type": "object"
    },
    "InvoicePaymentTermsCreate": {
      "model": "InvoicePaymentTermsCreate",
      "properties": {
        "due_date": {
          "format": "date",
          "type": [
            "string",
            "null"
          ]
        },
        "options": {
          "items": {
            "$ref": "#/components/schemas/PaymentInstructionId"
          },
          "type": "array"
        }
      },
      "type": "object"
    },
    "InvoicePdf": {
      "model": "InvoicePdf",
      "properties": {
        "id": {
          "type": "string"
        },
        "invoice": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "locale": {
          "type": "string"
        },
        "object": {
          "const": "invoice_pdf",
          "type": "string"
        },
        "rendered_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        },
        "status": {
          "type": "string"
        },
        "url": {
          "type": [
            "string",
            "null"
          ]
        },
        "url_expires_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "invoice",
        "status",
        "locale",
        "rendered_at",
        "url",
        "url_expires_at"
      ],
      "type": "object"
    },
    "InvoiceReference": {
      "model": "InvoiceReference",
      "properties": {
        "code": {
          "type": "string"
        },
        "id": {
          "type": [
            "string",
            "null"
          ]
        },
        "issue_date": {
          "format": "date",
          "type": "string"
        }
      },
      "required": [
        "id",
        "code",
        "issue_date"
      ],
      "type": "object"
    },
    "InvoiceSeries": {
      "model": "InvoiceSeries",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "default_for": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "id": {
          "$ref": "#/components/schemas/InvoiceSeriesId"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "invoice_series",
          "type": "string"
        },
        "prefix": {
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "prefix",
        "default_for",
        "created_at"
      ],
      "type": "object"
    },
    "InvoiceSeriesCreate": {
      "model": "InvoiceSeriesCreate",
      "properties": {
        "default_for": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "prefix": {
          "type": "string"
        }
      },
      "required": [
        "prefix"
      ],
      "type": "object"
    },
    "InvoiceSeriesId": {
      "type": "string"
    },
    "InvoiceSeriesList": {
      "model": "InvoiceSeriesList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/InvoiceSeries"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "InvoiceSeriesUpdate": {
      "model": "InvoiceSeriesUpdate",
      "properties": {
        "default_for": {
          "items": {
            "type": "string"
          },
          "type": "array"
        },
        "prefix": {
          "type": "string"
        }
      },
      "type": "object"
    },
    "InvoiceSupplyPeriod": {
      "model": "InvoiceSupplyPeriod",
      "properties": {
        "end_date": {
          "format": "date",
          "type": "string"
        },
        "start_date": {
          "format": "date",
          "type": "string"
        }
      },
      "required": [
        "start_date",
        "end_date"
      ],
      "type": "object"
    },
    "InvoiceSupplyPeriodCreate": {
      "model": "InvoiceSupplyPeriodCreate",
      "properties": {
        "end_date": {
          "format": "date",
          "type": "string"
        },
        "start_date": {
          "format": "date",
          "type": "string"
        }
      },
      "required": [
        "start_date",
        "end_date"
      ],
      "type": "object"
    },
    "InvoiceTax": {
      "model": "InvoiceTax",
      "properties": {
        "description": {
          "type": "string"
        },
        "effect": {
          "type": "string"
        },
        "rate": {
          "type": [
            "string",
            "null"
          ]
        },
        "rule": {
          "type": "string"
        },
        "tax": {
          "type": "string"
        },
        "taxable_base": {
          "$ref": "#/components/schemas/Money"
        },
        "treatment": {
          "type": "string"
        }
      },
      "required": [
        "tax",
        "rule",
        "effect",
        "treatment",
        "description",
        "rate",
        "taxable_base"
      ],
      "type": "object"
    },
    "InvoiceTaxRegime": {
      "discriminator": {
        "propertyName": "key",
        "mapping": {
          "global": "#/components/schemas/GlobalInvoiceTaxRegime",
          "es": "#/components/schemas/SpanishInvoiceTaxRegime"
        }
      },
      "oneOf": [
        {
          "$ref": "#/components/schemas/GlobalInvoiceTaxRegime"
        },
        {
          "$ref": "#/components/schemas/SpanishInvoiceTaxRegime"
        }
      ]
    },
    "InvoiceTaxTotal": {
      "model": "InvoiceTaxTotal",
      "properties": {
        "amount": {
          "$ref": "#/components/schemas/Money"
        },
        "description": {
          "type": "string"
        },
        "effect": {
          "type": "string"
        },
        "rate": {
          "type": [
            "string",
            "null"
          ]
        },
        "rule": {
          "type": "string"
        },
        "tax": {
          "type": "string"
        },
        "taxable_base": {
          "$ref": "#/components/schemas/Money"
        },
        "treatment": {
          "type": "string"
        }
      },
      "required": [
        "tax",
        "rule",
        "effect",
        "treatment",
        "description",
        "rate",
        "taxable_base",
        "amount"
      ],
      "type": "object"
    },
    "InvoiceTotals": {
      "model": "InvoiceTotals",
      "properties": {
        "payable": {
          "$ref": "#/components/schemas/Money"
        },
        "subtotal": {
          "$ref": "#/components/schemas/Money"
        },
        "tax": {
          "$ref": "#/components/schemas/Money"
        },
        "total_with_tax": {
          "$ref": "#/components/schemas/Money"
        },
        "withheld_tax": {
          "$ref": "#/components/schemas/Money"
        }
      },
      "required": [
        "subtotal",
        "tax",
        "total_with_tax",
        "withheld_tax",
        "payable"
      ],
      "type": "object"
    },
    "Live": {
      "type": "boolean"
    },
    "Money": {
      "format": "decimal",
      "type": "string"
    },
    "PaymentInstruction": {
      "model": "PaymentInstruction",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "bank_transfer": {
          "$ref": "#/components/schemas/PaymentInstructionBankTransfer"
        },
        "created_at": {
          "format": "date-time",
          "type": "string"
        },
        "id": {
          "$ref": "#/components/schemas/PaymentInstructionId"
        },
        "label": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "payment_instruction",
          "type": "string"
        },
        "type": {
          "const": "bank_transfer",
          "type": "string"
        },
        "updated_at": {
          "format": "date-time",
          "type": "string"
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "account",
        "label",
        "type",
        "bank_transfer",
        "created_at",
        "updated_at"
      ],
      "type": "object"
    },
    "PaymentInstructionBankTransfer": {
      "model": "PaymentInstructionBankTransfer",
      "properties": {
        "beneficiary": {
          "type": "string"
        },
        "bic": {
          "type": [
            "string",
            "null"
          ]
        },
        "iban": {
          "type": "string"
        }
      },
      "required": [
        "beneficiary",
        "iban",
        "bic"
      ],
      "type": "object"
    },
    "PaymentInstructionBankTransferInput": {
      "model": "PaymentInstructionBankTransferInput",
      "properties": {
        "beneficiary": {
          "type": "string"
        },
        "bic": {
          "type": [
            "string",
            "null"
          ]
        },
        "iban": {
          "type": "string"
        }
      },
      "required": [
        "beneficiary",
        "iban"
      ],
      "type": "object"
    },
    "PaymentInstructionBankTransferUpdate": {
      "model": "PaymentInstructionBankTransferUpdate",
      "properties": {
        "beneficiary": {
          "type": "string"
        },
        "bic": {
          "type": [
            "string",
            "null"
          ]
        },
        "iban": {
          "type": "string"
        }
      },
      "type": "object"
    },
    "PaymentInstructionCreate": {
      "model": "PaymentInstructionCreate",
      "properties": {
        "bank_transfer": {
          "$ref": "#/components/schemas/PaymentInstructionBankTransferInput"
        },
        "label": {
          "type": "string"
        },
        "type": {
          "const": "bank_transfer",
          "type": "string"
        }
      },
      "required": [
        "label",
        "type",
        "bank_transfer"
      ],
      "type": "object"
    },
    "PaymentInstructionId": {
      "type": "string"
    },
    "PaymentInstructionList": {
      "model": "PaymentInstructionList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/PaymentInstruction"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "PaymentInstructionUpdate": {
      "model": "PaymentInstructionUpdate",
      "properties": {
        "bank_transfer": {
          "$ref": "#/components/schemas/PaymentInstructionBankTransferUpdate"
        },
        "label": {
          "type": "string"
        }
      },
      "type": "object"
    },
    "PdfRenderInProgressErrorResponse": {
      "model": "PdfRenderInProgressErrorResponse",
      "properties": {
        "error": {
          "model": "PdfRenderInProgressError",
          "properties": {
            "code": {
              "const": "pdf_render_in_progress",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "PdfRenderingUnavailableErrorResponse": {
      "model": "PdfRenderingUnavailableErrorResponse",
      "properties": {
        "error": {
          "model": "PdfRenderingUnavailableError",
          "properties": {
            "code": {
              "const": "pdf_rendering_unavailable",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "RelatedObject": {
      "model": "RelatedObject",
      "properties": {
        "id": {
          "type": "string"
        },
        "object": {
          "type": "string"
        }
      },
      "required": [
        "id",
        "object"
      ],
      "type": [
        "object",
        "null"
      ]
    },
    "RequestId": {
      "type": "string"
    },
    "ResourceNotFoundErrorResponse": {
      "model": "ResourceNotFoundErrorResponse",
      "properties": {
        "error": {
          "model": "ResourceNotFoundError",
          "properties": {
            "code": {
              "const": "resource_not_found",
              "type": "string"
            },
            "message": {
              "type": "string"
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "error"
      ],
      "type": "object"
    },
    "SpanishAccountRepresentation": {
      "model": "SpanishAccountRepresentation",
      "properties": {
        "kind": {
          "const": "aeat_registered_power",
          "type": "string"
        },
        "last_checked_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        },
        "power_code": {
          "const": "IZ860",
          "type": "string"
        },
        "status": {
          "type": "string"
        },
        "verified_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "kind",
        "power_code",
        "status",
        "verified_at",
        "last_checked_at"
      ],
      "type": "object"
    },
    "SpanishAccountTaxRegime": {
      "model": "SpanishAccountTaxRegime",
      "properties": {
        "account": {
          "$ref": "#/components/schemas/AccountId"
        },
        "es": {
          "$ref": "#/components/schemas/SpanishAccountTaxRegimeDetails"
        },
        "key": {
          "const": "es",
          "type": "string"
        },
        "object": {
          "const": "account_tax_regime",
          "type": "string"
        }
      },
      "required": [
        "object",
        "account",
        "key",
        "es"
      ],
      "type": "object"
    },
    "SpanishAccountTaxRegimeDetails": {
      "model": "SpanishAccountTaxRegimeDetails",
      "properties": {
        "representation": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/SpanishAccountRepresentation"
            },
            {
              "type": "null"
            }
          ]
        }
      },
      "required": [
        "representation"
      ],
      "type": "object"
    },
    "SpanishInvoiceQr": {
      "model": "SpanishInvoiceQr",
      "properties": {
        "content": {
          "type": "string"
        },
        "image_url": {
          "format": "uri",
          "type": "string"
        }
      },
      "required": [
        "content",
        "image_url"
      ],
      "type": "object"
    },
    "SpanishInvoiceTaxRegime": {
      "model": "SpanishInvoiceTaxRegime",
      "properties": {
        "es": {
          "$ref": "#/components/schemas/SpanishInvoiceTaxRegimeDetails"
        },
        "key": {
          "const": "es",
          "type": "string"
        }
      },
      "required": [
        "key",
        "es"
      ],
      "type": "object"
    },
    "SpanishInvoiceTaxRegimeDetails": {
      "model": "SpanishInvoiceTaxRegimeDetails",
      "properties": {
        "qr": {
          "$ref": "#/components/schemas/SpanishInvoiceQr"
        },
        "verifactu": {
          "$ref": "#/components/schemas/Verifactu"
        }
      },
      "required": [
        "qr",
        "verifactu"
      ],
      "type": "object"
    },
    "TaxId": {
      "model": "TaxId",
      "properties": {
        "country": {
          "type": "string"
        },
        "id": {
          "$ref": "#/components/schemas/TaxIdId"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "tax_id",
          "type": "string"
        },
        "owner": {
          "$ref": "#/components/schemas/TaxIdOwner"
        },
        "type": {
          "type": "string"
        },
        "value": {
          "type": "string"
        },
        "verification": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/TaxIdVerification"
            },
            {
              "type": "null"
            }
          ]
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "country",
        "type",
        "value",
        "owner",
        "verification"
      ],
      "type": "object"
    },
    "TaxIdId": {
      "type": "string"
    },
    "TaxIdInput": {
      "model": "TaxIdInput",
      "properties": {
        "country": {
          "type": "string"
        },
        "type": {
          "type": "string"
        },
        "value": {
          "type": "string"
        }
      },
      "required": [
        "country",
        "type",
        "value"
      ],
      "type": "object"
    },
    "TaxIdOwner": {
      "model": "TaxIdOwner",
      "properties": {
        "id": {
          "type": "string"
        },
        "type": {
          "type": "string"
        }
      },
      "required": [
        "type",
        "id"
      ],
      "type": "object"
    },
    "TaxIdSnapshot": {
      "model": "TaxIdSnapshot",
      "properties": {
        "country": {
          "type": "string"
        },
        "type": {
          "type": "string"
        },
        "value": {
          "type": "string"
        }
      },
      "required": [
        "country",
        "type",
        "value"
      ],
      "type": "object"
    },
    "TaxIdVerification": {
      "model": "TaxIdVerification",
      "properties": {
        "completed_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        },
        "status": {
          "type": "string"
        },
        "valid": {
          "type": [
            "boolean",
            "null"
          ]
        }
      },
      "required": [
        "status",
        "valid",
        "completed_at"
      ],
      "type": "object"
    },
    "TaxReference": {
      "model": "TaxReference",
      "properties": {
        "description": {
          "type": "string"
        },
        "effect": {
          "type": "string"
        },
        "rate": {
          "$ref": "#/components/schemas/DecimalInput"
        },
        "rule": {
          "type": "string"
        },
        "tax": {
          "type": "string"
        },
        "taxable_base": {
          "$ref": "#/components/schemas/DecimalInput"
        },
        "treatment": {
          "type": "string"
        }
      },
      "required": [
        "tax",
        "rule"
      ],
      "type": "object"
    },
    "TaxRegime": {
      "model": "TaxRegime",
      "properties": {
        "id": {
          "type": "string"
        },
        "object": {
          "const": "tax_regime",
          "type": "string"
        },
        "taxes": {
          "items": {
            "$ref": "#/components/schemas/TaxRegimeTax"
          },
          "type": "array"
        }
      },
      "required": [
        "id",
        "object",
        "taxes"
      ],
      "type": "object"
    },
    "TaxRegimeList": {
      "model": "TaxRegimeList",
      "properties": {
        "data": {
          "items": {
            "$ref": "#/components/schemas/TaxRegime"
          },
          "type": "array"
        },
        "has_more": {
          "type": "boolean"
        },
        "object": {
          "const": "list",
          "type": "string"
        }
      },
      "required": [
        "object",
        "has_more",
        "data"
      ],
      "type": "object"
    },
    "TaxRegimeTax": {
      "model": "TaxRegimeTax",
      "properties": {
        "effect": {
          "type": "string"
        },
        "name": {
          "type": "string"
        },
        "rules": {
          "items": {
            "$ref": "#/components/schemas/TaxRegimeTaxRule"
          },
          "type": "array"
        },
        "tax": {
          "type": "string"
        }
      },
      "required": [
        "tax",
        "name",
        "effect",
        "rules"
      ],
      "type": "object"
    },
    "TaxRegimeTaxRule": {
      "model": "TaxRegimeTaxRule",
      "properties": {
        "authority_code": {
          "type": [
            "string",
            "null"
          ]
        },
        "description": {
          "type": "string"
        },
        "effective_from": {
          "format": "date",
          "type": "string"
        },
        "effective_until": {
          "format": "date",
          "type": [
            "string",
            "null"
          ]
        },
        "legal_reference": {
          "type": [
            "string",
            "null"
          ]
        },
        "rate": {
          "type": [
            "string",
            "null"
          ]
        },
        "rule": {
          "type": "string"
        },
        "treatment": {
          "type": "string"
        }
      },
      "required": [
        "rule",
        "description",
        "treatment",
        "rate",
        "authority_code",
        "legal_reference",
        "effective_from",
        "effective_until"
      ],
      "type": "object"
    },
    "ValidationDetail": {
      "model": "ValidationDetail",
      "properties": {
        "code": {
          "type": "string"
        },
        "field": {
          "type": "string"
        },
        "message": {
          "type": "string"
        },
        "metadata": {
          "type": "object"
        }
      },
      "required": [
        "code",
        "field",
        "message",
        "metadata"
      ],
      "type": "object"
    },
    "Verifactu": {
      "model": "Verifactu",
      "properties": {
        "registrations": {
          "items": {
            "$ref": "#/components/schemas/VerifactuRegistration"
          },
          "type": "array"
        }
      },
      "required": [
        "registrations"
      ],
      "type": "object"
    },
    "VerifactuRegistration": {
      "model": "VerifactuRegistration",
      "properties": {
        "csv": {
          "type": [
            "string",
            "null"
          ]
        },
        "error": {
          "oneOf": [
            {
              "$ref": "#/components/schemas/VerifactuRegistrationError"
            },
            {
              "type": "null"
            }
          ]
        },
        "id": {
          "type": "string"
        },
        "invoice": {
          "type": "string"
        },
        "kind": {
          "type": "string"
        },
        "live": {
          "$ref": "#/components/schemas/Live"
        },
        "object": {
          "const": "verifactu_registration",
          "type": "string"
        },
        "status": {
          "type": "string"
        },
        "submitted_at": {
          "format": "date-time",
          "type": [
            "string",
            "null"
          ]
        }
      },
      "required": [
        "id",
        "object",
        "live",
        "invoice",
        "kind",
        "status",
        "submitted_at",
        "csv",
        "error"
      ],
      "type": "object"
    },
    "VerifactuRegistrationError": {
      "model": "VerifactuRegistrationError",
      "properties": {
        "code": {
          "type": "string"
        },
        "message": {
          "type": "string"
        },
        "raw": {
          "model": "VerifactuRegistrationRawError",
          "properties": {
            "code": {
              "type": [
                "string",
                "null"
              ]
            },
            "message": {
              "type": [
                "string",
                "null"
              ]
            }
          },
          "required": [
            "code",
            "message"
          ],
          "type": "object"
        }
      },
      "required": [
        "code",
        "message",
        "raw"
      ],
      "type": "object"
    }
  },
  "operations": {
    "amendInvoice": {
      "method": "POST",
      "path": "/invoices/{invoice_id}/amendments",
      "parameters": [
        {
          "name": "invoice_id",
          "in": "path",
          "required": true
        },
        {
          "name": "Idempotency-Key",
          "in": "header",
          "required": false
        }
      ],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/InvoiceAmendment"
        }
      }
    },
    "createApiKey": {
      "method": "POST",
      "path": "/api-keys",
      "parameters": [],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/ApiKey"
        }
      }
    },
    "createCustomer": {
      "method": "POST",
      "path": "/customers",
      "parameters": [],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/Customer"
        }
      }
    },
    "createEventDestination": {
      "method": "POST",
      "path": "/event-destinations",
      "parameters": [],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/EventDestination"
        }
      }
    },
    "createInvoiceSeries": {
      "method": "POST",
      "path": "/invoice-series",
      "parameters": [],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/InvoiceSeries"
        }
      }
    },
    "createPaymentInstruction": {
      "method": "POST",
      "path": "/payment-instructions",
      "parameters": [],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/PaymentInstruction"
        }
      }
    },
    "deleteApiKey": {
      "method": "DELETE",
      "path": "/api-keys/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "204": null
      }
    },
    "deleteCustomer": {
      "method": "DELETE",
      "path": "/customers/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "204": null
      }
    },
    "deleteEventDestination": {
      "method": "DELETE",
      "path": "/event-destinations/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "204": null
      }
    },
    "deleteInvoiceSeries": {
      "method": "DELETE",
      "path": "/invoice-series/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "204": null
      }
    },
    "deletePaymentInstruction": {
      "method": "DELETE",
      "path": "/payment-instructions/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "204": null
      }
    },
    "disableEventDestination": {
      "method": "POST",
      "path": "/event-destinations/{id}/disable",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventDestination"
        }
      }
    },
    "enableEventDestination": {
      "method": "POST",
      "path": "/event-destinations/{id}/enable",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventDestination"
        }
      }
    },
    "issueInvoice": {
      "method": "POST",
      "path": "/invoices",
      "parameters": [
        {
          "name": "Idempotency-Key",
          "in": "header",
          "required": false
        }
      ],
      "responses": {
        "201": {
          "$ref": "#/components/schemas/Invoice"
        }
      }
    },
    "listApiKeys": {
      "method": "GET",
      "path": "/api-keys",
      "parameters": [
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/ApiKeyList"
        }
      }
    },
    "listCustomers": {
      "method": "GET",
      "path": "/customers",
      "parameters": [
        {
          "name": "q",
          "in": "query"
        },
        {
          "name": "country",
          "in": "query"
        },
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/CustomerList"
        }
      }
    },
    "listEventDestinations": {
      "method": "GET",
      "path": "/event-destinations",
      "parameters": [
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventDestinationList"
        }
      }
    },
    "listEvents": {
      "method": "GET",
      "path": "/events",
      "parameters": [
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        },
        {
          "name": "types",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventList"
        }
      }
    },
    "listInvoiceSeries": {
      "method": "GET",
      "path": "/invoice-series",
      "parameters": [
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoiceSeriesList"
        }
      }
    },
    "listInvoices": {
      "method": "GET",
      "path": "/invoices",
      "parameters": [
        {
          "name": "q",
          "in": "query"
        },
        {
          "name": "customer",
          "in": "query"
        },
        {
          "name": "issue_date_from",
          "in": "query"
        },
        {
          "name": "issue_date_to",
          "in": "query"
        },
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoiceList"
        }
      }
    },
    "listPaymentInstructions": {
      "method": "GET",
      "path": "/payment-instructions",
      "parameters": [
        {
          "name": "limit",
          "in": "query"
        },
        {
          "name": "starting_after",
          "in": "query"
        },
        {
          "name": "ending_before",
          "in": "query"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/PaymentInstructionList"
        }
      }
    },
    "listTaxRegimes": {
      "method": "GET",
      "path": "/tax-regimes",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/TaxRegimeList"
        }
      }
    },
    "renderInvoicePdf": {
      "method": "POST",
      "path": "/invoices/{invoice_id}/pdf",
      "parameters": [
        {
          "name": "invoice_id",
          "in": "path",
          "required": true
        },
        {
          "name": "Accept-Language",
          "in": "header"
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoicePdf"
        },
        "201": {
          "$ref": "#/components/schemas/InvoicePdf"
        }
      }
    },
    "retrieveAccount": {
      "method": "GET",
      "path": "/account",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Account"
        }
      }
    },
    "retrieveAccountInvoicing": {
      "method": "GET",
      "path": "/account/invoicing",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/AccountInvoicing"
        }
      }
    },
    "retrieveAccountTaxRegime": {
      "method": "GET",
      "path": "/account/tax-regime",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/AccountTaxRegime"
        }
      }
    },
    "retrieveApiKey": {
      "method": "GET",
      "path": "/api-keys/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/ApiKey"
        }
      }
    },
    "retrieveBalance": {
      "method": "GET",
      "path": "/account/balance",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Balance"
        }
      }
    },
    "retrieveCustomer": {
      "method": "GET",
      "path": "/customers/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Customer"
        }
      }
    },
    "retrieveEvent": {
      "method": "GET",
      "path": "/events/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Event"
        }
      }
    },
    "retrieveEventDestination": {
      "method": "GET",
      "path": "/event-destinations/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventDestination"
        }
      }
    },
    "retrieveInvoice": {
      "method": "GET",
      "path": "/invoices/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Invoice"
        }
      }
    },
    "retrieveInvoicePdf": {
      "method": "GET",
      "path": "/invoices/{invoice_id}/pdf",
      "parameters": [
        {
          "name": "invoice_id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoicePdf"
        }
      }
    },
    "retrieveInvoiceSeries": {
      "method": "GET",
      "path": "/invoice-series/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoiceSeries"
        }
      }
    },
    "retrievePaymentInstruction": {
      "method": "GET",
      "path": "/payment-instructions/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/PaymentInstruction"
        }
      }
    },
    "retrieveTaxId": {
      "method": "GET",
      "path": "/tax-ids/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/TaxId"
        }
      }
    },
    "retrieveTaxRegime": {
      "method": "GET",
      "path": "/tax-regimes/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/TaxRegime"
        }
      }
    },
    "updateAccount": {
      "method": "PATCH",
      "path": "/account",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Account"
        }
      }
    },
    "updateAccountInvoicing": {
      "method": "PATCH",
      "path": "/account/invoicing",
      "parameters": [],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/AccountInvoicing"
        }
      }
    },
    "updateCustomer": {
      "method": "PATCH",
      "path": "/customers/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/Customer"
        }
      }
    },
    "updateEventDestination": {
      "method": "PATCH",
      "path": "/event-destinations/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/EventDestination"
        }
      }
    },
    "updateInvoiceSeries": {
      "method": "PATCH",
      "path": "/invoice-series/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/InvoiceSeries"
        }
      }
    },
    "updatePaymentInstruction": {
      "method": "PATCH",
      "path": "/payment-instructions/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true
        }
      ],
      "responses": {
        "200": {
          "$ref": "#/components/schemas/PaymentInstruction"
        }
      }
    }
  }
}
JSON
    Model.deep_freeze(CONTRACT)
    SCHEMAS = CONTRACT.fetch("schemas")
    OPERATIONS = CONTRACT.fetch("operations")
  end
end
