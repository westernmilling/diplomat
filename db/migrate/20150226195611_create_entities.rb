class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :cached_long_name, :limit => 1024, :null => false
      t.string :display_name, :null => false
      t.integer :is_active, :default => 1, :null => false
      t.string :name, :null => false
      t.string :comments
      t.string :reference, :null => false
      t.string :uuid, :limit => 32, :null => false

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
