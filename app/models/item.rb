class Item < ApplicationRecord
  belongs_to :store
  has_many :ingredients

  validates :name, presence: true
  validates :price, presence: true
end
