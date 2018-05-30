# frozen_string_literal: true

require 'active_storage/file'

module ActiveStorage
  # Wraps a local disk path as an Active Storage service. See ActiveStorage::Service for the generic API
  # documentation that applies to all services.
  class Service::PostgresqlLoService < Service
    def initialize(**options)
    end

    def upload(key, io, checksum: nil)
      instrument :upload, key: key, checksum: checksum do
        ActiveStorage::File.create!(key: key).open(::PG::INV_WRITE) do |file|
          file.write(io.read)
        end
        ensure_integrity_of(key, checksum) if checksum
      end
    end

    def download(key)
      if block_given?
        instrument :streaming_download, key: key do
          ActiveStorage::File.open(key) do |file|
            while data = file.read(5.megabytes)
              yield data
            end
          end
        end
      else
        instrument :download, key: key do
          ActiveStorage::File.open(key) do |file|
            file.read
          end
        end
      end
    end

    def download_chunk(key, range)
      instrument :download_chunk, key: key, range: range do
        ActiveStorage::File.open(key) do |file|
          file.seek(range.first)
          file.read(range.size)
        end
      end
    end

    def delete(key)
      instrument :delete, key: key do
        ActiveStorage::File.find_by(key: key).try(&:destroy)
      end
    end

    def exist?(key)
      instrument :exist, key: key do |payload|
        answer = ActiveStorage::File.where(key: key).exists?
        payload[:exist] = answer
        answer
      end
    end

    def delete_prefixed(prefix)
      instrument :delete_prefixed, prefix: prefix do
        ActiveStorage::File.prefixed_with(prefix).destroy_all
      end
    end

    protected

    def ensure_integrity_of(key, checksum)
      unless Digest::MD5.base64digest(download(key)) == checksum
        delete key
        raise ActiveStorage::IntegrityError
      end
    end
  end
end
