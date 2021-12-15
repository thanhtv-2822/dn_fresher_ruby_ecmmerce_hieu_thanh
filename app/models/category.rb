class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :name, length: {maximum: Settings.length.len_20}
end
