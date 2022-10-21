# frozen_string_literal: true

module Types
  class CustomerType < Types::BaseObject
    field :id, ID, null: false
    field :email, String
    field :name, String
    field :surname, String
    field :phone_number, String
    field :orders, [Types::OrderType]
    field :carts, [Types::CartType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
