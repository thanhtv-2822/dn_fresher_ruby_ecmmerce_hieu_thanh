class Admin::ProductsController < Admin::BaseController
  def index
    @pagy, @products = pagy(Product.all, items: 5)
  end

  def show; end

  def destroy; end

  def edit; end
end
