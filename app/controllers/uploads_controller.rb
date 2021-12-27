class UploadsController < ApplicationController
  before_action :check_user, only: [:update]

  def update
    if params[:user] && @user.image.attach(upload_params[:image])
      flash[:success] = t("success.img")
    else
      flash[:danger] = t("errors.img")
    end
    redirect_to @user
  end

  private

  def upload_params
    params.require(:user).permit(:image)
  end

  def check_user
    @user = current_user
  end
end
