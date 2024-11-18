# frozen_string_literal: true

class ModifyActivityColumnsInRemainders < ActiveRecord::Migration[7.0]
  def change
    # activity_typeの削除
    remove_column :remainders, :activity_type, :integer

    # activity_model_typeとactivity_model_idをリネーム
    rename_column :remainders, :activity_model_type, :activity_type
    rename_column :remainders, :activity_model_id, :activity_id

    # インデックスが既に存在する場合は削除してから追加
    remove_index :remainders, name: 'index_remainders_on_activity_type_and_activity_id', if_exists: true
    add_index :remainders, %i[activity_type activity_id]
  end
end
