# frozen_string_literal: true

module Types
  class OrderItemType < Types::BaseObject
    field :id, ID, null: false
    field :quantity, Integer
    field :product_id, Integer, null: false
    field :order_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :product, Types::ProductType, null: false
    field :order, Types::OrderType, null: false

    def product
      Product.find(object.product_id)
    end

    def order
      Order.find(object.order_id)
    end
  end
end
