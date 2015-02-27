class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.references :default_contact
      t.references :default_location
      t.references :entity, :null => false
      t.string :reference, :null => false
      t.integer :is_active, :default => 1, :null => false
      t.string :uuid, :limit => 32, :null => false

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
