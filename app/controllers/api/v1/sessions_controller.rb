class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  before_action :find_refresh_token, only: :refresh_token

  def create
    @user = User.find_by email: user_params[:email]
    if @user&.valid_password? user_params[:password]
      auth = {
        jwt_token: Auth.encode(user_id: @user.id),
        refresh_token: Digest::SHA256.base64digest(ENV["REFRESH"])
      }
      render_json :auth, auth, :ok
    else
      render_json :message, t("jwt.error_login"), :unauthorized
    end
  end

  def refresh_token
    if current_user
      auth = {
        jwt_token: Auth.encode(user_id: current_user.id),
        refresh_token: Digest::SHA256.base64digest(ENV["REFRESH"])
      }
      render_json :auth, auth, :ok
    else
      render_json :message, t("jwt.unauthorized"), :unauthorized
    end
  end

  def user_params
    params.require(:user).permit :email, :password
  end

  private
  def find_refresh_token
    @token = request.headers["Refresh-Token"]
    return if @token

    render_json :message, t("jwt.invalid"), :unauthorized
  end
end
