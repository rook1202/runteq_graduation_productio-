# frozen_string_literal: true

# パートナーテーブルのマイグレーションファイル
class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.references :owner, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.integer :gender
      t.date :birthday
      t.string :weight
      t.text :note

      t.timestamps
    end
  end
end
