class ApplicationController < ActionController::Base
  include Pagy::Backend
  include OrderDetailsHelper
  include OrdersHelper
  include SessionsHelper
  include CartsHelper
  before_action :set_locale
  before_action :current_user

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def current_user
    @user = User.first

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "admin.permission"
    redirect_to login_url
  end
end
