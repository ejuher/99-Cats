class AddUniqueToTokenIndexInSessionTable < ActiveRecord::Migration
  def change
    remove_index :sessions, :token
    add_index :sessions, :token, unique: true
  end
end
