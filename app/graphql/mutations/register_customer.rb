class Mutations::RegisterCustomer < Mutations::BaseMutation
    argument :name, String, required: true
    argument :surname, String, required: true
    argument :email, String, required: true
    argument :phone_number, String, required: true

    field :response, String, null: false

    def resolve(name:, surname:, email:, phone_number:)
        customer = Customer.new(name: name, surname: surname, email: email, phone_number: phone_number) # create customer
        
        if customer.save # check if fields are correct
            return {
                response: "Customer registered successfully."
            }
        else
            return {
                response: customer.errors.full_messages[0]
            }
        end
    end
end