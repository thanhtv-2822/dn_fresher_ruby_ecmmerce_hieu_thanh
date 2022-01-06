FactoryBot.define do
  factory :order do
    description {Faker::Lorem.sentence}
    status {rand(Order.statuses.values.first..Order.statuses.values.last)}
    user {FactoryBot.create :user }
    payment {FactoryBot.create :payment}
    address {FactoryBot.create :address}
  end
end
