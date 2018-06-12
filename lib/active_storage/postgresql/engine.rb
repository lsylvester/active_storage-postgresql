module ActiveStorage
  module PostgreSQL
    class Engine < ::Rails::Engine
      isolate_namespace ActiveStorage::PostgreSQL

      railtie_name 'active_storage_postgresql'
    end
  end
end
