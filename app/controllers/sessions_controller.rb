class SessionsController < ApplicationController
  before_action :check_login, only: %i(create new)
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      active user
    else
      flash.now[:danger] = t "errors.login.danger"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t "errors.logout"
    redirect_to home_path
  end

  def new; end

  private
  def active user
    flash[:success] = t "errors.login.success"
    log_in user
    return redirect_to admin_root_path if user.is_admin?

    redirect_back_or home_path
  end

  def check_login
    return if current_user.nil? && current_admin.nil?

    flash[:danger] = t "errors.cant_login"
    redirect_to home_path
  end
end
