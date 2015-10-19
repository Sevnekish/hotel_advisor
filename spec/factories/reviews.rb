FactoryGirl.define do
  factory :review do
    rating     { Faker::Number.between(1, 5) }
    body       { Faker::Lorem.sentence(3) }
    user       { create(:user) }
    hotel      { create(:hotel) }
    created_at { Faker::Date.between(2.days.ago, Date.today) }
  end
end