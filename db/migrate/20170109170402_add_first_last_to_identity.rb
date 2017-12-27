class AddFirstLastToIdentity < ActiveRecord::Migration[5.0]
  def up
    add_column :identities, :first_name, :string
    add_column :identities, :last_name, :string
  end

  def down
    remove_column :identities, :first_name
    remove_column :identities, :last_name
  end
end
