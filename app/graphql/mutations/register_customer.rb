class Mutations::RegisterCustomer < Mutations::BaseMutation
    argument :name, String, required: true
    argument :surname, String, required: true
    argument :email, String, required: true
    argument :phone_number, String, required: true

    field :customer, Types::CustomerType, null: false
    field :errors, [String], null: false
    field :message, String, null: false

    def resolve(name:, surname:, email:, phone_number:)
        customer = Customer.new(name: name, surname: surname, email: email, phone_number: phone_number)
        if customer.save
            {
                customer: customer,
                errors: []
            }
        else
            {
                customer: nil,
                errors: customer.errors.full_messages,
                message: "Try again"
            }
        end
    end
end