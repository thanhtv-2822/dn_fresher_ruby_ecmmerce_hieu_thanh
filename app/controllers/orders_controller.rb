class OrdersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  before_action :check_user, :check_address, only: %i(index show update create)
  before_action :check_order, only: %i(index update)
  before_action :find_order, only: :create

  def index
    store_location_for(:orders, request.fullpath)
  end

  def show
    @orders = @user.orders.order_by_updated_at
  end

  def update
    ActiveRecord::Base.transaction do
      @order.update order_params
      flash[:success] = t "success.order"
      SendMailWorker.perform_async(@user.id, @order.id)
      session.delete :cart
      redirect_to order_path(@user)
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "errors.record_invalid"
    redirect_to orders_path
  end

  def create
    ActiveRecord::Base.transaction do
      RemoveOrderPending.perform_async(@order.id) if @order
      create_order
      UpdateStatusWorker.set(wait: 7.days).perform_async(@order.id)
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
  end

  def check_user
    @user = current_user
  end

  def check_order
    @order = current_user&.orders&.find_by(status: :pending)
    if @order.nil?
      flash[:danger] = t("warning.order")
      redirect_to home_path
    else
      @products = @order.order_details
    end
  end

  def check_address
    @address = @user&.addresses
    return if @address

    @address = Address.new
  end

  def find_order
    @order = Order.find_by(user_id: current_user, status: :pending)
  end
end
