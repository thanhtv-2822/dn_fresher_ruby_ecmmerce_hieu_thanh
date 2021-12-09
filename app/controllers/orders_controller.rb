class OrdersController < ApplicationController
  before_action :check_user, :check_address, only: [:index, :show, :update, :create]
  before_action :check_order, only: [:index, :update]

  def index
    store_location
  end

  def show
    @orders = @user.orders
  end

  def update
    if @order.update order_params
      flash[:success] = t("success.order")
      redirect_to user_order_path(@user)
    else
      flash[:danger] = t("error.order")
      render :show
    end
  end

  def create
    ActiveRecord::Base.transaction do
      create_order
      redirect_to orders_path
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "errors.record_invalid"
    redirect_to carts_path
  end

  private

  def order_params
    params.require(:order).permit(
      :payment_id,
      :address_id,
      :status
    )
    end
  end
 
  def create_order_detail
    @carts = get_all_item_in_cart
    @carts.each do |item|
      @order.order_details.build(
        product_id: item[:product].id,
        quantity: item[:quantity]
      )
    end
  end

  def update_rating_product
    @carts.each do |item|
      if (1..5).include?(item[:rating].to_i)
        product = Product.find_by id: item[:product].id
        rating = ((product.rating + item[:rating].to_i) / 2).round(1)
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

  def check_user
    @user = current_user
  end

  def check_order
    @order = @user.orders.find_by(status: 0)
    if @order.nil?
      flash[:danger] = t("warning.order")
      redirect_to home_path
    else
      @products = @order.order_details
    end
  end

  def check_address
    @address = @user.addresses
    if @address.nil?
      @address = Address.new
  end
end
