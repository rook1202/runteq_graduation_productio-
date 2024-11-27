class AddEmailChangeFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :new_email
      t.string :email_change_token
      t.datetime :email_change_token_expires_at
      t.datetime :email_change_requested_at, null: true
    end

    add_index :users, :email_change_token, unique: true
  end
end
