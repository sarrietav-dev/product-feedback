class RenameEmailToEmailAddressInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :email, :email_address
    add_index :users, :email_address, unique: true
  end
end
