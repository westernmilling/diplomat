class ChangeVendorsVersionColumnDefault < ActiveRecord::Migration
  def change
    change_column :vendors, :_v, :integer, default: 1, null: false
  end
end
