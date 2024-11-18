# frozen_string_literal: true

class AddActivityModelToRemainders < ActiveRecord::Migration[7.0]
  def change
    add_column :remainders, :activity_model_type, :string
    add_column :remainders, :activity_model_id, :bigint
    add_index :remainders, %i[activity_model_type activity_model_id]
  end
end
