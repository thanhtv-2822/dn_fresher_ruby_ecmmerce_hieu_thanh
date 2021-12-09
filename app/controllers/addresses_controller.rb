class AddressesController < ApplicationController
  before_action :current_address, only: [:edit, :destroy, :update]

  def destroy
    @address = @address.destroy
    flash[:success] = t "success.add_destroy"
    redirect_to user_path(current_user)
  end

  def create
    @address = current_user.addresses.build(add_params)
    puts check_default(current_user, add_params["default"])
    if check_default(current_user, add_params["default"]) && @address.save
      flash[:success] = t "success.address"
      redirect_back_or @user
    else
      flash[:danger] = t "errors.default"
      render :new
    end
  end

  def new
    @address = Address.new
  end

  def edit; end

  def update
    if @address.update(add_params)
      flash[:success] = t "success.address"
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def add_params
    params.require(:address).permit(Address::ADD_ATTRS)
  end

  def current_address
    @address = Address.find(params[:id])
  end

end
