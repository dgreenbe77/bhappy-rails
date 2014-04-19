class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image, :string
    add_column :users, :hometown, :string
    add_column :users, :work, :text
  end
end
