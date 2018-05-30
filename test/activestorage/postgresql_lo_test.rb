# frozen_string_literal: true

require "activestorage/shared_service_tests"
class ActiveStorage::Service::PostgresqlLoServiceTest < ActiveSupport::TestCase
  SERVICE  = ActiveStorage::Service.configure(:postgresql_lo, {postgresql_lo: {service: "PostgresqlLo"}})

  include ActiveStorage::Service::SharedServiceTests
end
