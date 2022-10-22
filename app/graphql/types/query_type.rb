module Types
  class QueryType < Types::BaseObject
    # Customers

    # get all customers
    field :customers, [Types::CustomerType], null: false

    def customers
      Customer.all
    end

    # get customer with customer id
    field :customer, Types::CustomerType, null: false do
      argument :customer_id, ID, required: true
    end

    def customer(customer_id:) 
      Customer.find(customer_id)
    end
    
    # get customer's recent orders
    field :customer_recent_orders, [Types::OrderType], null: false do
      argument :customer_id, ID, required: true
    end

    def customer_recent_orders(customer_id:) 
      Customer.find(customer_id).orders.order(created_at: :desc) # sort products by created_at date in descending order
    end

    # Products

    # get all products
    field :products, [Types::ProductType], null: false

    def products
      Product.all
    end

    # get product with product id
    field :product, Types::ProductType, null: false do
      argument :product_id, ID, required: true
    end

    def product(product_id:) 
      Product.find(product_id)
    end

  end
end
