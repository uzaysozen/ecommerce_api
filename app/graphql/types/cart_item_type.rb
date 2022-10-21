# frozen_string_literal: true

module Types
  class CartItemType < Types::BaseObject
    field :id, ID, null: false
    field :quantity, Integer
    field :product_id, Integer, null: false
    field :cart_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :product, Types::ProductType, null: false
    field :cart, Types::CartType, null: false
  end

  def product
    Product.find(object.product_id)
  end

  def cart
    Cart.find(object.cart_id)
  end
end
