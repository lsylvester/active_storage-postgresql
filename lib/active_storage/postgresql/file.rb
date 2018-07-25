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

  def seek(position)
    lo_seek(@lo, position, 0)
  end

  def import(path)
    transaction do
      self.oid = lo_import(path)
    end
  end

  def size
    current_position = lo_tell(@lo)
    lo_seek(@lo, 0,2)
    lo_tell(@lo).tap do
      lo_seek(@lo, current_position,0)
    end
  end

  before_destroy do
    self.class.connection.raw_connection.lo_unlink(oid)
  end

  delegate :lo_seek, :lo_tell, :lo_import, :lo_read, :lo_write, :lo_open,
      :lo_unlink, :lo_close, :lo_creat, to: 'self.class.connection.raw_connection'

  scope :prefixed_with, -> prefix { where("key like ?", "#{prefix}%") }

end
