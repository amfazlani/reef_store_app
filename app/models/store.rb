class Store < ApplicationRecord
  has_many :items

  validates :name, presence: true
  validates :address, presence: true

  scope :ordered, -> { order(:name) }
end
