FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    address { Faker::Address.full_address }
    sequence(:place_id) { |n| "place_id_#{n}" }
  end
end
