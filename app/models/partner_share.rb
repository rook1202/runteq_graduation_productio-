# frozen_string_literal: true

# 別ユーザーと共有しているPartnerを管理するためのテーブルのモデル
class PartnerShare < ApplicationRecord
  # バリデーション
  validates :partner_id, presence: true
  validates :user_id, presence: true
  validates :shared_by, presence: true
  validates :partner_id, uniqueness: { scope: %i[user_id shared_by], message: 'すでに共有済みです' }

  # 関連付け（オプションで必要に応じて記述）
  belongs_to :partner
  belongs_to :user
  belongs_to :shared_by_user, class_name: 'User', inverse_of: :shared_partner_shares
end
