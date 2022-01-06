require "rails_helper"
require "shared/share_example_spec.rb"

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin){FactoryBot.create :user, is_admin: 1}

  let(:product){FactoryBot.create(:product, category: Category.last)}

  describe "when valid routing" do
    it{should route(:get, "/admin/products").to(action: :index)}
    it{should route(:get, "/admin/products/1").to(action: :show, id: 1)}
    it{should route(:get, "/admin/products/new").to(action: :new)}
    it{should route(:post, "/admin/products").to(action: :create)}
    it{should route(:get, "/admin/products/2/edit").to(action: :edit, id: 2)}
    it{should route(:put, "/admin/products/3").to(action: :update, id:3)}
    it{should route(:delete, "/admin/products/4").to(action: :destroy, id: 4)}
  end

  describe "admin is not logged in" do
    before {get :new}

    it "redirect to login page" do
      should redirect_to("/users/sign_in")
    end

    it "display flash danger don't permission" do
      expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
    end
  end

  describe "admin is logged in" do
    before :all do
      FactoryBot.create :category
      FactoryBot.create :category, parent_id: Category.first.id
    end
    
    before {sign_in admin}

    describe "GET #show" do
      before {product}
  
      it_behaves_like "share check product nil", :show
  
      it_behaves_like "share check product presence", :show
    end
  
    describe "GET #index" do
      let!(:product1){FactoryBot.create :product, name: "aadd"}
      let!(:product2){FactoryBot.create :product, name: "ddhh"}
  
      context "with params option or search" do
        it "return list product with option :newest" do
          get :index, params: {option: Product::OPTION[:newest]}
          expect(assigns(:products)).to eq [product2, product1]
        end

        it "return list product with search keyword = aa" do
          get :index, params: {search: "aa"}
          expect(assigns(:products)).to eq [product1]
        end
      end

      context "return list not params" do
        before {get :index}

        it "return all product" do
          expect(assigns(:products)).to eq [product1, product2]
        end

        it "render template index product page" do 
          should render_template :index
        end
      end
    end
  
    describe "GET #new" do
      it "render template new product" do
        get :new
        should render_template :new
      end
    end
  
    describe "POST #create" do
      before do
        @ats = {name: "Iphone", price: 1000000, description: "good", category_attributes: {name: "Smartphone", parent_id: Category.first.id}}
      end

      it "redirect to index product path when create product success" do
        post :create, params: {product: @ats}
        expect(response).to be_redirect
      end
      
      it "render template new when create product fail" do
        @ats[:name] = ""
        post :create, params: {product: @ats}
        expect(response).to render_template :new
      end

      it "display flash success when create success" do
        post :create, params: {product: @ats}
        expect(flash[:success]).to eq("Create product successfuly")
      end

      it "change number of product by 1" do
        expect{Product.create(@ats)}.to change {Product.count}.by(1)
      end
    end
  
    describe "GET #edit" do
      before {product}
  
      it_behaves_like "share check product nil", :edit
  
      it_behaves_like "share check product presence", :edit
    end
  
    describe "DELETE #destroy" do
      before {product}
  
      it_behaves_like "share check product nil", :destroy
  
      context "when product found" do
        it "display flash success" do
          delete :destroy, params: {id: product.id}
          expect(flash[:success]).to eq("Delete success")
        end
  
        it "redirect to index product path" do
          delete :destroy, params: {id: product.id}
          expect(response).to redirect_to admin_products_path
        end

        it "change number of product by 1" do
          expect do
            delete :destroy, params: {id: product.id}
          end.to change{Product.count}.by(-1)
        end
      end

     
    end
  
    describe "PUT #update" do
      before {product}

      it_behaves_like "share check product nil", :update

      context "when found the product" do
        before do
          patch :update, params: {id: product.id, product: {name: "hhhaaa"}}
          product.reload
        end

        it "is update database success" do
          expect(product.name).to eq("hhhaaa")
        end

        it "display flash update success" do
          expect(flash[:success]).to eq("Updated success")
        end

        it "redirect to index product path" do
          expect(response).to redirect_to admin_products_path
        end
      end

      it "render edit when update product fail" do
        patch :update, params: {id: product.id, product: {name: ""}}
        expect(response).to render_template :edit
      end
    end
  end
end
