class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :entity, :null => false
      t.integer :is_active, :default => 1, :null => false
      t.string :location_name, :null => false
      t.string :street_address, :null => false
      t.string :city, :null => false
      t.string :region, :null => false
      t.string :region_code, :null => false
      t.string :country, :null => false
      t.string :uuid, :limit => 32, :null => false
      t.decimal :latitude, :precision => 10, :scale => 8
      t.decimal :longitude, :precision => 11, :scale => 8

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
