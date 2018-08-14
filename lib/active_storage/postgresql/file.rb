class ActiveStorage::PostgreSQL::File < ActiveRecord::Base
  self.table_name = "active_storage_postgresql_files"

  before_create do
    self.oid ||= lo_creat
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
    transaction do
      self.oid = lo_import(path)
    end
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
