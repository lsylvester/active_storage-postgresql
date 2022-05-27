require "active_storage/postgresql/engine"

module ActiveStorage
  module PostgreSQL
    extend ActiveSupport::Autoload

    autoload :File, "active_storage/postgresql/file"

  end
end
