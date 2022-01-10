class StaticPagesController < ApplicationController
  before_action :high_rating_product_and_category, only: :home
  def home
    @q = Product.ransack(
      params[:q].try(:merge, m: "or"),
      auth_object: set_ransack_auth_object
    )
    if params[:q]
      @pagy, @products = pagy(
        @q.result.includes(:category),
        items: Settings.page.size_medium
      )
    else
      filter_product
    end
    @recent_product = Product.where(id: recently_product)
  end

  def help; end

  private

  def filtering_params params
    params.slice(:category, :price, :rate, :name, :type)
  end

  def set_ransack_auth_object
    current_user&.is_admin? ? :admin : nil
  end

  def high_rating_product_and_category
    @high_rating_product = Product.filter_by_rate(:desc)
                                  .limit(Settings.page.size_medium)
    @categories = Category.where(parent_id: [nil, ""])
  end

  def filter_product
    @pagy, @products = pagy(Product.all, items: Settings.page.size_medium)
    filtering_params(params).each do |key, value|
      @products = @products.public_send("filter_by_#{key}", value) if value
    end
  end
end
