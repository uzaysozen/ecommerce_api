# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Seeding database..."
priceList = Array.new(5) { |e| e = rand(11.2...76.9).round(2)}
puts priceList
puts priceList.sum
productList = Array.new


for pr in priceList do 
    product = Product.create(
        name: Faker::Commerce.product_name,
        price: pr,
        units: Faker::Number.number(digits: 2)
    )
    productList << product
end

5.times do
    customer = Customer.create(
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone_number: Faker::PhoneNumber.cell_phone
    )
end

5.times do
    for i in 1..5 do
        order = Order.create(
            customer_id: i,
            total_price: priceList.sum 
        )
        for j in 1..5
            order.order_items.create(
                product_id: j,
                quantity: 1
            )
        end
    end
end
 

5.times do
    for i in 1..5 do
        cart = Cart.create(
            customer_id: i,
            total_price: priceList.sum 
        )
        for j in 1..5 do
            cart.cart_items.create(
                product_id: j,
                quantity: 1
            )
        end
    end
end 


puts "Seeding done."