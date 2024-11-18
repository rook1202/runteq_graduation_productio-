# frozen_string_literal: true

# パートナーテーブルにカラムを追加するマイグレーションファイル
class AddAnimalTypeAndBreedToPartners < ActiveRecord::Migration[7.0]
  def change
    change_table :partners, bulk: true do |t|
      t.string :animal_type, default: '不明', null: false
      t.string :breed
    end
  end
end
