FactoryBot.define do
  factory :favorite do
    user_id { nil }
    event_id { nil }

    trait :with_user do
      user
    end

    trait :with_event do
      event
    end
  end
end
