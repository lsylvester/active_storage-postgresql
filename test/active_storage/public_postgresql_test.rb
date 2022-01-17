# frozen_string_literal: true

require "active_storage/shared_service_tests"
require "net/http"

class ActiveStorage::Service::PostgreSQLPublicServiceTest < ActiveSupport::TestCase
  tmp_config = {
    tmp_public: { service: "PostgreSQL", public: true }
  }
  SERVICE = ActiveStorage::Service.configure(:tmp_public, tmp_config)

  include ActiveStorage::Service::SharedServiceTests

  test "public URL generation" do
    url = @service.url(@key, disposition: :inline, filename: ActiveStorage::Filename.new("avatar.png"), content_type: "image/png")

    assert_match(/^https:\/\/example.com\/rails\/active_storage\/postgresql\/.*\/avatar\.png/, url)
  end
end
