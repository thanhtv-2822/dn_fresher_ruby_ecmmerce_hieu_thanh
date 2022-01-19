class Api::V1::ProductsController < ApplicationController
  before_action :authentication!
  skip_before_action :verify_authenticity_token
  before_action :find_product, only: %i(show destroy update)

  def index
    @products = Product.includes(:category)
    render_json :data, @products, :ok
  end

  def show
    render_json :data, @product, :ok
  end

  def create
    product = Product.new product_params
    return unless product.save

    render_json :data, product, :created
  end

  def update
    return unless @product.update product_params

    render_json :data, @product, :ok
  end

  def destroy
    return unless @product.destroy

    head :no_content
  end

  private
  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    render_json :message, t("product.not_found"), :not_found
  end

  def product_params
    params.require(:product).permit(Product::PRO_ATS)
  end
end
