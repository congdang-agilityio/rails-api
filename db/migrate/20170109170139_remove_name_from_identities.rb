class RemoveNameFromIdentities < ActiveRecord::Migration[5.0]
  def up
    remove_column :identities, :name
  end

  def down
    add_column :identities, :name, :string
  end
end
