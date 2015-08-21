class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.references :contact
      t.references :location
      t.references :entity, null: false
      t.integer :is_active, default: 1, null: false
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 0, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
