class CustomerMailerPreview < ActionMailer::Preview
    def successful_order
        CustomerMailer.with(customer: Customer.first, order: Customer.first.orders.first).successful_order
    end
end