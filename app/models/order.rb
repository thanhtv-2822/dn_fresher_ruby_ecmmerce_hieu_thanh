class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :payment
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: {pending: 0, approved: 1, rejected: 2}
end
