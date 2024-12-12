class AddJobIdToRemainders < ActiveRecord::Migration[7.0]
  def change
    add_column :remainders, :job_id, :string
  end
end
