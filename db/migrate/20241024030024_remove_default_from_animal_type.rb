# frozen_string_literal: true

# パートナーテーブルのカラムからデフォルト値を削除するマイグレーションファイル
class RemoveDefaultFromAnimalType < ActiveRecord::Migration[7.0]
  def change
    change_column_default :partners, :animal_type, from: '不明', to: nil
  end
end
