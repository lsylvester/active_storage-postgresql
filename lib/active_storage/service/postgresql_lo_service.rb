# frozen_string_literal: true

module ActiveStorage
  # Wraps a local disk path as an Active Storage service. See ActiveStorage::Service for the generic API
  # documentation that applies to all services.
  class Service::PostgresqlLoService < Service
    def initialize(**options)
    end
  end
end
