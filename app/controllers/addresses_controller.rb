class AddressesController < ApplicationController
  before_action :current_address, only: [:edit, :destroy, :update]

  def destroy
    @address = @address.destroy
    flash[:success] = "Address was successfully destroyed"
    redirect_to user_path(current_user)
  end

  def create
    @address = current_user.addresses.build(add_params)
    if @address.save
      flash[:success] = "Address was created successfully"
      redirect_back_or @user
    else
      render :new
    end
  end

  def new
    @address = Address.new
  end

  def edit; end

  def update
    if @address.update(add_params)
      flash[:success] = "Address updated successfully"
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
