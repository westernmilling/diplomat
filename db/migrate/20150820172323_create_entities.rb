class CreateEntities < ActiveRecord::Migration
  # rubocop:disable Metrics/AbcSize
  def change
    create_table :entities do |t|
      t.string :cached_long_name, limit: 1024, null: false
      t.string :comments
      t.string :display_name, null: false
      t.string :entity_type, default: 'company', limit: 32, null: false
      t.string :federal_tax_id
      t.integer :is_active, default: 1, null: false
      t.integer :is_withholding
      t.string :name, null: false
      t.integer :parent_entity_id
      t.string :reference, null: false
      t.string :tax_number
      t.string :tax_state
      t.string :ten99_form
      t.integer :ten99_print, default: 0, null: false
      t.string :ten99_type
      t.datetime :ten99_signed_at
      t.string :uuid, limit: 32, null: false
      t.integer :_v, default: 1, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
  # rubocop:enable Metrics/AbcSize
end
