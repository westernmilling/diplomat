class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :name, null: false
      t.string :integration_type, null: false
      t.string :address, null: false
      t.string :credentials, null: false
      t.string :uuid, limit: 32, null: false

      t.timestamps null: false
    end
  end
end
