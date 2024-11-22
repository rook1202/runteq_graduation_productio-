# frozen_string_literal: true

FactoryBot.define do
  factory :food do
    association :partner # Partnerに関連付ける
    sequence(:manufacturer) { |n| "フードメーカー名#{n}" }
    category { 'フードカテゴリ' }
    amount { '小さじ一杯' }
    place { 'テレビの横の箱' }
    note { 'メモメモメモ' }
  end

  factory :walk do
    association :partner # Partnerに関連付ける
    time { '1時間' }
    note { 'メモメモメモ' }
  end

  factory :medication do
    association :partner # Partnerに関連付ける
    name { 'くすりの名前' }
    place { '置き場所' }
    clinic { 'クリニック名' }
    amount { '1錠' }
    note { 'メモメモメモ' }
  end
end
