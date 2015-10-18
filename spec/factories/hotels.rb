FactoryGirl.define do
  factory :hotel do
    title { Faker::Company.name }
    rating { Faker::Number.between(1, 5) }
    breakfast_included { [true, false].sample }
    room_description { Faker::Lorem.sentence(3) }
    room_price       { Faker::Commerce.price }
    user             { create (:user) }
  end
end