FactoryBot.define do
  factory :payment do
    name {Faker::Name.name_with_middle}
  end
end
