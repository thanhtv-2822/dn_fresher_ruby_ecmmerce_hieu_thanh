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
