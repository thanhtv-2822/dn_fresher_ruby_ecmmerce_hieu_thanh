class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
  belongs_to :payment, optional: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  before_save :status_default
  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3}
end
