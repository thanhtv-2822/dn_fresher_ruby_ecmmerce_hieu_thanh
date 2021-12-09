class OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @carts = get_all_item_in_cart
      create_order_detail
      update_rating_product
      @order.save!
      flash[:success] = "Create order successfuly"
      session.delete :cart
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    redirect_to carts_path
  end

  private
  def create_order_detail
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
        product.update(rating: (product.rating + item["rating"].to_i) / 2)
      end
    end
  end
end
