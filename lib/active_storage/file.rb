class ActiveStorage::File < ActiveRecord::Base
  self.table_name = "active_storage_files"

  alias_attribute :key, :path
end
