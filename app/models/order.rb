class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  before_save :status_default

  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3}

  private
  def status_default
    self.status ||= 0
  end
end
