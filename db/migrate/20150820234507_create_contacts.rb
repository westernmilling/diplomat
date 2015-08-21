class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :entity, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :display_name, null: false
      t.string :title
      t.string :email_address
      t.string :fax_number
      t.string :mobile_number
      t.string :phone_number
      t.integer :is_active, default: 1, null: false
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 1, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
