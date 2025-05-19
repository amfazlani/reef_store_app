class Ingredient < ApplicationRecord
  belongs_to :item

  validates :name, presence: true
  validates :quantity, presence: true
end
