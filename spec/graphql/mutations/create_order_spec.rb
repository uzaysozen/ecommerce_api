require 'rails_helper'
require 'faker'

RSpec.describe "create order" do
  before(:all) do
    Rails.application.load_seed
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  it "creates an order with empty cart" do
    customer = Customer.first
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: #{customer.id}}) {
                order {
                    totalPrice
                    orderItems {
                    quantity
                    product {
                        name
                        price
                    }
                    }
                }
                response
                }
            }
            GQL
    result = ProtelEcommerceSchema.execute(query)
    expect(result.dig("data", "createOrder", "response")).to eq("Your cart is empty.")
    expect(result.dig("data", "createOrder", "order")).to be(nil)
    expect(customer.orders.size).to eq(0)
    expect(customer.cart.cart_items.size).to eq(0)
  end

  it "creates an order with loaded cart (one product)" do
    product = Product.first
    quantity = product.units
    customer = Customer.first
    customer.cart.cart_items.create(quantity: 5, product_id: product.id)
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: #{customer.id}}) {
                order {
                    totalPrice
                    orderItems {
                    quantity
                    product {
                        name
                        price
                    }
                    }
                }
                response
                }
            }
            GQL
    result = ProtelEcommerceSchema.execute(query)
    expect(result.dig("data", "createOrder", "response")).to eq("Order created succesfully")
    expect(Product.first.units).to eq(quantity-5)
    expect(customer.orders.size).to eq(1)
    expect(customer.cart.cart_items.size).to eq(0)
  end

  it "creates an order with loaded cart (multiple products)" do
    products = Product.first(5)
    quantities = []
    customer = Customer.first
    for i in 0...5 do
        customer.cart.cart_items.create(quantity: 5, product_id: products[i].id)
        quantities << products[i].units
    end
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: #{customer.id}}) {
                order {
                    totalPrice
                    orderItems {
                    quantity
                    product {
                        name
                        price
                    }
                    }
                }
                response
                }
            }
            GQL
    result = ProtelEcommerceSchema.execute(query)
    products = Product.first(5)
    expect(result.dig("data", "createOrder", "response")).to eq("Order created succesfully")
    for i in 0...5 do
        expect(products[i].units).to eq(quantities[i]-5)
    end
    expect(customer.orders.size).to eq(1)
    expect(customer.orders.first.order_items.size).to eq(5)
    expect(customer.cart.cart_items.size).to eq(0)
  end

  it "fails to create an order with excessive quantity of products" do
    product = Product.first
    quantity = product.units
    customer = Customer.first
    customer.cart.cart_items.create(quantity: 10000, product_id: product.id)
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: #{customer.id}}) {
                order {
                    totalPrice
                    orderItems {
                    quantity
                    product {
                        name
                        price
                    }
                    }
                }
                response
                }
            }
            GQL
    result = ProtelEcommerceSchema.execute(query)
    expect(result.dig("data", "createOrder", "response")).to eq("Sorry, we do not have stock for the quantity of the products you want. Unable to create order.")
    expect(result.dig("data", "createOrder", "order", "orderItems")).to be(nil)
    expect(Product.first.units).to eq(quantity)
    expect(customer.orders.size).to eq(0)
    expect(customer.cart.cart_items.size).to eq(1)
  end
end