class OrdersController < ApplicationController
  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @carts = get_all_item_in_cart
      create_order_detail
      @order.save!
      flash[:success] = "Create order successfuly"
      session.delete :cart
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:danger] = e
    redirect_to carts_path
  end

  def create_order_detail
    @carts.each do |item|
      @order.order_details.build(
        product_id: item["product"]["id"],
        quantity: item["quantity"]
      )
    end
  end
end
