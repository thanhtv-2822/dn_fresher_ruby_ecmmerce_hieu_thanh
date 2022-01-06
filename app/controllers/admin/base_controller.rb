class Admin::BaseController < ApplicationController
  include Pagy::Backend
  layout "admin/layouts/application"
  before_action :authenticate_user!, :check_admin

  private
  def check_admin
    return if current_user.is_admin?

    store_location_for(:admin, request.fullpath)
    flash[:danger] = t "admin.permission"
    redirect_to root_path
  end
end
