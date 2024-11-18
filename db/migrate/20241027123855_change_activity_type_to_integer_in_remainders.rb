# frozen_string_literal: true

class ChangeActivityTypeToIntegerInRemainders < ActiveRecord::Migration[7.0]
  def change
    change_column :remainders, :activity_type, :integer, using: 'activity_type::integer'
  end
end
