# frozen_string_literal: true

require_relative "test_helper"

class WebhooksTest < SDKTest
  def signature(body, timestamp: 1_788_688_800, secret: "whsec_test")
    digest = OpenSSL::HMAC.hexdigest("SHA256", secret, "#{timestamp}.".b + body.b)
    "t=#{timestamp},v1=#{digest}"
  end

  def verify(body, header, **options)
    FiscalRail::Webhooks.construct_event(body, header, "whsec_test", now: 1_788_688_800, **options)
  end

  def test_exact_raw_body_and_multiple_signatures
    body = "{\n  \"name\": \"España\"\n}"
    assert_equal({ "name" => "España" }, verify(body, "#{signature(body)},v1=bad"))
    assert_equal({ "name" => "España" }, verify(body, "v1=bad,#{signature(body)}"))
    assert_raises(FiscalRail::WebhookSignatureError) { verify(JSON.generate(JSON.parse(body)), signature(body)) }
    assert_raises(FiscalRail::WebhookSignatureError) { verify(body, signature(body, secret: "wrong")) }
  end

  def test_timestamp_tolerance_in_both_directions
    body = "{}"
    [-300, 300].each { |delta| assert_equal({}, verify(body, signature(body, timestamp: 1_788_688_800 + delta))) }
    [-301, 301].each { |delta| assert_raises(FiscalRail::WebhookSignatureError) { verify(body, signature(body, timestamp: 1_788_688_800 + delta)) } }
    assert_equal({}, verify(body, signature(body, timestamp: 1), tolerance: nil))
    assert_raises(ArgumentError) { verify(body, signature(body), tolerance: -1) }
  end

  def test_malformed_headers_and_payloads
    [nil, "", "v1=bad", "t=abc,v1=bad", "t=1,t=1,v1=bad", "t=1,v1="].each do |header|
      assert_raises(FiscalRail::WebhookSignatureError) { verify("{}", header) }
    end
    ["[]", "null", "broken"].each do |body|
      assert_raises(FiscalRail::WebhookSignatureError) { verify(body, signature(body)) }
    end
  end
end
