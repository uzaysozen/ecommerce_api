require 'rails_helper'

RSpec.describe Product, type: :model do
    it "can create" do
      product = Product.new(name: "Test Product", price: "20", units: "500")
      expect(product.save).to be(true)
    end
end
