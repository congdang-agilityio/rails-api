class ChangeDayOfBirthToUsers < ActiveRecord::Migration[5.0]
  def up
    rename_column :auth_users, :da_of_birth, :date_of_birth
  end

  def down
    rename_column :auth_users, :date_of_birth, :da_of_birth
  end
end
