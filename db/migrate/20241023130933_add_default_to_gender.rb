# frozen_string_literal: true

class AddDefaultToGender < ActiveRecord::Migration[7.0]
  def change
    change_column_default :partners, :gender, from: nil, to: 0
  end
end
