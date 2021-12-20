class ApplicationController < ActionController::Base
  include Pagy::Backend
  include OrdersHelper
  before_action :set_locale

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
