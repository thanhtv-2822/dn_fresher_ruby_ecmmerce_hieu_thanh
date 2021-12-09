class SessionsController < ApplicationController
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      active user
    else
      flash[:danger] = t "errors.login.danger"
      render :new
    end
  end

  def destroy
    log_out
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
end
