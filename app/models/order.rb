class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true
  belongs_to :address, optional: true
  accepts_nested_attributes_for :address, update_only: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  
  enum status: {pending: 0, accept: 1, rejected: 2}

  def get_total
    total = 0
    self.order_details.each do |order_details|
      total += order_details.price
    end
    return total
  end
end
