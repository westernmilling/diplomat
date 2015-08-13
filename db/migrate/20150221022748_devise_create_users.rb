class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :is_active, default: 1, null: false
      t.string :encrypted_password
      recoverable_colums t
      sign_in_columns t
      t.datetime :remember_created_at
      lockable_columns t
      invitable_columns t

      t.timestamps null: false

      t.index :email, unique: true
      t.index :reset_password_token, unique: true
      invitable_indexes t
    end
  end

  def invitable_columns(table)
    table.string :invitation_token
    table.datetime :invitation_created_at
    table.datetime :invitation_sent_at
    table.datetime :invitation_accepted_at
    table.integer :invitation_limit
    table.references :invited_by, polymorphic: true
    table.integer :invitations_count, default: 0
  end

  def invitable_indexes(table)
    table.index :invitations_count
    table.index :invitation_token, unique: true
    table.index :invited_by_id
  end

  def sign_in_columns(table)
    table.integer :sign_in_count, default: 0, null: false
    table.datetime :current_sign_in_at
    table.datetime :last_sign_in_at
    table.string :current_sign_in_ip
    table.string :last_sign_in_ip
  end

  def lockable_columns(table)
    table.integer :failed_attempts, default: 0, null: false
    table.string :unlock_token
    table.datetime :locked_at
  end

  def recoverable_colums(table)
    table.string :reset_password_token
    table.datetime :reset_password_sent_at
  end
end
