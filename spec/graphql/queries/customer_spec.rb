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
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "customers").size).to eq(5)
    end

    it "returns first customer" do
        query = <<~GQL
                {
                    customer(customerId:1) {
                        id
                        surname
                        email
                        phoneNumber
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "customer", "id")).to eq("1")
    end

    it "returns customer's recent orders" do
        5.times do
            order = Customer.first.orders.create(customer_id: 1, total_price: 0)
            order.order_items.create(order_id: 1, quantity: 3, product_id: 1)
        end
        query = <<~GQL
                {
                    customerRecentOrders(customerId:1) {
                        createdAt
                    }
                }
                GQL
        result = ProtelEcommerceSchema.execute(query)
        expect(result.dig("data", "customerRecentOrders").size).to eq(5)
    end
end