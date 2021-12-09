category = ["Apple", "Samsung", "Xiaomi"]

User.create(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true
)

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

User.create!(name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar")
  20.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
  )
  end

3.times do |n|
  Category.create(name: category[n-1])
end
