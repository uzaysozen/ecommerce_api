module Types
  class QueryType < Types::BaseObject
   
    # /customers
    field :customers, [Types::CustomerType], null: false

    def customers
      Customer.all
    end

    field :customer, Types::CustomerType, null: false do
      argument :id, ID, required: true
    end

    def customer(id:) 
      Customer.find(id)
    end

    field :customer_orders, [Types::OrderType], null: false do
      argument :id, ID, required: true
      argument :recent, Integer, required: true
    end

    def customer_orders(id:, recent:) 
      Customer.find(id).orders.first(recent)
    end

    field :orders, [Types::OrderType], null: false

    def orders
      Order.all
    end
  end
end
