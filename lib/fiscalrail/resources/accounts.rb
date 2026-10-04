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
      def es
        @es ||= SpanishSubmission.new(@transport)
      end

      def retrieve
        request("retrieveAccountTaxRegime", retry_safe: true)
      end
    end
    class SpanishSubmission < Resource
      def upload_certificate(certificate_file:, certificate_password: nil)
        content = certificate_file.read(128 * 1024 + 1) || ""
        raise ArgumentError, "certificate_file must be at most 128 KiB" if content.bytesize > 128 * 1024

        request("uploadAccountCertificate", multipart: { certificate_file: content, certificate_password: certificate_password })
      end

      def verify_representation
        request("verifyAccountRepresentation")
      end

      def verify_submission
        request("verifyAccountSubmission")
      end

      def cancel_submission_change
        request("cancelAccountSubmissionChange")
      end
    end
  end
end
