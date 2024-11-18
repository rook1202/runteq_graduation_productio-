# frozen_string_literal: true

# walks、foods、medicinesテーブルにnoteカラムを追加するマイグレーションファイル
class ModifyTables < ActiveRecord::Migration[7.0]
  def change
    # partnersテーブルからnoteカラムを削除（すでに削除済みなのでコメントアウト）
    # remove_column :partners, :note, :text

    # walks、foods、medicinesテーブルにnoteカラムを追加
    add_column :walks, :note, :text unless column_exists?(:walks, :note)
    add_column :foods, :note, :text unless column_exists?(:foods, :note)
    add_column :medications, :note, :text unless column_exists?(:medications, :note)
  end
end
