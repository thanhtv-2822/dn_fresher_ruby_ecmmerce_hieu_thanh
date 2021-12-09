class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  before_save :calcular_total_price
  after_create :change_product_quantity

  private
  def unit_price
    product.price
  end

  def calcular_total_price
    self.price = quantity * unit_price
  end

  def change_product_quantity
    product.update(quantity: product.quantity - quantity)
  end
end
