# frozen_string_literal: true

require "activestorage/shared_service_tests"
class ActiveStorage::Service::PostgresqlLoServiceTest < ActiveSupport::TestCase
  SERVICE  = ActiveStorage::Service.configure(:postgresql_lo, {postgresql_lo: {service: "PostgresqlLo"}})

  setup do
    ActiveStorage::Current.host = "https://example.com"
  end

  teardown do
    ActiveStorage::Current.reset
  end

  include ActiveStorage::Service::SharedServiceTests

  test "url generation" do
    assert_match(/^https:\/\/example.com\/rails\/active_storage\/disk\/.*\/avatar\.png\?content_type=image%2Fpng&disposition=inline/,
      @service.url(FIXTURE_KEY, expires_in: 5.minutes, disposition: :inline, filename: ActiveStorage::Filename.new("avatar.png"), content_type: "image/png"))
  end

  test "headers_for_direct_upload generation" do
    assert_equal({ "Content-Type" => "application/json" }, @service.headers_for_direct_upload(FIXTURE_KEY, content_type: "application/json"))
  end
end
