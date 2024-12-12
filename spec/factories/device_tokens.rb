FactoryBot.define do
  factory :device_token do
    token { "MyString" }
    partner { nil }
  end
end
