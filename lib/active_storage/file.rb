class ActiveStorage::File < ActiveRecord::Base
  self.table_name = "active_storage_files"

  alias_attribute :key, :path

  before_create do
    self.oid = self.class.connection.raw_connection.lo_creat
  end

  def self.open(key, &block)
    find_by!(key: key).open(&block)
  end

  def open(*args)
    transaction do
      @lo = self.class.connection.raw_connection.lo_open(oid, *args)
      yield self
      self.class.connection.raw_connection.lo_close(@lo)
    end
  end

  attr_reader :lo

  def write(content)
    self.class.connection.raw_connection.lo_write(@lo, content)
    update(size: self.class.connection.raw_connection.lo_tell(@lo))
  end

  def read(bytes=size)
    self.class.connection.raw_connection.lo_read(@lo, bytes)
  end

end
