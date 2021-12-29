FactoryBot.define do
  factory :address do
    phone {Faker::Number.number(digits: 11)}
    street {Faker::Name.first_name}
    commune {Faker::Name.middle_name}
    district {Faker::Name.last_name}
    city {Faker::Name.initials(number: 20)}
    user {FactoryBot.create :user}
  end
end
