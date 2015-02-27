class CreateAgcusmst < ActiveRecord::Migration
  def change
    create_table :agcusmst do |t|
      t.string :agcust_key, :limit => 10 # how do we create a char(10)?
    end
  end
end
