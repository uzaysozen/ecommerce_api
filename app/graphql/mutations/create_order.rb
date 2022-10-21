class Mutations::CreateOrder < Mutations::BaseMutation
    argument :customer_id, ID, required: true

    field :response, String, null: false
    field :order, Types::OrderType, null: true

    def resolve(customer_id:)
        customer = Customer.find(customer_id)

        if customer.cart.cart_items.empty?
            return {
                order: nil,
                response: "Your cart is empty."
            }
        end

        order = customer.orders.new(total_price: 0)

        if customer.cart.cart_items.any?{|cart_item| cart_item.quantity > cart_item.product.units }
            return {
                order: nil,
                response: "Sorry, we do not have stock for the quantity of the products you want. Unable to create order."
            }
        else
            customer.cart.cart_items.each do |cart_item|
                cart_item.product.update_attribute(:units, cart_item.product.units - cart_item.quantity)
                order.update_attribute(:total_price, order.total_price + (cart_item.product.price * cart_item.quantity))
                order.order_items.create(quantity: cart_item.quantity, product_id: cart_item.product.id)
            end
        end

        if order.save
            customer.cart.update_attribute(:total_price, 0)
            customer.cart.cart_items.destroy_all
            
            CustomerMailer.with(customer: customer, order: order).successful_order.deliver_now

            return {
                order: order,
                response: "Order created succesfully"
            }
        else
            return {
                order: nil,
                response: order.errors.full_messages[0]
            }
        end
    end
end