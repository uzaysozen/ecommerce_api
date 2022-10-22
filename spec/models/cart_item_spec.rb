require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it "can create" do
    customer = Customer.create(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    cart = Cart.create(customer_id: customer.id, total_price: 0)
    product = Product.create(name: "Test Product", price: "20", units: "500")
    cart_item = CartItem.new(quantity: 5, cart_id: cart.id, product_id: product.id)
    expect(cart_item.save).to be(true)
  end
end
