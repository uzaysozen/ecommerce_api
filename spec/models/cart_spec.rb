require 'rails_helper'

RSpec.describe Cart, type: :model do
  it "can create" do
    customer = Customer.create(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    cart= Cart.new(customer_id: customer.id, total_price: 0)
    expect(cart.save).to be(true)
  end
end
