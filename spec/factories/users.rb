# frozen_string_literal: true

# ユーザーのテスト情報
FactoryBot.define do
  factory :user do
    name { 'てすと' }
    email { 'test@example.com' }
    password { '12345678' }
    password_confirmation { '12345678' }

    # 2人目のユーザー用の設定
    trait :other_user do
      name { 'てすと2' }
      email { 'test2@example.com' }
    end
  end
end
