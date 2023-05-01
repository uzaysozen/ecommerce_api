require 'rails_helper'
require 'faker'

RSpec.describe "customer query" do
    before(:all) do
        Rails.application.load_seed
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end

    it "returns all customers" do
        query = <<~GQL
                {
                    customers {
                        id
                        surname
                        email
                        phoneNumber
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "customers").size).to eq(5)
    end

    it "returns first customer" do
        customer = Customer.first
        query = <<~GQL
                {
                    customer(customerId:#{customer.id}) {
                        id
                        surname
                        email
                        phoneNumber
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "customer", "id").to_i).to eq(customer.id)
    end

    it "returns last customer" do
        customer = Customer.first
        query = <<~GQL
                {
                    customer(customerId:#{customer.id}) {
                        id
                        surname
                        email
                        phoneNumber
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "customer", "id").to_i).to eq(customer.id)
    end

    it "returns customer's recent orders" do
        customer = Customer.first
        product = Product.first
        5.times do
            order = Customer.first.orders.create(total_price: 0)
            order.order_items.create(quantity: 3, product_id: product.id)
        end
        query = <<~GQL
                {
                    customerRecentOrders(customerId:1) {
                        createdAt
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "customerRecentOrders").size).to eq(5)
    end
end