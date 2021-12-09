class ProductsController < ApplicationController
  before_action :check_product, only: :show
  def show
    return unless logged_in?
    return if check_item @product

    check_recently_product @product
  end

  private
  def check_item item
    return true if recently_product.include? item.id

    false
  end

  def check_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end

  def check_recently_product product
    recently_product.shift if recently_product.length >= 4
    recently_product << product.id
  end
end
