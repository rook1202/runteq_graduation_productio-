# frozen_string_literal: true

# sorceryの導入により追加されたマイグレーションファイル、ユーザー情報のテーブル
class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
  end
end
