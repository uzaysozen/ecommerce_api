require 'rails_helper'

RSpec.describe Customer, type: :model do
  it 'has valid info' do
    customer = Customer.new(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    expect(customer.save).to be(true)
  end

  it 'has a cart' do
    customer = Customer.create(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    expect(customer.cart).not_to be(nil)
  end

  it 'has no name' do
    customer = Customer.new(name:"", surname: "Doe", email: "johndoe@mail.com", phone_number: "(133)-437281")
    expect(customer.save).to be(false)
  end

  it 'has no surname' do
    customer = Customer.new(name:"John", surname: "", email: "johndoe@mail.com", phone_number: "(133)-437281")
    expect(customer.save).to be(false)
  end

  it 'has no email' do
    customer = Customer.new(name:"John", surname: "Doe", email: "", phone_number: "(133)-437281")
    expect(customer.save).to be(false)
  end

  it 'has no phone number' do
    customer = Customer.new(name:"John", surname: "Doe", email: "johndoe@mail.com", phone_number: "")
    expect(customer.save).to be(false)
  end

  it 'has no valid email' do
    customer = Customer.new(name:"John", surname: "Doe", email: "jhn", phone_number: "(133)-437281")
    expect(customer.save).to be(false)
  end
end
