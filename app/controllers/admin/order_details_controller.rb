class Admin::OrderDetailsController < Admin::BaseController
  def index
    return if @order = Order.find_by(id: params[:order_id])

    flash[:danger] = t "admin.order_detail.invalid"
  end
end
