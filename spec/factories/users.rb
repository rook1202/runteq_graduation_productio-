# ユーザーのテスト情報
FactoryBot.define do
    factory :user do
      name { 'てすと' }
      email { 'test@example.com' }
      password { '12345678' }
      password_confirmation { '12345678' }
    end
end