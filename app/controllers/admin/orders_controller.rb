class Admin::OrdersController < Admin::BaseController
  before_action :check_order, only: [:update]
  def index
    @pagy, @orders = pagy(
      Order.all.order_by_updated_at,
      items: 5
    )
    filter_params(params).each do |key, value|
      @orders = @orders.public_send("filter_by_#{key}", value) if value.present?
    end
  end

  def update
    if @order.update(status: status_params.to_i)
      flash[:success] = t "admin.order.update.success"
    else
      flash[:danger] = t "admin.order.update.fail"
    end
    redirect_to admin_orders_path
  end

  private

  def status_params
    params.require(:status)
  end

  def filter_params params
    params.slice(:customer, :status)
  end

  def check_order
    return if @order = Order.find_by(id: params[:id])
  end
end
