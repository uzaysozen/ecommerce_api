require 'rails_helper'
require 'faker'

RSpec.describe "register customer" do
    before(:all) do
        Rails.application.load_seed
    end
    after(:all) do
        DatabaseCleaner.clean_with(:truncation)
    end
    it "returns a message when registering is successful" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "John", surname: "Doe", email: "johndoe@mail.com", phoneNumber: "24342536"}
                    ) {
                    response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Customer registered successfully.")
    end

    it "returns an error message when name is missing" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "", surname: "Doe", email: "johndoe@mail.com", phoneNumber: "(234)-24542512"}
                    ) {
                        response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Name can't be blank")
    end

    it "returns an error message when surname is missing" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "John", surname: "", email: "johndoe@mail.com", phoneNumber: "(234)-24542512"}
                    ) {
                        response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Surname can't be blank")
    end

    it "returns an error message when email is missing" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "John", surname: "Doe", email: "", phoneNumber: "(234)-24542512"}
                    ) {
                        response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Email can't be blank")
    end

    it "returns an error message when phone number is missing" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "John", surname: "Doe", email: "johndoe@mail.com", phoneNumber: ""}
                    ) {
                        response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Phone number can't be blank")
    end

    it "returns an error message when email is invalid" do
        query = <<~GQL
                mutation {
                    registerCustomer(
                        input: {name: "John", surname: "Doe", email: "123123", phoneNumber: ""}
                    ) {
                        response
                    }
                }
                GQL
        result = EcommerceApiSchema.execute(query)
        expect(result.dig("data", "registerCustomer", "response")).to eq("Email is invalid")
    end
end