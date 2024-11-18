# frozen_string_literal: true

# パートナーのおくすりについてのマイグレーションファイル
class CreateMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :medications do |t|
      t.references :partner, foreign_key: true
      t.string :name
      t.string :place
      t.string :clinic

      t.timestamps
    end
  end
end
