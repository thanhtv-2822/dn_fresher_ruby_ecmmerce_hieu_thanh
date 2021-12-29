require "rails_helper"
include SessionsHelper
require "shared/share_example_spec.rb"

RSpec.describe Admin::OrdersController, type: :controller do
  let (:admin) {FactoryBot.create :user, is_admin: 1}

  describe "when valid routing" do
    it {should route(:get, "/admin/orders").to(action: :index)}
    it {should route(:put, "/admin/orders/1").to(action: :update, id: 1)}
  end

  it_behaves_like "share check login admin"

  describe "admin is logged in" do
    before {log_in admin}

    describe "GET #index" do
      let(:user){FactoryBot.create :user, name: "thanh"}
      let!(:order1){FactoryBot.create :order, status: 0, user: user}
      let!(:order2){FactoryBot.create :order, status: 1, user: user}
      let!(:order3){FactoryBot.create :order, status: 2}

      context "with not params" do
        it "return list order newest with status not 0" do
          get :index
          expect(assigns(:orders)).to eq [order3, order2]
        end
      end

      context "with params" do
        it "return list order with param status" do
          get :index, params: {status: 2}
          expect(assigns(:orders)).to eq [order3]
        end
      end
    end

    describe "PUT #update" do
      context "when order not found" do
        before {put :update, params: {id: -1}}

        it "should display flash when not found" do
          expect(flash[:danger]).to eq("Order not found")
        end

        it "redirect to template index order when not found" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order found" do
        let(:order){FactoryBot.create(:order, status: 1)}
        it "when update success" do
          put :update, params: {id: order.id, status: 2}
          expect(flash[:success]).to eq("Orders updated successfully")
        end

        it "redirect to template index order when update success" do
          put :update, params: {id: order.id, status: 3}
          expect(response).to redirect_to admin_orders_path
        end

        it_behaves_like "share update order fail", 1, 3
        it_behaves_like "share update order fail", 2, 1
        it_behaves_like "share update order fail", 3, 1
      end
    end
  end
end
