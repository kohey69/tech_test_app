FactoryBot.define do
  factory :review do
    user { nil }
    event { nil }
    score { rand(1..5) }
    content { '素晴らしい演出と感動のストーリーでした。' }

    trait :with_event do
      event
    end

    trait :with_user do
      user
    end
  end
end
