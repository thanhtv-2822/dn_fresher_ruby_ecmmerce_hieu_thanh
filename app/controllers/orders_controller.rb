class OrdersController < ApplicationController
  before_action :check_order, :check_address, only: [:show, :update, :create]

  def index
    @orders = @user.orders
  end

  def show
    store_location
  end

  def update
    if @order.update order_params
      flash[:success] = t("success.order")
      redirect_to  user_order_path(@user)
    else
      flash[:danger] = t("error.order")
      render :show
    end
  end

  private

  def check_order
    @order = @user.orders.find_by(status: 0)
    if @order.nil?
      flash[:danger] = t("warning.order")
      redirect_to static_pages_home_path
    else
      @products = detail_product(@order.order_details)
    end
  end

  def check_address
    @address = @user.addresses
    if @address.nil?
      @address = Address.new
  end

  def order_params
    params.require(:order).permit(
      :payment_id,
      :address_id,
      :status
    )
    end
  end

end
