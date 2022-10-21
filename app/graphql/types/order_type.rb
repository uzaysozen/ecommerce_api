# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :customer_id, Integer, null: false
    field :total_price, Float
    field :order_items, [Types::OrderItemType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def order_items
      Order.find(object.id).order_items
    end
  end
end
