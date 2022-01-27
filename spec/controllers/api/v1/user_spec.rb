require "rails_helper"
require "shared/share_example_spec.rb"

RSpec.describe API::V1::Users, type: :request do
  let(:user){FactoryBot.create :user}

  before do
    post "/api/v1/auth/sign_in",
    params: {
      email: user.email,
      password: user.password
    }
  end

  let(:apikey){"Bearer " + JSON.parse(response.body)["jwt_token"]}

  it_behaves_like "share response code 401", "", "error status code", "/api/v1/users"

  describe "GET all user" do
    it "response success status code" do
      get "/api/v1/users", params: {api_key: apikey}
      expect(response.status).to eq(200)
    end

    it "response message error" do
      get "/api/v1/users", params: {api_key: ""}
      expect(JSON.parse(response.body)["error"].blank?).to be false
    end
  end

  describe "GET a user" do
    it "response success status code" do
      get "/api/v1/users/#{user.id}", params: {api_key: apikey}
      expect(response.status).to eq(200)
    end

    it "response message error not found" do
      get "/api/v1/users/-1", params: {api_key: ""}
      expect(JSON.parse(response.body)["error"].blank?).to be false
    end
  end

  describe "POST a user" do
    it "change number of user by 1" do
      expect do
        post "/api/v1/users", params: {
          api_key: apikey,
          email: "asds@gmail.com",
          name: user.name,
          password: user.password,
          password_confirmation: user.password_confirmation
        }
      end.to change{User.count}.by(1)  
    end

    it "response error status code" do
      post "/api/v1/users", params: {api_key: apikey, email: ""}
      expect(response.status).to eq(422)
    end
  end

  describe "DELETE a user" do
    it "response success status code" do
      delete "/api/v1/users/#{user.id}", params: {api_key: apikey}
      expect(response.status).to eq(204)
    end

    it "response message error not found" do
      delete "/api/v1/users/-1", params: {api_key: ""}
      expect(JSON.parse(response.body)["error"].blank?).to be false
    end

    it "change number of user by 1" do
      expect do
        delete "/api/v1/users/#{user.id}", params: {api_key: apikey}
      end.to change {User.count}.by(-1)
    end
  end

  describe "PUT a user" do
    it "response success status code" do
      put "/api/v1/users/#{user.id}", params: {api_key: apikey, name: "thanh2", email: "abd@gmail.com"}
      expect(response.status).to eq(200)
    end

    it "response error status code " do
      put "/api/v1/users/#{user.id}", params: {api_key: apikey, name: "thanh2"}
      expect(JSON.parse(response.body)["error"].blank?).to be false
    end
  end
end
