# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require "rails/test_unit/reporter"
Rails::TestUnitReporter.executable = 'bin/test'

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

ActiveSupport::TestCase.setup do
  DatabaseCleaner.start
end

class ActiveSupport::TestCase

  setup do
    ActiveStorage::Current.host = "https://example.com"
  end

  teardown do
    ActiveStorage::Current.reset
  end

  def create_blob(data: "Hello world!", filename: "hello.txt", content_type: "text/plain", identify: true)
    ActiveStorage::Blob.create_and_upload! io: StringIO.new(data), filename: filename, content_type: content_type
  end

  def create_blob_before_direct_upload(filename: "hello.txt", byte_size:, checksum:, content_type: "text/plain")
    ActiveStorage::Blob.create_before_direct_upload! filename: filename, byte_size: byte_size, checksum: checksum, content_type: content_type
  end

  def with_service(service_name)
    previous_service = ActiveStorage::Blob.service

    skip unless ActiveStorage::Blob.respond_to?(:services)

    ActiveStorage::Blob.service = service_name ? ActiveStorage::Blob.services.fetch(service_name) : nil

    yield
  ensure
    ActiveStorage::Blob.service = previous_service
  end

  def create_file_blob(key: nil, filename: "racecar.jpg", content_type: "image/jpeg", metadata: nil, service_name: nil, record: nil)
    ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata, service_name: service_name, record: record
  end
end

ActiveSupport::TestCase.teardown do
  ActiveRecord::Base.transaction do
    ActiveRecord::Base.connection.select_values("SELECT oid from pg_largeobject_metadata").each do |oid|
      ActiveRecord::Base.connection.raw_connection.lo_unlink(oid)
    end
  end
  DatabaseCleaner.clean
end
