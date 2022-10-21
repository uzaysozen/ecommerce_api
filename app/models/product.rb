class Product < ApplicationRecord
  has_many :order_items
  has_many :cart_items
  validates :units, numericality: { greater_than_or_equal_to: 0 }
end
