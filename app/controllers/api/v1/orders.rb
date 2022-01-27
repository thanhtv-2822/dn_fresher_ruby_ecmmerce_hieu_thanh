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

        desc "Update status of order"
        params do
          requires :id, type: Integer, desc: "ID of the order"
          requires :status, type: String, documentation: {in: "body"}
        end
        put ":id", root: "order" do
          order = Order.find(params[:id])
          present order if order&.update(status: params[:status])
        end
      end
    end
  end
end
