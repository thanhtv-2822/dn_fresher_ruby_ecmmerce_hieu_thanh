module API
  module V1
    class Authenticate < Grape::API
      include API::V1::Defaults

      resources :auth do
        desc "Log in with email, password and return",
             tags: %w(Auth),
             http_codes: [
               {code: 201, message: "Login successfully"},
               {code: 422, message: "Request contain invalid data"},
               {code: 500, message: "Server error"}
             ]
        params do
          requires :email, type: String, documentation: {in: "body"}
          requires :password, type: String, documentation: {in: "body"}
        end
        post "/sign_in" do
          user = User.find_by(email: params[:email])
          if user&.valid_password? params[:password]
            {jwt_token: Auth.encode(user_id: user.id)}
          else
            error!(I18n.t("jwt.error_login"), 401)
          end
        end
      end
    end
  end
end
