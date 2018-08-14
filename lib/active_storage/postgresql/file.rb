class ActiveStorage::PostgreSQL::File < ActiveRecord::Base
  self.table_name = "active_storage_postgresql_files"

  attr_accessor :checksum, :io

  before_create :write_or_import, if: :io

  def write_or_import
    if io.respond_to?(:to_path)
      import(io.to_path)
      if checksum
        unless Digest::MD5.file(io.to_path).base64digest == checksum
          raise ActiveStorage::IntegrityError
        end
      end
    else
      self.oid ||= lo_creat
      md5 = Digest::MD5.new
      open(::PG::INV_WRITE) do |file|
        while data = io.read(5.megabytes)
          md5.update(data)
          file.write(data)
        end
      end

      if checksum
        unless md5.base64digest == checksum
          raise ActiveStorage::IntegrityError
        end
      end
    end
  end

  def self.open(key, &block)
    find_by!(key: key).open(&block)
  end

  def open(*args)
    transaction do
      begin
        @lo = lo_open(oid, *args)
        yield(self)
      ensure
        lo_close(@lo) if @lo
      end
    end
  end

  def write(content)
    lo_write(@lo, content)
  end

  def read(bytes=size)
    lo_read(@lo, bytes)
  end

  def seek(position, whence=PG::SEEK_SET)
    lo_seek(@lo, position, whence)
  end

  def import(path)
    self.oid = lo_import(path)
  end

  def tell
    lo_tell(@lo)
  end

  def size
    current_position = tell
    seek(0, PG::SEEK_END)
    tell.tap do
      seek(current_position)
    end
  end

  def unlink
    lo_unlink(oid)
  end

  before_destroy :unlink

  delegate :lo_seek, :lo_tell, :lo_import, :lo_read, :lo_write, :lo_open,
      :lo_unlink, :lo_close, :lo_creat, to: 'self.class.connection.raw_connection'

  scope :prefixed_with, -> prefix { where("key like ?", "#{prefix}%") }

end
