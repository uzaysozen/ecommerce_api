class CustomerMailer < ApplicationMailer
    default from: 'ecommerceapi@mail.com'

    def successful_order
        @customer = params[:customer]
        @order = params[:order]
        mail(to: @customer.email, subject: 'Order Successful')
    end
end