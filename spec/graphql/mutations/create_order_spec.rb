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
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: 1}) {
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
  end

  it "creates an order with loaded cart" do
    quantity = Product.first.units
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 3, productId: 1, customerId: 1}) {
                customerCart {
                  totalPrice
                  cartItems {
                    id
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
    ProtelEcommerceSchema.execute(query)
    ProtelEcommerceSchema.execute(query)
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: 1}) {
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
    expect(Product.first.units).to eq(quantity-6)
  end

  it "fails to create an order with excessive quantity of products" do
    quantity = Product.first.units
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 10000, productId: 1, customerId: 1}) {
                customerCart {
                  totalPrice
                  cartItems {
                    id
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
    ProtelEcommerceSchema.execute(query)
    query =<<~GQL
            mutation {
                createOrder(input:{customerId: 1}) {
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
  end
end