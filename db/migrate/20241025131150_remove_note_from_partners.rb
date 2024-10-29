class RemoveNoteFromPartners < ActiveRecord::Migration[7.0]
  def change
    remove_column :partners, :note, :text if column_exists?(:partners, :note)
  end
end
