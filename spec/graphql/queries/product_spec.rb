require 'rails_helper'
require 'faker'

RSpec.describe "product query" do
    before(:all) do
        Rails.application.load_seed
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end

    it "returns all products" do
        query = <<~GQL
                {
                    products {
                        id
                        name
                        price
                        units
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "products").size).to eq(10)
    end

    it "returns first product" do
        product = Product.first
        query = <<~GQL
                {
                    product(productId:#{product.id}) {
                        id
                        name
                        price
                        units
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "product", "id").to_i).to eq(product.id)
    end

    it "returns last product" do
        product = Product.last
        query = <<~GQL
                {
                    product(productId:#{product.id}) {
                        id
                        name
                        price
                        units
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "product", "id").to_i).to eq(product.id)
    end
end