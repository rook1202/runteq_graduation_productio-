# frozen_string_literal: true

# Partner共有のためのトークン発行・管理するテーブルを作成する
class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :token, null: false, unique: true
      t.references :user, null: false, foreign_key: true
      t.references :partner, foreign_key: true
      t.datetime :expiration_date, null: false
      t.timestamps
    end

    add_index :tokens, :token, unique: true
  end
end
