# frozen_string_literal: true

# SNSログインの追加にともないproviderとuidカラム追加
class AddProviderAndUidToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider
      t.string :uid
    end
    add_index :users, %i[provider uid], unique: true
  end
end
