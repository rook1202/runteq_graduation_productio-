# frozen_string_literal: true

FactoryBot.define do
  factory :partner do
    association :owner, factory: :user # owner_idに関連付けるためにownerを指定
    sequence(:name) { |n| "パートナー名#{n}" } # 必須フィールド
    gender { 0 } # デフォルト値
    birthday { '2000-01-01' } # 任意の誕生日
    weight { '10kg' } # 任意の体重
    animal_type { '犬' } # 必須フィールド
    breed { '柴犬' } # 任意の犬種
  end
end
