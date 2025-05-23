class Store < ApplicationRecord
  has_many :items

  validates :name, presence: true
  validates :address, presence: true
  validates :place_id, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }
end
