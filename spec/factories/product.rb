FactoryBot.define do
  factory :product do |f|
    f.name {Faker::Name.name_with_middle}
    f.price {Faker::Number.number(digits: 7)}
    f.rating {1}
    f.description {Faker::Lorem.sentence}
    f.category {FactoryBot.create(:category)}
  end
end
