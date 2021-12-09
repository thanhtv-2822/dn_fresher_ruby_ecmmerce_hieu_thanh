class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
  belongs_to :payment, optional: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  enum status: {pending: 0, resolved: 1, rejected: 2}
end
