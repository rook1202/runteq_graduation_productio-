# frozen_string_literal: true

# sessionsテーブルにオートログインのためのカラムを追加
class UpdateSessionsTableForRememberMe < ActiveRecord::Migration[7.0]
  def up
    change_table :sessions, bulk: true do |t|
      t.string :remember_digest, after: :user_id
      t.datetime :expires_at, after: :login_time
      t.remove :activity_type
    end
  end

  def down
    change_table :sessions, bulk: true do |t|
      t.remove :remember_digest
      t.remove :expires_at
      t.string :activity_type, after: :expires_at # 元の位置に戻す
    end
  end
end
