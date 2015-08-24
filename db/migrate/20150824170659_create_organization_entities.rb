class CreateOrganizationEntities < ActiveRecord::Migration
  def change
    create_table :organization_entities do |t|
      t.references :entity, null: false
      t.references :organization, null: false
      t.string :trait, null: false
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 1, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
