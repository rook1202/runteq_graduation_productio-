# frozen_string_literal: true

# パートナーテーブルにもしnoteカラムが残っていれば削除するマイグレーションファイル
class RemoveNoteFromPartners < ActiveRecord::Migration[7.0]
  def change
    return unless column_exists?(:partners, :note)

    remove_column :partners, :note, :text
  end
end
