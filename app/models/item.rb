class Item < ApplicationRecord
  has_many :ingredients

  validates :name, presence: true
  validates :price, presence: true
end
