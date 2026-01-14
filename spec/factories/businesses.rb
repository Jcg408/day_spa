FactoryBot.define do
  factory :business do
    name { Faker::Company.name }
    active { true }
  end
end
