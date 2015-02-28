class AddPromiscuousVersionColumnsToChancellorModels < ActiveRecord::Migration
  def change
    add_column :entities, :_v, :integer
    add_column :locations, :_v, :integer
    add_column :contacts, :_v, :integer
    add_column :salespeople, :_v, :integer
    add_column :customers, :_v, :integer
    add_column :vendors, :_v, :integer
  end
end
