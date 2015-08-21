class CreateSalespeople < ActiveRecord::Migration
  def change
    create_table :salespeople do |t|
      t.references :entity, null: false
      t.string :gender, limit: 7
      t.integer :is_active, default: 1, null: false
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 1, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
