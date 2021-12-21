class ApplicationController < ActionController::Base
  include Pagy::Backend
  include OrderDetailsHelper
  include OrdersHelper
  include SessionsHelper
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
  end
end
