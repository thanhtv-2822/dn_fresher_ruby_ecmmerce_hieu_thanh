module AddressesHelper
  def check_default user, params, address
    return true if params != "1" || address.default == 1

    user.addresses.find_by(default: 1) ? false : true
  end

  def create_address address, params
    address = current_user.addresses.build(add_params)
    if address.save
      flash[:success] = "Address was created successfully"
      redirect_back_or @user
    else
      flash[:danger] = "Failure"
      redirect_to new_address_path
    end
  end

end
