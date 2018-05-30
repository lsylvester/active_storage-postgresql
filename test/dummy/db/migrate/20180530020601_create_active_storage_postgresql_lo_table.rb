class CreateActiveStoragePostgresqlLoTable < ActiveRecord::Migration[5.2]
  def change
    enable_extension :ltree

    create_table :active_storage_files do |t|
      t.integer :oid
      t.ltree :path
    end
  end
end
