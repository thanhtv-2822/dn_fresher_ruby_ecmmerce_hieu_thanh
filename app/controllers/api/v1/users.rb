module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      before do
        authenticate_user!
      end

      desc "Return all users"
      get "users" do
        User.all
      end

      desc "Return a user"
      params do
        requires :id, type: Integer, desc: "ID of user"
      end
      get "users/:id" do
        user = User.find_by id: params[:id]
        return user if user

        error!("user not found", 404)
      end

      desc "Create a user"
      params do
        requires :name, type: String, documentation: {in: "body"}
        requires :email, type: String, documentation: {in: "body"}
        requires :password, type: String, documentation: {in: "body"}
        requires :password_confirmation,
                 type: String,
                 documentation: {in: "body"}
      end
      post "users" do
        User.create!(
          name: params[:name],
          email: params[:email],
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        )
      end

      desc "Update a user"
      params do
        requires :id, type: Integer, desc: "ID of user"
        requires :name, type: String, documentation: {in: "body"}
        requires :email, type: String, documentation: {in: "body"}
      end
      put "users/:id" do
        user = User.find_by id: params[:id]
        if user
          user.update(
            name: params[:name],
            email: params[:email]
          )
          present user
        else
          error!("user not found", 404)
        end
      end

      desc "Destroy a user"
      params do
        requires :id, type: Integer, desc: "ID of user"
      end
      delete "users/:id" do
        user = User.find_by id: params[:id]
        if user
          return error!("user is admin", 403) if user.is_admin?

          user.destroy
          status(204)
        else
          error!("user not found", 404)
        end
      end
    end
  end
end
