FactoryBot.define do
  factory :event do
    title { 'LINE DC BOT AWARDS 2024' }
    description { '本コンテストはそれらのニーズに応え、新時代への道を切り開くLINE BOTを募集し、価値 × 新規性 × 技術の3軸で特に優れたサービスを表彰するものです。' }
    place { 'オンライン' }
    start_at { Time.zone.now }
    end_at { Time.zone.now }
    category { :business }

    trait :with_user do
      user
    end
  end
end
