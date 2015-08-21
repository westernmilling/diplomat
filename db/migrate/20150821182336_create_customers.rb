class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :contact
      t.references :location
      t.references :entity, null: false
      t.references :parent_customer
      t.references :bill_to_location, null: false
      t.references :ship_to_location, null: false
      t.references :salesperson
      t.integer :is_active, default: 1, null: false
      t.integer :is_tax_exempt, default: 0, null: false
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 1, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
