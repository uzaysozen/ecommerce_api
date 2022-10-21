# frozen_string_literal: true

module Types
  class CartType < Types::BaseObject
    field :id, ID, null: false
    field :customer_id, Integer, null: false
    field :total_price, Float
    field :cart_items, [Types::CartItemType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
