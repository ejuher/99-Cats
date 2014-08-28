class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string :token
      t.string :device_description
      
      t.timestamps
    end
  end
end
