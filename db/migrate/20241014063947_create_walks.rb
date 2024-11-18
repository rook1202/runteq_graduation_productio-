# frozen_string_literal: true

class CreateWalks < ActiveRecord::Migration[7.0]
  def change
    create_table :walks do |t|
      t.references :partner, foreign_key: true
      t.integer :time

      t.timestamps
    end
  end
end
