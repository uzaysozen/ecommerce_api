class Mutations::AddProductToCart < Mutations::BaseMutation
    argument :customer_id, ID, required: true
    argument :product_id, ID, required: true
    argument :quantity, Integer, required: true

    field :customer_cart, Types::CartType, null: true
    field :response, String, null: false

    def resolve(customer_id:, product_id:, quantity:)
        customer = Customer.find(customer_id) # get customer
        product = Product.find(product_id) # get product
        existing_cart_item = nil 
        existing_quantity = 0
        customer.cart.update_attribute(:total_price, customer.cart.total_price + (product.price * quantity)) # update total cart price

        customer.cart.cart_items.each do |cart_item| # if product already exists in cart, get cart item and quantity data
            if cart_item.product_id == product_id.to_i
                existing_cart_item = cart_item
                existing_quantity = existing_cart_item.quantity
                break
            end
        end
        
        if existing_cart_item.nil? # if product does not exist in cart, create new cart item with product
            new_cart_item = CartItem.new(quantity: quantity, product_id: product_id, cart_id: customer.cart.id)
            if !new_cart_item.save
                return {
                    customer_cart: nil,
                    response: "Product cannot be added to the cart"
                }
            end
        else # if product exists, existing cart item's increase quantity
            existing_cart_item.update_attribute(:quantity, existing_cart_item.quantity + quantity) 
        end

        customer_cart = Cart.find(customer.cart.id) # get updated customer cart
        
        return { 
            customer_cart: customer_cart,
            response: "Product added to the cart successfully"
        }
       
    end
end