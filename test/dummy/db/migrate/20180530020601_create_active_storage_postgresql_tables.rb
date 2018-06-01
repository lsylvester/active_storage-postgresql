class CreateActiveStoragePostgresqlTables < ActiveRecord::Migration[5.2]
  def change
    create_table :active_storage_postgresql_files do |t|
      t.integer :oid
      t.string :path
      t.integer :size
    end
  end
end
