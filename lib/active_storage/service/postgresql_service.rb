# frozen_string_literal: true

require 'active_storage/postgresql/file'

module ActiveStorage
  # Wraps a PostgreSQL database as an Active Storage service. See ActiveStorage::Service for the generic API
  # documentation that applies to all services.
  class Service::PostgreSQLService < Service
    def initialize(**options)
    end

    def upload(key, io, checksum: nil, **)
      instrument :upload, key: key, checksum: checksum do
        ActiveStorage::PostgreSQL::File.create!(key: key, io: io, checksum: checksum)
      end
    end

    def download(key)
      if block_given?
        instrument :streaming_download, key: key do
          ActiveStorage::PostgreSQL::File.open(key) do |file|
            while data = file.read(5.megabytes)
              yield data
            end
          end
        end
      else
        instrument :download, key: key do
          ActiveStorage::PostgreSQL::File.open(key) do |file|
            file.read
          end
        end
      end
    end

    def download_chunk(key, range)
      instrument :download_chunk, key: key, range: range do
        ActiveStorage::PostgreSQL::File.open(key) do |file|
          file.seek(range.first)
          file.read(range.size)
        end
      end
    end

    def delete(key)
      instrument :delete, key: key do
        ActiveStorage::PostgreSQL::File.find_by(key: key).try(&:destroy)
      end
    end

    def exist?(key)
      instrument :exist, key: key do |payload|
        answer = ActiveStorage::PostgreSQL::File.where(key: key).exists?
        payload[:exist] = answer
        answer
      end
    end

    def delete_prefixed(prefix)
      instrument :delete_prefixed, prefix: prefix do
        ActiveStorage::PostgreSQL::File.prefixed_with(prefix).destroy_all
      end
    end

    def url(key, expires_in:, filename:, disposition:, content_type:)
      instrument :url, key: key do |payload|
        content_disposition = content_disposition_with(type: disposition, filename: filename)
        verified_key_with_expiration = ActiveStorage.verifier.generate(
          {
            key: key,
            disposition: content_disposition,
            content_type: content_type
          },
          expires_in: expires_in,
          purpose: :blob_key
        )

        generated_url = url_helpers.rails_postgresql_service_url(verified_key_with_expiration,
          host: current_host,
          disposition: content_disposition,
          content_type: content_type,
          filename: filename
        )
        payload[:url] = generated_url

        generated_url
      end
    end

    def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:)
      instrument :url, key: key do |payload|
        verified_token_with_expiration = ActiveStorage.verifier.generate(
          {
            key: key,
            content_type: content_type,
            content_length: content_length,
            checksum: checksum
          },
          expires_in: expires_in,
          purpose: :blob_token
        )

        generated_url = url_helpers.update_rails_postgresql_service_url(verified_token_with_expiration, host: current_host)

        payload[:url] = generated_url

        generated_url
      end
    end

    def headers_for_direct_upload(key, content_type:, **)
      { "Content-Type" => content_type }
    end

    protected

    def url_helpers
      @url_helpers ||= Rails.application.routes.url_helpers
    end

    def current_host
      ActiveStorage::Current.host
    end
  end
end
