class UsersController < ApplicationController
  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "errors.register.success"
      redirect_to login_path
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  private
  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end
end
