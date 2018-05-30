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
      ActiveStorage::File.transaction do
        oid = ActiveStorage::File.connection.raw_connection.lo_creat

        ActiveStorage::File.create!(oid: oid, key: key)
        lo = ActiveStorage::File.connection.raw_connection.lo_open(oid, ::PG::INV_WRITE)
        content = io.read
        ActiveStorage::File.connection.raw_connection.lo_write(lo, content)
        ActiveStorage::File.connection.raw_connection.lo_close(lo)
      end
    end

    # Return the content of the file at the +key+.
    def download(key)
      content = nil
      if block_given?
        ActiveStorage::File.transaction do
          file = ActiveStorage::File.find_by!(key: key)
          lo = ActiveStorage::File.connection.raw_connection.lo_open(file.oid)

          size = ActiveStorage::File.connection.raw_connection.lo_lseek(lo, 0, 2)
          ActiveStorage::File.connection.raw_connection.lo_lseek(lo, 0, 0)

          amount_to_read = [size, 5.megabytes].min
          while amount_to_read > 0
            yield  ActiveStorage::File.connection.raw_connection.lo_read(lo, amount_to_read)
            size -= amount_to_read
            amount_to_read = [size, 5.megabytes].min
          end
          ActiveStorage::File.connection.raw_connection.lo_close(lo)
        end
      else
        ActiveStorage::File.transaction do
          file = ActiveStorage::File.find_by!(key: key)
          lo = ActiveStorage::File.connection.raw_connection.lo_open(file.oid)

          size = ActiveStorage::File.connection.raw_connection.lo_lseek(lo, 0, 2)
          ActiveStorage::File.connection.raw_connection.lo_lseek(lo, 0, 0)
          content = ActiveStorage::File.connection.raw_connection.lo_read(lo, size)
          ActiveStorage::File.connection.raw_connection.lo_close(lo)
        end
        content
      end
    end

    def download_chunk(key, range)
      content = nil
      ActiveStorage::File.transaction do
        file = ActiveStorage::File.find_by!(key: key)
        lo = ActiveStorage::File.connection.raw_connection.lo_open(file.oid)
        size = ActiveStorage::File.connection.raw_connection.lo_lseek(lo, 0, 2)
        ActiveStorage::File.connection.raw_connection.lo_lseek(lo, range.first, 0)
        bytes_to_read = range.size

        content = ActiveStorage::File.connection.raw_connection.lo_read(lo, bytes_to_read)
        ActiveStorage::File.connection.raw_connection.lo_close(lo)
      end
      content
    end

    def exist?(key)
      ActiveStorage::File.where(key: key).exists?
    end

    def delete(key)
      ActiveStorage::File.transaction do
        ActiveStorage::File.find_by(key: key).try do |file|
          ActiveStorage::File.connection.raw_connection.lo_unlink(file.oid)
          file.destroy
        end
      end
    end
  end
end
