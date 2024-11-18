# frozen_string_literal: true

# リマインダーテーブルのactivity_typeカラムのデータ型を変更するマイグレーションファイル
class ChangeActivityTypeToIntegerInRemainders < ActiveRecord::Migration[7.0]
  def up
    # activity_typeカラムのデータ型をstringからintegerに変換
    change_column :remainders, :activity_type, :integer, using: 'activity_type::integer'
  end

  def down
    # ロールバック時にデータ型をintegerからstringに戻す
    change_column :remainders, :activity_type, :string
  end
end
