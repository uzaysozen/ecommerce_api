module Types
  class MutationType < Types::BaseObject
    field :register_customer, mutation: Mutations::RegisterCustomer
    field :add_product_to_cart, mutation: Mutations::AddProductToCart
    field :create_order, mutation: Mutations::CreateOrder
  end
end
