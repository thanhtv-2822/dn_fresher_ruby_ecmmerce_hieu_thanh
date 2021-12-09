class Order < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true
  belongs_to :address, optional: true
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  scope :order_by_updated_at, ->{order(updated_at: "DESC")}
  scope :filter_by_customer, ->(name){Order.joins("INNER JOIN users
    ON orders.user_id = users.id
    AND users.name LIKE %#{name}%")}
  scope :filter_by_status, -> (status){where status: status}
  before_create :set_status
  before_update :check_payment_address
  enum status: {pending: 0, accept: 1, resolved: 2, rejected: 3}

  STATUS = %w(:status).freeze

  def get_total
    total = 0
    self.order_details.each do |order_details|
      total += order_details.price
    end
    return total
  end

  private

  def set_status
    self.status = 0
  end

  def check_payment_address
    return if payment_id.present? && address_id.present?

    raise I18n.t("select_payment")
  end
end
