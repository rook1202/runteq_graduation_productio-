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
  belongs_to :user, inverse_of: :partner_shares
  belongs_to :shared_by_user, class_name: 'User', foreign_key: :shared_by, inverse_of: :shared_partner_shares

  # 一括共有の場合の保存
  def self.process_bulk_share(token, current_user_id)
    partners = Partner.where(owner_id: token.user_id)
    success_count = 0
    partners.each do |partner|
      create!(
        partner_id: partner.id,
        user_id: token.user_id,
        shared_by: current_user_id
      )
      success_count += 1
    end
    success_count
  end

  # 個別共有の場合の保存
  def self.process_individual_share(token, current_user_id)
    new(
      partner_id: token.partner_id,
      user_id: token.user_id,
      shared_by: current_user_id
    ).save
  end

  # 自分が共有したデータを削除
  def self.remove_shared_by_me(current_user_id, user_id)
    where(shared_by: current_user_id, user_id: user_id).destroy_all
  end

  # 自分に共有されたデータを削除
  def self.remove_shared_with_me(current_user_id, user_id)
    where(shared_by: user_id, user_id: current_user_id).destroy_all
  end
end
