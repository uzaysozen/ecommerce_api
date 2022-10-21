# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Seeding database..."


10.times do 
    Product.create(
        name: Faker::Commerce.product_name,
        price: Faker::Number.decimal(l_digits: 2),
        units: Faker::Number.number(digits: 3)
    )
end

5.times do
    Customer.create(
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        email: Faker::Internet.email,
        phone_number: Faker::PhoneNumber.cell_phone
    )
end

puts "Seeding done."