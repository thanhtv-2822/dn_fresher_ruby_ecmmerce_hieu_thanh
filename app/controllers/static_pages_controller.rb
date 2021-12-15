class StaticPagesController < ApplicationController
  def home
    @pagy, @products = pagy(Product.all, items: 5)
    @categories = Category.all
  end

  def help; end
end
