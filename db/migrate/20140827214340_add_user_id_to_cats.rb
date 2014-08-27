class AddUserIdToCats < ActiveRecord::Migration
  def change
    add_column :cats, :user_id, :integer  
    Cat.all.update_all(user_id: 1)  
    change_column :cats, :user_id, :integer, null: false
    
    add_index :cats, :user_id
  end
end
