# frozen_string_literal: true

# ユーザーのデバイス情報を登録するモデル
class DeviceToken < ApplicationRecord
  belongs_to :user
  validates :player_id, presence: true
  validates :user_id, presence: true
  validates :player_id, uniqueness: { scope: :user_id, message: 'is already registered for this user' }
end
