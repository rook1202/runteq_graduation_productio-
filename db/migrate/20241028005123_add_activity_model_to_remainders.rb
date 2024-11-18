# frozen_string_literal: true

# リマインダーカラムを追加するマイグレーションファイル
class AddActivityModelToRemainders < ActiveRecord::Migration[7.0]
  def change
    change_table :remainders, bulk: true do |t|
      t.string :activity_model_type
      t.bigint :activity_model_id
    end

    add_index :remainders, %i[activity_model_type activity_model_id]
  end
end
