module OrdersHelper
  def update_address(id, value)
    update_address = Address.update(id, value)
    return if update_address.save

    flash[:danger] = "Invalid address"
  end

  def create_address(value)
    value[:default] = 1
    new_address = @user.addresses.build value
    if new_address.save
      @order.address.id = new_address.id
    else
      flash[:danger] = "Invalid address"
    end
  end

  def update_order(status, payment)
    return if @order.update(status: status, payment_id: payment, address_id: @order.address.id)

    flash[:danger] = "order failed"
  end
end
