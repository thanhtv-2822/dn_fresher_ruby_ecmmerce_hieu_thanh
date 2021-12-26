class StaticPagesController < ApplicationController
  def home
    @pagy, @products = pagy(Product.all, items: Settings.product_per_page)
    @categories = Category.all
    filtering_params(params).each do |key, value|
      if value.present?
        @products = @products.public_send("sort_by_#{key}", value)
      end
    end
  end
end
