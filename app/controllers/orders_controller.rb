class OrdersController < ApplicationController
  before_action :check_user, :check_order, :check_address, only: [:show, :update, :create]

  def index
    return if @order = Order.find_by_id(params[:user_id])

    flash[:danger] = t("errors.user")

  end

  def show; end

  def update
    if @order.update order_params
      flash[:success] = t("success.order")
      redirect_to order_path
    else
      flash[:danger] = t("error.order")
      render :show
    end
  end

  private

  def check_user
    @user = User.first
  end

  def check_order
    @order = @user.orders.find_by(status: 0)
    if @order.nil?
      flash[:danger] = t("warning.order")
      redirect_to static_pages_home_path
    else
      @order_details =  @order.order_details
      @total = 0
      @order_details.each do |order|
        @total += order.price
      end
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
