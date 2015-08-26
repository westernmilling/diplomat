class CreateInterfaceLogs < ActiveRecord::Migration
  def change
    create_table :interface_logs do |t|
      t.references :organization
      t.references :integration
      t.references :interfaceable, null: false, polymorphic: true
      t.string :interface_payload
      t.string :interface_status
      t.string :interface_identifier
      t.string :message
      t.string :status, null: false
      t.string :action, null: false
      t.integer :version

      t.timestamps null: false
    end
  end
end
