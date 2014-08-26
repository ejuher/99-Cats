class ChangeRentalRequestDateTypes < ActiveRecord::Migration
  def change
    change_column :cat_rental_requests, :start_date, :date, null: false
    change_column :cat_rental_requests, :end_date, :date, null: false
  end
end
