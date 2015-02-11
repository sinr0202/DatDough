require 'faker'

FactoryGirl.define do
  factory :expense do
    date { Faker::Date.between(2.days.ago, Date.today) }
    price { Faker::Commerce.price }
    desciption { Faker::Lorem.paragraph }
  end
end
