FactoryBot.define do
  factory :category do |f|
    f.name {Faker::Name.first_name}
    f.parent_id {Category.first&.id || nil}
  end
end
