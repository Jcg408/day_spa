FactoryBot.define do
  factory :employee do
    association :business
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    bio { Faker::Lorem.paragraph(sentence_count: 2) }
    role { :staff }

    trait :admin do
      role { :admin }
    end

    trait :manager do
      role { :manager }
    end

    trait :staff do
      role { :staff }
    end
  end
end
