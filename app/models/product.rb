class Product < ApplicationRecord
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_one_attached :image
  scope :filter_by_category, -> (category){where category_id: category}
  scope :filter_by_price, -> (order){ order(price: order) }
  scope :filter_by_rate, -> (order){ order(rating: order)}
  scope :filter_by_name, -> (order){ order(name: order)}
  belongs_to :category

  accepts_nested_attributes_for :category

  scope :filter_by_name, ->(keyword){where "name LIKE ?", "%#{keyword}%"}
  scope :order_by, ->(keyword){order keyword}

  OPTION = {
    all: 1,
    oldest: 2,
    newest: 3,
    price_asc: 4,
    price_desc: 5
  }.freeze

  PRO_ATS = %w(name price rating description image quantity category_id).freeze

  validates :name, presence: true,
    length: {maximum: Settings.length.len_50}
  validates :price, presence: true,
    numericality: {only_decimal: true}
  validates :description, presence: true
  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: Settings.min.quantity}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
    message: "must be a valid image format" },
    size: { less_than: 5.megabytes,
    message: "should be less than 5MB" }

  def display_image_admin
    image.variant resize_to_limit: [300, 200]
  end
end
