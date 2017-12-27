class AddCountryCodeToUsers < ActiveRecord::Migration[5.0]
  def up
    rename_table :identities, :auth_identities if ActiveRecord::Base.connection.table_exists? 'identities'
    rename_table :users, :auth_users if ActiveRecord::Base.connection.table_exists? 'users'
    add_column :auth_users, :country_code, :string
  end

  def down
    remove_column :auth_users, :country_code
    rename_table :auth_users, :users if ActiveRecord::Base.connection.table_exists? 'auth_users'
    rename_table :auth_identities, :identities if ActiveRecord::Base.connection.table_exists? 'auth_identities'
  end
end
