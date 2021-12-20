class Admin::BaseController < ApplicationController
  include Pagy::Backend
  layout "admin/layouts/application"
  before_action :logged_admin?

  def logged_admin?
    return if admin_logged_in?

    redirect_to login_path
    flash[:danger] = "You dont permission"
  end
end
