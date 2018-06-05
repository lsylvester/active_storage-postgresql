module ActiveStorage
  module PostgreSQL
    class Engine < ::Rails::Engine
      isolate_namespace ActiveStorage::PostgreSQL
    end
  end
end
