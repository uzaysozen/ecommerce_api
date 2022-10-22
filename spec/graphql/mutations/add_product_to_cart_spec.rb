require 'rails_helper'
require 'faker'

RSpec.describe "add product to cart" do
  before(:all) do
    Rails.application.load_seed
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  it "adds a product to empty cart" do
    customer = Customer.first
    product = Product.first
    query = <<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: #{product.id}, customerId: #{customer.id}}) {
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
    result = ProtelEcommerceSchema.execute(query)
    cart_items_response = result.dig("data", "addProductToCart", "customerCart", "cartItems")
    expect(cart_items_response.size).to eq(1)
    expect(cart_items_response[0].dig("quantity")).to eq(1)
    expect(result.dig("data", "addProductToCart", "customerCart", "totalPrice")).to eq(cart_items_response[0].dig("product", "price"))
    expect(customer.cart.cart_items.size).to eq(1)
  end

  it "adds a product to loaded cart (same product)" do
    customer = Customer.first
    product = Product.first
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: #{product.id}, customerId: #{customer.id}}) {
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
    # add 2 times
    ProtelEcommerceSchema.execute(query)
    result = ProtelEcommerceSchema.execute(query)
    cart_items_response = result.dig("data", "addProductToCart", "customerCart", "cartItems")
    expect(cart_items_response.size).to eq(1)
    expect(cart_items_response[0].dig("quantity")).to eq(2)
    expect(result.dig("data", "addProductToCart", "customerCart", "totalPrice")).to eq(cart_items_response[0].dig("product", "price") * 2)
    expect(customer.cart.cart_items.size).to eq(1)
  end
  it "adds a product to loaded cart (different products)" do
    customer = Customer.first
    product = Product.first
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: #{product.id}, customerId: #{customer.id}}) {
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
    product = Product.last
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: #{product.id}, customerId: #{customer.id}}) {
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
    result = ProtelEcommerceSchema.execute(query)
    cart_items_response = result.dig("data", "addProductToCart", "customerCart", "cartItems")
    expect(cart_items_response .size).to eq(2)
    expect(cart_items_response[0].dig("quantity")).to eq(1)
    expect(cart_items_response[1].dig("quantity")).to eq(1)
    
    expected_price = ((cart_items_response[0].dig("product", "price") * 1) + (cart_items_response[1].dig("product", "price") * 1))
    expect(result.dig("data", "addProductToCart", "customerCart", "totalPrice")).to eq(expected_price)
    expect(customer.cart.cart_items.size).to eq(2)
  end
end