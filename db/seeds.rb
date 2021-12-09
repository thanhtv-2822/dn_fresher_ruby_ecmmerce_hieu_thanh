# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
category = ["Apple", "Samsung", "Xiaomi"]

3.times do |n|
  name = category[n-1]
  price = 12000000
  description = Faker::Lorem.sentence
  quantity = 5
  Product.create(
    name: name,
    price: price,
    description: description,
    quantity: quantity
  )
end
