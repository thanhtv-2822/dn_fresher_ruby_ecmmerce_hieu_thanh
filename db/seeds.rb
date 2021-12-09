User.create(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true
)
category = ["Dell", "Hp", "Lenovo"]

3.times do |n|
  Category.create(name: category[n])
end

5.times do |n|
  Category.create(
    name: category[0] + "-#{n}",
    parent_id: 1
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
    is_admin: false
  )
  end

10.times do
  Product.create(
    name: Faker::Name.first_name,
    description: Faker::Lorem.sentence,
    price: 120000,
    category_id: 4,
    quantity: 10,
    rating: 5
  )
end

Payment.create(
  name: "MoMo"
)

Payment.create(
  name: "COD"
)

Payment.create(
  name: "Internet Banking"
)
