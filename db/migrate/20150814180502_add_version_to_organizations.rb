class AddVersionToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :_v, :integer, default: 1
  end
end
