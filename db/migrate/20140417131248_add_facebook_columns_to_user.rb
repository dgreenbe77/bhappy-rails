class AddFacebookColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :pic_big, :string
    add_column :users, :friend_count, :integer
    add_column :users, :activities, :text
    add_column :users, :affiliations, :text
    add_column :users, :birthday, :string
    add_column :users, :books, :text
    add_column :users, :current_address, :string
    add_column :users, :current_location, :string
    add_column :users, :education, :text
    add_column :users, :interests, :text
    add_column :users, :languages, :text
    add_column :users, :movies, :text
    add_column :users, :music, :text
    add_column :users, :political, :string
    add_column :users, :profile_blurb, :text
    add_column :users, :quotes, :text
    add_column :users, :religion, :text
    add_column :users, :sports, :text
    add_column :users, :tv, :text
  end
end
