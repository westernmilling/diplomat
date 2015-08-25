class AddIntegrationIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :integration_id, :integer
  end
end
