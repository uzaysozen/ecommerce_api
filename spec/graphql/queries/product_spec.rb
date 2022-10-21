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
        query = <<~GQL
                {
                    product(productId:1) {
                        id
                        name
                        price
                        units
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "product", "id")).to eq("1")
    end
end