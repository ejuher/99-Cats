class AddIpToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :ip, :string, null: false
  end
end
