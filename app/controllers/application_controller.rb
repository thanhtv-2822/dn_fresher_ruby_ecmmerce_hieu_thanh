class ApplicationController < ActionController::Base
  include Pagy::Backend
  include OrderDetailsHelper
  include OrdersHelper
  include CartsHelper
  include ProductHelper
  include AddressesHelper
  include CategoriesHelper
  before_action :set_locale

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    added_attrs = %i(name email password password_confirmation remember_me)
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for resource_or_scope
    if current_user&.is_admin?
      stored_location_for(resource_or_scope) || admin_root_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end

  rescue_from CanCan::AccessDenied do
    redirect_to root_path, alert: t("cancan.permission")
  end

  def authentication!
    token = request.headers["Jwt-Token"]
    user_id = Auth.decode(token)["user_id"] if token
    @current_user = User.find_by(id: user_id) if user_id
    return if @current_user

    render_json :message, t("jwt.unauthorized"), :unauthorized
  rescue JWT::DecodeError
    render_json :message, t("jwt.invalid"), :unauthorized
  end

  def render_json message, data, status
    render json: {message => data}, status: status
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if user_signed_in?

    store_location_for(:user, request.fullpath)
    flash[:danger] = t "admin.permission"
    redirect_to new_user_session_path
  end
end
