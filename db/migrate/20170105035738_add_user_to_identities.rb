class AddUserToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_reference :identities, :user, index: true
  end
end
