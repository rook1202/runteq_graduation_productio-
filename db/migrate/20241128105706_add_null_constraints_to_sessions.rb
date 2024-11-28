# frozen_string_literal: true

# Sessionsテーブルのカラムにfalseを追加
class AddNullConstraintsToSessions < ActiveRecord::Migration[7.0]
  def change
    change_table :sessions, bulk: true do |t|
      t.change_null :user_id, false
      t.change_null :remember_digest, false
      t.change_null :login_time, false
      t.change_null :expires_at, false
      t.change_null :ip_address, false
    end
  end
end
