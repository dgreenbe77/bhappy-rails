class AddSecretOauthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret_oauth_token, :string
  end
end
