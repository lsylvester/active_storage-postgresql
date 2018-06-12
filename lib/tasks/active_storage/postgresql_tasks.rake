# frozen_string_literal: true

namespace :active_storage do
  namespace :postgresql do
    desc "Copy over the migration needed to the application"
    task install: :environment do
      if Rake::Task.task_defined?("active_storage_postgresql:install:migrations")
        Rake::Task["active_storage_postgresql:install:migrations"].invoke
      else
        Rake::Task["app:active_storage_postgresql:install:migrations"].invoke
      end
    end
  end
end
