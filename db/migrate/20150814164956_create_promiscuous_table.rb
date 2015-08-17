class CreatePromiscuousTable < ActiveRecord::Migration
  def change
    create_table :_promiscuous do |t|
      t.text :batch
      t.timestamp :at
      # 'TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP'
    end
  end
end
