# desc "Explaining what the task does"
# task :activestorage_postgresql do
#   # Task goes here
# end
# frozen_string_literal: true

namespace :active_storage do
  namespace :postgresql do
    desc "Copy over the migration needed to the application"
    task install: :environment do
      if Rake::Task.task_defined?("active_storage:install:migrations")
        Rake::Task["active_storage:postgresql:install:migrations"].invoke
      else
        Rake::Task["app:active_storage:postgresql:install:migrations"].invoke
      end
    end
  end
end
