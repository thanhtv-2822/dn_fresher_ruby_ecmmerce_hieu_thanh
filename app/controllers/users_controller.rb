class UsersController < ApplicationController
  before_action :check_user, only: [:show, :update]
  def show
    @address = @user.addresses
  end

  def  update
    if @user.update user_params
      flash[:success] = "User updated successfully"
      redirect_to @user
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def check_user
    @user = User.find_by(id: params[:id])
  end

end
