class Product < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  scope :filter_by_category, -> (category){where category_id: category}
  scope :filter_by_price, -> (order){ order(price: order) }
  scope :filter_by_rate, -> (order){ order(rating: order)}
  scope :filter_by_name, -> (order){ order(name: order)}
  belongs_to :category
  validates :name, presence: true,
    length: {maximum: Settings.length.len_50}
  validates :price, presence: true,
    numericality: {only_decimal: true}
  validates :description, :image, presence: true
  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: Settings.min.quantity}
end
