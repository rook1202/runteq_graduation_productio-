# frozen_string_literal: true

# Partner共有のためのトークン発行・管理するテーブルのモデル
class Token < ApplicationRecord
  # バリデーション
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :expiration_date, presence: true

  # 関連付け（オプションで必要に応じて記述）
  belongs_to :user
  belongs_to :partner, optional: true

  # スコープ（有効期限が切れていないトークンを取得）
  scope :valid_tokens, -> { where('expiration_date > ?', Time.current) }

  # トークン生成用メソッド
  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  # トークン作成処理（個別共有 or 一括共有を判定）
  def self.create_share_for(user:, partner: nil)
    create!(
      user: user,
      token: generate_token,
      partner: partner,
      expiration_date: 1.hour.from_now
    )
  end

  # 認証メソッド
  def self.authenticate(token_string)
    token = find_by(token: token_string)
    return nil if token.nil? || token.expiration_date < Time.current
    token
  end
  
end
