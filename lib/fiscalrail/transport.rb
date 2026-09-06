# frozen_string_literal: true

require "net/http"
require "json"
require "uri"
require "thread"

module FiscalRail
  # The adapter boundary also makes custom proxy/TLS/instrumentation possible.
  # Adapters return Response and implement #call(method:, uri:, headers:, body:).
  class NetHTTPAdapter
    Response = Struct.new(:status, :headers, :body, keyword_init: true)

    def initialize(open_timeout:, read_timeout:, write_timeout:)
      @open_timeout, @read_timeout, @write_timeout = open_timeout, read_timeout, write_timeout
      @mutex = Mutex.new
    end

    def call(method:, uri:, headers:, body:)
      @mutex.synchronize do
        origin = [Process.pid, uri.scheme, uri.host, uri.port]
        if @origin != origin || !@http&.started?
          disconnect
          @http = Net::HTTP.new(uri.host, uri.port)
          @http.use_ssl = uri.scheme == "https"
          @http.open_timeout = @open_timeout
          @http.read_timeout = @read_timeout
          @http.write_timeout = @write_timeout
          @http.max_retries = 0 # The SDK alone decides which operations are safe.
          @http.start
          @origin = origin
        end
        request = Net::HTTPGenericRequest.new(method, !body.nil?, method != "HEAD", uri.request_uri, headers)
        request.body = body if body
        result = @http.request(request)
        Response.new(status: result.code.to_i, headers: result.each_header.to_h, body: result.body || "")
      rescue IOError, SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError, Net::HTTPBadResponse, Net::ProtocolError
        disconnect
        raise
      end
    end

    def close
      @mutex.synchronize { disconnect }
    end

    private

    def disconnect
      @http.finish if @http&.started?
    rescue IOError, SystemCallError
      nil
    ensure
      @http = nil
      @origin = nil
    end
  end

  class Transport
    CONNECTION_ERRORS = [IOError, SystemCallError, SocketError, OpenSSL::SSL::SSLError, Net::HTTPBadResponse, Net::ProtocolError].freeze

    def initialize(api_key:, base_url:, max_retries:, adapter:, sleeper: Kernel.method(:sleep))
      @api_key, @base_url, @max_retries, @adapter, @sleeper = api_key, base_url.sub(%r{/+\z}, ""), max_retries, adapter, sleeper
    end

    def request(method:, path:, body: nil, params: {}, headers: {}, retry_safe:, idempotency_key: nil)
      uri = URI("#{@base_url}#{path}")
      query = Serialization.json_value(params.reject { |_, value| value.nil? })
      uri.query = URI.encode_www_form(query) unless query.empty?
      request_headers = {
        "Authorization" => "Bearer #{@api_key}", "Accept" => "application/json",
        "User-Agent" => "fiscalrail-ruby/#{VERSION}"
      }.merge(headers)
      request_headers["Idempotency-Key"] = idempotency_key if idempotency_key
      request_headers["Content-Type"] = "application/json" unless body.nil?
      encoded = body.nil? ? nil : JSON.generate(Serialization.json_value(body))
      attempt = 0
      loop do
        begin
          response = @adapter.call(method: method, uri: uri, headers: request_headers, body: encoded)
        rescue Timeout::Error => error
          if retry_safe && attempt < @max_retries
            wait(attempt)
            attempt += 1
            next
          end
          raise APITimeoutError.new("Request to FiscalRail timed out", idempotency_key: idempotency_key), cause: error
        rescue *CONNECTION_ERRORS => error
          if retry_safe && attempt < @max_retries
            wait(attempt)
            attempt += 1
            next
          end
          raise APIConnectionError.new("Could not connect to FiscalRail", idempotency_key: idempotency_key), cause: error
        end
        response.headers = response.headers.transform_keys { |key| key.to_s.downcase }
        return response if response.status.between?(200, 299)

        if retry_safe && attempt < @max_retries && ([408, 429].include?(response.status) || response.status >= 500)
          wait(attempt, response.headers["retry-after"])
          attempt += 1
          next
        end
        raise Errors.from_response(status: response.status, headers: response.headers, body: response.body, idempotency_key: idempotency_key)
      end
    end

    private

    def wait(attempt, retry_after = nil)
      delay = begin
        Float(retry_after) if retry_after
      rescue ArgumentError, TypeError
        begin
          Time.httpdate(retry_after) - Time.now
        rescue ArgumentError
          nil
        end
      end
      delay = 0.25 * (2**attempt) unless delay&.finite?
      @sleeper.call([[delay, 0].max, 30].min)
    end
  end
end
