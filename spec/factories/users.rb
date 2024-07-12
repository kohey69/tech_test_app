FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    confirmed_at { Time.zone.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
