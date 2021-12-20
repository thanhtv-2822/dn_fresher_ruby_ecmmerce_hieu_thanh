class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      flash[:success] = t "errors.login.success"
      redirect_to home_path
      log_in user
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
end
