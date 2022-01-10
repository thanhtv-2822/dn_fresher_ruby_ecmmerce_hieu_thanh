class Admin::OrderDetailsController < Admin::BaseController
  authorize_resource

  def index
    return if @order = Order.find_by(id: params[:order_id])

    flash[:danger] = t "admin.order_detail.invalid"
  end
end
