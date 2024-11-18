# frozen_string_literal: true

# パートナーのごはんについてのマイグレーションファイル
class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.references :partner, foreign_key: true
      t.string :manufacturer
      t.string :category
      t.string :amount
      t.string :place

      t.timestamps
    end
  end
end
