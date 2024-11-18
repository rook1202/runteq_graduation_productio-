# frozen_string_literal: true

# リマインダーテーブルからカラムを削除・カラム名変更するマイグレーションファイル
# rubocop:disable Rails/BulkChangeTable
class ModifyActivityColumnsInRemainders < ActiveRecord::Migration[7.0]
  def up
    change_table :remainders, bulk: true do |t|
      t.remove :activity_type
      t.rename :activity_model_type, :activity_type
      t.rename :activity_model_id, :activity_id
    end

    remove_index :remainders, name: 'index_remainders_on_activity_type_and_activity_id', if_exists: true
    add_index :remainders, %i[activity_type activity_id]
  end

  def down
    change_table :remainders, bulk: true do |t|
      t.integer :activity_type
      t.rename :activity_type, :activity_model_type
      t.rename :activity_id, :activity_model_id
    end

    # インデックス操作についてはchange_tableの外に記載する必要があるがrubocopに引っかかるため無効化している。
    remove_index :remainders, %i[activity_type activity_id], if_exists: true
    add_index :remainders, %i[activity_model_type activity_model_id]
  end
end
# rubocop:enable Rails/BulkChangeTable
