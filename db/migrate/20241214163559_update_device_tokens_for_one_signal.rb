# frozen_string_literal: true

# Firebase仕様だったDeviceTokenテーブルをOneSignal仕様に変更する（token→player_id）マイグレーションファイル
class UpdateDeviceTokensForOneSignal < ActiveRecord::Migration[7.0]
  def up
    change_table :device_tokens, bulk: true do |t|
      t.remove :token
      t.string :player_id, null: true, index: true # 一旦 null: true で追加
      t.string :device_type
      t.string :device_os
    end

    # 既存データにデフォルト値を設定（安全な方法）
    DeviceToken.find_each do |device_token|
      device_token.update!(player_id: 'unknown')
    end

    # null: false 制約を追加
    change_column_null :device_tokens, :player_id, false
  end

  def down
    change_table :device_tokens, bulk: true do |t|
      t.string :token
      t.remove :player_id
      t.remove :device_type
      t.remove :device_os
    end
  end
end
