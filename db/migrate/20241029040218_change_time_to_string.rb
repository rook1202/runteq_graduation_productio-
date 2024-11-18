# frozen_string_literal: true

# 各時間に関するカラムのデータ型を変更するマイグレーションファイル
class ChangeTimeToString < ActiveRecord::Migration[7.0]
  def up
    # timeカラムのデータ型をstringに変更
    change_column :remainders, :time, :string
    change_column :walks, :time, :string
  end

  def down
    # ロールバック時にデータ型を元に戻す（おそらく:datetimeと仮定）
    change_column :remainders, :time, :datetime
    change_column :walks, :time, :datetime
  end
end
