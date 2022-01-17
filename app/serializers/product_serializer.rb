class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :rating, :description, :quantity
  belongs_to :category
end
