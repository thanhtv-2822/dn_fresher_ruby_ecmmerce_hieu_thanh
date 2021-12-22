class OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      create_order
      flash[:success] = t "errors.order_create"
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "errors.record_invalid"
    redirect_to carts_path
  end

  private
  def create_order_detail
    @carts = get_all_item_in_cart
    @carts.each do |item|
      @order.order_details.build(
        product_id: item["product"]["id"],
        quantity: item["quantity"]
      )
    end
  end

  def update_rating_product
    @carts.each do |item|
      if (1..5).include?(item["rating"].to_i)
        product = Product.find_by id: item["product"]["id"]
        rating = ((product.rating + item["rating"].to_i) / 2).round(1)
        product.update(rating: rating)
      end
      next
    end
  end

  def create_order
    @order = current_user.orders.build
    create_order_detail
    update_rating_product
    @order.save!
    session.delete :cart
  end
end
