FactoryBot.define do
  factory :product do
    name { Faker::Team.name }
    price { Faker::Number.within(range: 0.0..100) }
    currency { Faker::Currency.code }
    quantity { Faker::Number.between(from: 1, to: 10) }
  end
end
