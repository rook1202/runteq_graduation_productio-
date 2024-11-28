# frozen_string_literal: true

# ユーザーのログイン情報に関するモデルです。オートログインのメソッドが設定されています。
class Session < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :user_id, presence: true
  validates :remember_digest, presence: true
  validates :login_time, presence: true
  validates :expires_at, presence: true
  validates :ip_address, presence: true, format: { with: /\A\d{1,3}(\.\d{1,3}){3}\z/, message: 'は有効なIPアドレスではありません' }

  # トークン生成用メソッド
  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  # セッションを作成する
  def self.create_session_for(user, ip_address)
    token = generate_token
    digest = BCrypt::Password.create(token)
    session = create(
      user: user,
      remember_digest: digest,
      login_time: Time.current,
      expires_at: 2.weeks.from_now,
      ip_address: ip_address
    )
    { session: session, token: token }
  end

  # トークン認証
  def valid_token?(token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(token)
  end

  # セッションの有効期限を確認
  def expired?
    Time.current > expires_at
  end
end
