# frozen_string_literal: true

# user_idとplayer_idの組み合わせに一意制約を追加するマイグレーションファイル
class AddUniqueIndexToDeviceTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :device_tokens, %i[user_id player_id], unique: true, name: 'index_device_tokens_on_user_id_and_player_id'
  end
end
