require "rails_helper"
require "shared/share_example_spec.rb"

RSpec.describe Product, type: :model do
  let(:category){FactoryBot.create :category }

  subject {FactoryBot.create :product}

  it "is valid" do
    expect(subject).to be_valid 
  end

  describe "associations" do
    it {is_expected.to have_many(:order_details).dependent(:destroy)}
    it {is_expected.to belong_to(:category)}
    it {is_expected.to have_many(:orders).through(:order_details)}
    it {is_expected.to have_one_attached(:image)}
    it {is_expected.to accept_nested_attributes_for(:category)}
  end

  describe "create nested category in product" do
    before {category}
    before :each do
      @ats = {name: "Iphone", price: 1000000, description: "good", category_attributes: {name: "Smartphone", parent_id: Category.first.id}}
    end

    it "is valid" do 
      expect(Product.create(@ats)).to be_valid
    end

    it "change number of product by 1" do
      expect{Product.create(@ats)}.to change {Product.count}.by(1)
    end

    it "change number of category by 1" do
      expect{Product.create(@ats)}.to change {Category.count}.by(1)
    end
  end

  describe "is validations" do
    it "is a valid" do
      is_expected.to be_valid
    end

    it_behaves_like "share presence attribute", %i(name description quantity price)

    context "with name" do
      it {is_expected.to validate_length_of(:name).is_at_most(Settings.length.len_50)}
    end

    context "with quantity" do
      it do
        is_expected.to validate_numericality_of(:quantity).only_integer.
          is_greater_than(Settings.min.quantity)
      end
    end

    context "with price" do
      it {is_expected.to validate_numericality_of(:price)}
    end
  end

  describe "scope" do
    before {category}
    let!(:category_1){FactoryBot.create :category, parent_id: Category.first.id}
    let!(:category_2){FactoryBot.create :category, parent_id: Category.first.id}
    let!(:product_1){FactoryBot.create :product, name: "asi", rating: 5, price: 8000000, category: Category.second}
    let!(:product_2){FactoryBot.create :product, name: "product2", rating: 5, price: 12000000, category: Category.last}
    let!(:product_3){FactoryBot.create :product, name: "product3", rating: 4, price: 10000000, category: Category.last}
    let!(:product_4){FactoryBot.create :product, name: "product4", rating: 3, price: 9000000, category: Category.last}

    context "with filter by category" do
      it "return a list product with category_id = second category" do
        second = Category.second.id
        products = Product.filter_by_category(second)
        expect(products).to eq([product_1])
      end

      it "return a list product with category_id = last category" do
        category_id = Category.last.id
        products = Product.filter_by_category(category_id)
        expect(products).to eq([product_2, product_3, product_4])
      end

      it "return a list empty product" do
        category_id = Category.first.id
        products = Product.filter_by_category(category_id)
        expect(products).to eq([])
      end
    end

    context "with sort by name" do
      it "return list contain product 2" do
        keyword = "duct2"
        product = Product.sort_by_name(keyword)
        expect(product).to eq([product_2])
      end

      it "return list empty product" do
        keyword = "sad"
        product = Product.sort_by_name(keyword)
        expect(product).to eq([])
      end
    end
        
    context "with order by" do
      it "return list product create at newest" do
        products = Product.order_by(created_at: Settings.order.DESC)
        expect(products).to eq([product_4, product_3, product_2, product_1])
      end

      it "return list product create at oldest" do
        products = Product.order_by(created_at: Settings.order.ASC)
        expect(products).to eq([product_1, product_2, product_3, product_4])
      end

      it "return list product price increase" do
        products = Product.order_by(price: Settings.order.ASC)
        expect(products).to eq([product_1, product_4, product_3, product_2])
      end

      it "return list product price decrease" do
        products = Product.order_by(price: Settings.order.DESC)
        expect(products).to eq([product_2, product_3, product_4, product_1])
      end
    end

    context "with filter by rate" do
      it "return list product with rate decrease" do
        products = Product.filter_by_rate(Settings.order.DESC)
        expect(products).to eq([product_1, product_2, product_3, product_4])
      end

      it "return list product with rate increase" do
        products = Product.filter_by_rate(Settings.order.ASC)
        expect(products).to eq([product_4, product_3, product_1, product_2])
      end
    end

    context "with filter by name" do
      it "return list product with name a-z" do
        products = Product.filter_by_name(Settings.order.ASC)
        expect(products).to eq([product_1, product_2, product_3, product_4])
      end

      it "return list product with name z-a" do
        products = Product.filter_by_name(Settings.order.DESC)
        expect(products).to eq([product_4, product_3, product_2, product_1])
      end
    end

    context "with filter by price" do
      it "return list product with price asc" do
        products = Product.filter_by_price(Settings.order.ASC)
        expect(products).to eq([product_1, product_4, product_3, product_2])
      end

      it "return list product with price desc" do
        products = Product.filter_by_price(Settings.order.DESC)
        expect(products).to eq([product_2, product_3, product_4, product_1])
      end
    end

    context "with filter by type" do
      it "return list product with type category" do
        type = Category.first.id
        products = Product.filter_by_type(type)
        expect(products).to eq([product_1, product_2, product_3, product_4])
      end
    end
  end
end
