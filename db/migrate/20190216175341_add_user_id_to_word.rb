class AddUserIdToWord < ActiveRecord::Migration[5.2]
  def change
  	add_column :words, :user_id, :integer
  end
end
