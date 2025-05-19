FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "#{Faker::Company.name}#{n}" }
    price { Faker::Number.decimal(l_digits: 2) }

    store
  end
end
