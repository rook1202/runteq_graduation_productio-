# frozen_string_literal: true

class CreateRemainders < ActiveRecord::Migration[7.0]
  def change
    create_table :remainders do |t|
      t.references :partner, foreign_key: true
      t.string :activity_type
      t.datetime :time
      t.boolean :notification_status, default: false

      t.timestamps
    end
  end
end
