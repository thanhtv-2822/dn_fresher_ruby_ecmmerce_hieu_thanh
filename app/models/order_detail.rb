class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  before_save :calcular_total_price
  after_create :change_product_quantity_down
  after_destroy :change_product_quantity_up

  private

  def unit_price
    product.price
  end

  def calcular_total_price
    self.price = quantity * unit_price
  end

  def change_product_quantity_down
    product.update(quantity: product.quantity - quantity)
  end

  def change_product_quantity_up
    product.update(quantity: product.quantity + quantity)
  end
end
