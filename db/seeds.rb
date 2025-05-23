# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Store.count.zero?
  5.times do |i|
    @store = Store.create(name: Faker::Company.name, address: Faker::Address.full_address, place_id: "place_id_#{ id + 1 }")

    5.times do
      @item = @store.items.create(name: Faker::Lorem.word, price: Faker::Number.decimal(l_digits: 2))

      5.times do
        @item.ingredients.create(name: Faker::Lorem.word, quantity: Faker::Number.number(digits: 1))
      end
    end
  end
end
