class AddContactIdToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :contact_id, :integer
  end
end
