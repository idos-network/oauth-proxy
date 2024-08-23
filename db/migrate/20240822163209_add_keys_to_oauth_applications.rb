class AddKeysToOauthApplications < ActiveRecord::Migration[7.2]
  def change
    add_column :oauth_applications, :encryption_sk, :string
    add_column :oauth_applications, :sign_sk, :string
  end
end
