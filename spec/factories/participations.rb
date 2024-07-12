FactoryBot.define do
  factory :participation do
    user_id { nil }
    event_id { nil }

    trait :with_user do
      user
    end

    trait :with_event do
      event
    end

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
