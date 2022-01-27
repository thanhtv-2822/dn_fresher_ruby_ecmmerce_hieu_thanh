RSpec.shared_examples "share presence attribute" do |attributes|
  attributes.each do |attr|
    it { should validate_presence_of(attr) }
  end
end

RSpec.shared_examples "share check product nil" do |action|
  context "when product not found" do
    before {get :show, params: {id: -1}}

    it "display flash danger" do
      expect(flash[:danger]).to eq("Product not found!")
    end

    it "redirect to index product path" do
      expect(response).to redirect_to admin_products_path
    end
  end
end

RSpec.shared_examples "share check product presence" do |action|
  context "when product found" do
    before {get action, params: {id: product.id}}

    it "render template #{action.to_s} product" do
      expect(response).to render_template(action)
    end
  end
end

RSpec.shared_examples "share check login admin" do
  before {get :index}

  it "redirect to login page" do
    should redirect_to("/users/sign_in")
  end

  it "display flash danger don't permission" do
    expect(flash[:alert]).to eq("You need to sign in or sign up before continuing.")
  end
end

RSpec.shared_examples "share update order fail" do |old, new|
  let(:order) {FactoryBot.create :order, status: old}
  it "when update fail" do
    put :update, params: {id: order.id, status: new}
    expect(flash[:danger]).to eq("Update failed")
  end
end

RSpec.shared_examples "share response code 401" do |apikey, msg, path|
  it "response #{msg} when api key nil" do
    get path, params: {api_key: apikey}
    expect(response.status).to eq(401)
  end
end
