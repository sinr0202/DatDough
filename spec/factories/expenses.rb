require 'faker'

FactoryGirl.define do
  factory :expense do
    date { Faker::Date.between(100.days.ago, Date.today) }
    amount { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
    category { rand(0..16) }
    transaction_type { rand(0..1) }
    payment_method { rand(0..4) }
  end
end