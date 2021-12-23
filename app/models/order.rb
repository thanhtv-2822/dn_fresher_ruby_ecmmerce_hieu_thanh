class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment
  belongs_to :address
  accepts_nested_attributes_for :address, update_only: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  before_save :status_default
  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3}

  def get_total
    total = 0
    self.order_details.each do |order_details|
      total += order_details.price
    end
    return total
  end

  private

  enum status: {pending: 0, resolved: 1, rejected: 2}
end
