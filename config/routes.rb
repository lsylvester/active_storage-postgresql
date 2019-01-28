# frozen_string_literal: true

Rails.application.routes.draw do
  get  "/rails/active_storage/postgresql/:encoded_key/*filename" => "active_storage/postgresql#show", as: :rails_postgresql_service
  put  "/rails/active_storage/postgresql/:encoded_token" => "active_storage/postgresql#update", as: :update_rails_postgresql_service
end
