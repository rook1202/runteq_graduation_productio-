# frozen_string_literal: true

# ユーザーの新規登録に関するモデルです。
class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :partners, foreign_key: :owner_id,
                      dependent: :destroy, inverse_of: :owner

  # バリデーションを追加
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :new_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  validates :email_change_token, uniqueness: true, allow_nil: true
end
