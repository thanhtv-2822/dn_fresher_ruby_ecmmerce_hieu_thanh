class ProductsController < ApplicationController
  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end
end
