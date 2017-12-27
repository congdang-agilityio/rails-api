class AddOauthTokenToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :token, :string
    add_column :identities, :expires_at, :datetime
  end
end
