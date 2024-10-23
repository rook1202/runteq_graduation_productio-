class AddNotNullConstraintToGender < ActiveRecord::Migration[7.0]
  def change
    change_column_null :partners, :gender, false, 0
  end
end
