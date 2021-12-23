module SessionsHelper
  def log_in user
    if user.is_admin?
      session[:admin_id] = user.id
    else
      session[:user_id] = user.id
    end
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def current_admin
    @current_admin ||= User.find_by id: session[:admin_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin_logged_in?
    current_admin.present?
  end

  def log_out
    session.delete :user_id
    session.delete :cart
    session.delete :recent
    @current_user = nil
  end

  def log_out_admin
    session.delete :admin_id
    @current_admin = nil
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end
end
