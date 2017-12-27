class AddNameEmailToIdentities < ActiveRecord::Migration[5.0]
  def up
    add_column :identities, :name, :string
    add_column :identities, :email, :string
  end

  def down
    remove_column :identities, :name
    remove_column :identities, :email
  end
end
