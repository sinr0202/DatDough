require 'faker'

FactoryGirl.define do
  factory :expense do
    date { Faker::Date.between(2.days.ago, Date.today) }
    amount { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
  end
end
