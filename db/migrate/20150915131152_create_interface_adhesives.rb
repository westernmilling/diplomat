class CreateInterfaceAdhesives < ActiveRecord::Migration
  def change
    create_table :interface_adhesives do |t|
      t.references :organization, null: false
      t.references :integration, null: false
      t.references :interfaceable, null: false, polymorphic: true
      t.string :interface_id, null: false
      t.integer :version

      t.timestamps null: false
    end
  end
end
