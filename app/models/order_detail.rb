class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  before_save :total_price
  after_create :update_quantity_for_product

  private
  def total_price
    self.price = product.price * quantity
  end
  
  def unit_price
    product.price
  end

  def update_quantity_for_product
    product.update(quantity: product.quantity - quantity)
  end
end
