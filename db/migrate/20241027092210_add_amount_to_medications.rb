# frozen_string_literal: true

# おくすりテーブルに量というカラムを追加するマイグレーションファイル
class AddAmountToMedications < ActiveRecord::Migration[7.0]
  def change
    add_column :medications, :amount, :string
  end
end
