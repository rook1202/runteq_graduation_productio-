# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.string :activity_type
      t.datetime :login_time
      t.string :ip_address

      t.timestamps
    end
  end
end
