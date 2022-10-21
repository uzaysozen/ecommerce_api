class Customer < ApplicationRecord
    has_one :cart
    has_many :orders
    validates :name, presence: true
    validates :surname, presence: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_number, presence: true
    after_save :create_cart

    def create_cart
        Cart.create(customer_id: self[:id], total_price: 0)
    end
end
