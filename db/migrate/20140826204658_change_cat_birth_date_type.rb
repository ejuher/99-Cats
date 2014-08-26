class ChangeCatBirthDateType < ActiveRecord::Migration
  def change
    change_column :cats, :birth_date, :date, null: false
  end
end
