# frozen_string_literal: true

require_relative "test_helper"
require "socket"

class HTTPAdapterTest < SDKTest
  def test_real_http_connection_reuse_headers_body_and_close
    server = TCPServer.new("127.0.0.1", 0)
    requests = Queue.new
    thread = Thread.new do
      socket = server.accept
      2.times do |index|
        request_line = socket.gets
        headers = {}
        while (line = socket.gets) && line != "\r\n"
          name, value = line.strip.split(":", 2)
          headers[name.downcase] = value.strip
        end
        body = headers["content-length"] ? socket.read(Integer(headers["content-length"])) : nil
        requests << [request_line, headers, body]
        payload = JSON.generate(fixture("Customer"))
        socket.write("HTTP/1.1 #{index.zero? ? '201 Created' : '200 OK'}\r\nContent-Type: application/json\r\nContent-Length: #{payload.bytesize}\r\nRequest-Id: req_socket\r\nConnection: keep-alive\r\n\r\n#{payload}")
      end
      requests << socket.read(1) # #close must close the same persistent socket.
    ensure
      socket&.close
    end
    sdk = FiscalRail::Client.new(api_key: "ak_test_socket", base_url: "http://127.0.0.1:#{server.addr[1]}/v1", timeout: 2, max_retries: 0)
    customer = sdk.customers.create(name: "España")
    assert_equal "req_socket", customer.request_id
    sdk.customers.retrieve(customer.id)
    sdk.close
    assert thread.join(3), "HTTP server did not finish"
    first = requests.pop
    assert_equal "POST /v1/customers HTTP/1.1\r\n", first[0]
    assert_equal "Bearer ak_test_socket", first[1]["authorization"]
    assert_equal({ "name" => "España" }, JSON.parse(first[2]))
    assert_match %r{GET /v1/customers/cus_}, requests.pop[0]
    assert_nil requests.pop
  ensure
    sdk&.close
    server&.close
    thread&.kill
    thread&.join
  end

  def test_network_read_timeout_is_exposed_without_replaying_creation
    server = TCPServer.new("127.0.0.1", 0)
    accepted = Queue.new
    thread = Thread.new do
      socket = server.accept
      accepted << true
      socket.read # Deliberately never responds; client must time out and close.
    ensure
      socket&.close
    end
    sdk = FiscalRail::Client.new(api_key: "test", base_url: "http://127.0.0.1:#{server.addr[1]}/v1", timeout: 0.05, max_retries: 2)
    assert_raises(FiscalRail::APITimeoutError) { sdk.customers.create(name: "Test") }
    assert_equal 1, accepted.size
  ensure
    sdk&.close
    server&.close
    thread&.kill
    thread&.join
  end
end
