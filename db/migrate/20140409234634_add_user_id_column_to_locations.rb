class AddUserIdColumnToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :user_id, :integer, null: false
  end
end
