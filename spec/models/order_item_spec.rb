require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it "can create" do
    customer = Customer.create(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    order = Order.create(customer_id: customer.id, total_price: 0)
    product = Product.create(name: "Test Product", price: "20", units: "500")
    order_item = OrderItem.new(quantity: 5, order_id: order.id, product_id: product.id)
    expect(order_item.save).to be(true)
  end
end
