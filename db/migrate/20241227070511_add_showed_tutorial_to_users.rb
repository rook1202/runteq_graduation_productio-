# frozen_string_literal: true

# Userテーブルにチュートリアルのフラグ管理カラムを追加
class AddShowedTutorialToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :showed_tutorial, :boolean, default: false
  end
end
