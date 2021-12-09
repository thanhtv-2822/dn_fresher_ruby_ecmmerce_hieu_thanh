category = ["Apple", "Samsung", "Xiaomi"]

User.create(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true
)

User.create!(name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar")
  99.times do |n|
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
