class Product < ApplicationRecord
  belongs_to :inventory
  has_many :order_items
  has_many :cart_items
end
