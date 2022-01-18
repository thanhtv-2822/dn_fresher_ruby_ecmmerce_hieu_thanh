module API
  module V1
    class Orders < Grape::API
      include API::V1::Defaults

      before do
        authenticate_user!
      end

      resource :orders do
        desc "Return all orders"
        get "", root: :orders do
          Order.all
        end

        desc "Return a order"
        params do
          requires :id, type: Integer, desc: "ID of the order"
        end
        get ":id", root: "order" do
          Order.find params[:id]
        end
      end
    end
  end
end
