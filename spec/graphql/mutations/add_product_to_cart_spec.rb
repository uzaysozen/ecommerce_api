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
    query = <<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: 1, customerId: 1}) {
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
    expect(result.dig("data", "addProductToCart", "customerCart", "cartItems").size).to eq(1)
    expect(result.dig("data", "addProductToCart", "customerCart", "cartItems")[0].dig("quantity")).to eq(1)
    expect(result.dig("data", "addProductToCart", "customerCart", "totalPrice")).to eq(result.dig("data", "addProductToCart", "customerCart", "cartItems")[0].dig("product", "price"))
  end

  it "adds a product to loaded cart" do
    query =<<~GQL
            mutation {
              addProductToCart(input: {quantity: 1, productId: 1, customerId: 1}) {
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
    expect(result.dig("data", "addProductToCart", "customerCart", "cartItems").size).to eq(1)
    expect(result.dig("data", "addProductToCart", "customerCart", "cartItems")[0].dig("quantity")).to eq(2)
    expect(result.dig("data", "addProductToCart", "customerCart", "totalPrice")).to eq(result.dig("data", "addProductToCart", "customerCart", "cartItems")[0].dig("product", "price") * 2)
  end
end