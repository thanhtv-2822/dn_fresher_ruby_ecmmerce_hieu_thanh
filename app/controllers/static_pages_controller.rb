class StaticPagesController < ApplicationController
  def home
    @pagy, @products = pagy(Product.all, items: 5)
    @categories = Category.all
    filtering_params(params).each do |key, value|
      @products = @products.public_send("filter_by_#{key}", value) if value.present?
    end
  end

  def help; end

  private

  def filtering_params(params)
    params.slice(:category, :price, :rate)
  end


end
