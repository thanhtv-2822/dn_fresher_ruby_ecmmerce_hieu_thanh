require "rails_helper"
require "shared/share_example_spec.rb"

RSpec.describe User, type: :model do
  subject {FactoryBot.create(:user)} 
  
  it "has a valid factory" do
    expect(subject).to be_valid
  end

  describe "associations" do
    it {is_expected.to have_many(:addresses).dependent(:destroy)}
    it {is_expected.to have_many(:contributes).dependent(:destroy)}
    it {is_expected.to have_many(:orders).dependent(:destroy)}
    it {is_expected.to have_one_attached(:image)}
  end

  describe "scope" do
    let!(:user_1){FactoryBot.create :user}
    let!(:user_2){FactoryBot.create :user, name: "ex2", email: "ex2@gmail.com"}
    let!(:user_3){FactoryBot.create :user, name: "ex3", email: "ex3@gmail.com"}

    context "with order newest" do
      it "return a list of the latest users" do
        expect(User.order_by_updated_at).to eq([user_3, user_2, user_1])
      end
    end

    context "with filter name" do
      it "return user with name like ex2" do
        expect(User.filter_by_name("ex2")).to eq([user_2])
      end

      it "return user with name like ex" do
        expect(User.filter_by_name("ex")).to eq([user_2, user_3])
      end
      
      it "return an empty user list" do
        expect(User.filter_by_name("User4")).to eq([])
      end
    end
  end

  describe "#email_downcase" do
    let(:user){FactoryBot.create :user, name: "THANH", email: "THANH@gmail.com"}

    it "return lowercase email" do
      user.email_downcase
      expect(user.email).to eq("thanh@gmail.com")
    end
  end
  
  describe "validations" do
    it "is a valid" do
      is_expected.to be_valid
    end
    
    it_behaves_like "share presence attribute", %i(name email)

    context "with name" do
      it {is_expected.to validate_length_of(:name).is_at_most(Settings.length.len_50)}
    end

    context "with email" do
      it {is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
      it {is_expected.to validate_length_of(:email).is_at_most(Settings.length.len_50)}

      it "be valid" do
        emails = %w(a@gl.co a.b@gl.co an-vn@gma.cm 7er@gmail.com f_n_d@g.co)
        emails.each do |e|
          subject.email = e
          expect(subject).to be_valid
        end
      end

      it "be invalid" do
        emails = %w(tha,nh@gm.co bar@gmail,com fn@gm+bar.cn)
        emails.each do |e|
          subject.email = e
          expect(subject).to_not be_valid
        end
      end
    end

    context "with password" do
      it {is_expected.to validate_presence_of(:password).allow_nil}
      it {is_expected.to validate_length_of(:password).is_at_least(Settings.length.len_6)}     
      it {is_expected.to validate_length_of(:password).is_at_most(Settings.length.len_50)}
      it {is_expected.to validate_confirmation_of(:password).with_message("not match")}
    end
  end
end
