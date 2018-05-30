# frozen_string_literal: true

require 'active_storage/file'

module ActiveStorage
  # Wraps a local disk path as an Active Storage service. See ActiveStorage::Service for the generic API
  # documentation that applies to all services.
  class Service::PostgresqlLoService < Service
    def initialize(**options)
    end

    # ensure a match when the upload has completed or raise an ActiveStorage::IntegrityError.
    def upload(key, io, checksum: nil)
      ActiveStorage::File.create!(key: key).open(::PG::INV_WRITE) do |file|
        file.write(io.read)
      end
      ensure_integrity_of(key, checksum) if checksum
    end

    # Return the content of the file at the +key+.
    def download(key)
      if block_given?
        ActiveStorage::File.open(key) do |file|
          while data = file.read(5.megabytes)
            yield data
          end
        end
      else
        content = nil
        ActiveStorage::File.open(key) do |file|
          content = file.read
        end
        content
      end
    end

    def download_chunk(key, range)
      content = nil
      ActiveStorage::File.open(key) do |file|
        file.seek(range.first)
        content = file.read(range.size)
      end
      content
    end

    def exist?(key)
      ActiveStorage::File.where(key: key).exists?
    end

    def delete(key)
      ActiveStorage::File.find_by(key: key).try(&:destroy)
    end

    def delete_prefixed(prefix)
      ActiveStorage::File.prefixed_with(prefix).destroy_all
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
