FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    quantity { Faker::Number.number(digits: 2) }

    item
  end
end
