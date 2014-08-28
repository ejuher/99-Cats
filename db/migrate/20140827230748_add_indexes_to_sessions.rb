class AddIndexesToSessions < ActiveRecord::Migration
  def change
    change_column :sessions, :user_id, :integer, null: false
    change_column :sessions, :token, :string, null: false
    change_column :sessions, :device_description, :string, null: false
    
    add_index :sessions, :user_id
    add_index :sessions, :token
  end
end
