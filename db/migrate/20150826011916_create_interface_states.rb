class CreateInterfaceStates < ActiveRecord::Migration
  def change
    create_table :interface_states do |t|
      t.references :organization, null: false
      t.references :integration, null: false
      t.references :interfaceable, null: false, polymorphic: true
      # t.string :message
      # t.string :status, null: false
      # t.string :action, null: false
      t.string :interface_id, null: false
      t.integer :version
      # t.integer :count, default: 1, null: false

      t.timestamps null: false
    end
  end
end
