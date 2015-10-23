class RemoveContactIdAndLocationIdFromVendors < ActiveRecord::Migration
  def change
    remove_column :vendors, :contact_id
    remove_column :vendors, :location_id
  end
end
