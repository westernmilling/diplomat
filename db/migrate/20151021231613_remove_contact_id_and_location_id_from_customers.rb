class RemoveContactIdAndLocationIdFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :contact_id
    remove_column :customers, :location_id
  end
end
