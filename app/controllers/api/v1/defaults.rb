module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error_response(message: e.message, status: 422)
        end

        helpers do
          def authenticate_user!
            token = params["api_key"].split(" ")[1]
            user_id = Auth.decode(token)["user_id"] if token
            @current_user = User.find_by(id: user_id) if user_id
            error!(I18n.t("jwt.unauthorized"), 401) unless @current_user
          rescue JWT::DecodeError
            error!(I18n.t("jwt.invalid"), 401)
          end
        end
      end
    end
  end
end
