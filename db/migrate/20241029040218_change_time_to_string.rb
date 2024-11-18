# frozen_string_literal: true

class ChangeTimeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :remainders, :time, :string
    change_column :walks, :time, :string
  end
end
