FactoryBot.define do
  factory :event do
    title { 'LINE DC BOT AWARDS 2024' }
    description { '本コンテストはそれらのニーズに応え、新時代への道を切り開くLINE BOTを募集し、価値 × 新規性 × 技術の3軸で特に優れたサービスを表彰するものです。' }
    place { 'オンライン' }
    start_at { Time.zone.now.since(1.hour) }
    end_at { start_at.since(1.hour) }
    category { :business }
    published { true }

    trait :with_user do
      user
    end

    trait :unpublished do
      published { false }
    end

    trait :with_participation do
      after(:build) do |recipe|
        recipe.participations << build(:participation, :with_user)
      end
    end

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
