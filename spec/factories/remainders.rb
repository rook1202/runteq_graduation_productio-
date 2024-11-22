# frozen_string_literal: true

FactoryBot.define do
  factory :remainder do
    association :partner
    time { '10:00' }
    notification_status { false }

    trait :for_food do
      activity_type { 'Food' }
      activity_id { nil } # 外部から渡される
    end

    trait :for_walk do
      activity_type { 'Walk' }
      activity_id { nil } # 外部から渡される
    end

    trait :for_medication do
      activity_type { 'Medication' }
      activity_id { nil } # 外部から渡される
    end
  end
end
