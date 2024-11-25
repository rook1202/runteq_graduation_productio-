# frozen_string_literal: true

# パスワードリセットのためのカラムをユーザーテーブルに追加
class AddResetPasswordToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :reset_password_token
      t.datetime :reset_password_token_expires_at
      t.datetime :reset_password_email_sent_at
      t.integer :access_count_to_reset_password_page, default: 0
    end

    add_index :users, :reset_password_token, unique: true
  end
end
