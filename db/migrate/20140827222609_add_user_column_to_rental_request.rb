class AddUserColumnToRentalRequest < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :user_id, :integer
    
    CatRentalRequest.all.update_all(user_id: 1)
    
    change_column :cat_rental_requests, :user_id, :integer, null: false
    
    add_index :cat_rental_requests, :user_id
  end
end
