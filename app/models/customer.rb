class Customer < ApplicationRecord
    has_many :carts
    has_many :orders
end
