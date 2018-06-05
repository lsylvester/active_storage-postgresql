# desc "Explaining what the task does"
# task :activestorage_postgresql do
#   # Task goes here
# end
# frozen_string_literal: true

namespace :active_storage do
  namespace :postgresql do
    desc "Copy over the migration needed to the application"
    task install: :environment do
      Rake::Task["active_storage:install"].invoke
      if Rake::Task.task_defined?("active_storage_postgre_sql:install:migrations")
        Rake::Task["active_storage_postgre_sql:install:migrations"].invoke
      else
        Rake::Task["app:active_storage_postgre_sql:install:migrations"].invoke
      end
    end
  end
end
