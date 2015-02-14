require 'faker'

FactoryGirl.define do
  factory :expense do
    date { Faker::Date.between(100.days.ago, Date.today) }
    amount { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
    category { rand(0..12) }
    transaction_type { rand(0..3) }
    payment_method { rand(0..4) }

  end
end
