class Mutations::AddProductToCart < Mutations::BaseMutation
    argument :customer_id, ID, required: true
    argument :product_id, ID, required: true
    argument :quantity, Integer, required: true

    field :customer_cart, Types::CartType, null: true
    field :response, String, null: false

    def resolve(customer_id:, product_id:, quantity:)
        customer = Customer.find(customer_id)
        product = Product.find(product_id)
        existing_cart_item = nil
        existing_quantity = 0
        customer.cart.update_attribute(:total_price, customer.cart.total_price + (product.price * quantity))

        customer.cart.cart_items.each do |cart_item|
            if cart_item.product_id == product_id.to_i
                existing_cart_item = cart_item
                existing_quantity = existing_cart_item.quantity
                break
            end
        end
        
        if existing_cart_item.nil? 
            new_cart_item = CartItem.new(quantity: quantity, product_id: product_id, cart_id: customer.cart.id)
            if !new_cart_item.save
                return {
                    customer_cart: nil,
                    response: "Product cannot be added to the cart"
                }
            end
        else
            new_quantity = existing_cart_item.quantity + quantity
            existing_cart_item.update_attribute(:quantity, new_quantity)
        end

        customer = Customer.find(customer_id)
        
        return {
            customer_cart: customer.cart,
            response: "Product added to the cart successfully"
        }
       
    end
end