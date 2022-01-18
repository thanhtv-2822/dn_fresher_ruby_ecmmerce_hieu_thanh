require "rails_helper"

RSpec.describe API::V1::Authenticate, type: :request do
  let(:user){FactoryBot.create :user}

  describe "POST sign in" do
    before do
      post "/api/v1/auth/sign_in", params: params
    end

    context "when user email and password is valid" do
      let(:params){{email: user.email, password: user.password}}

      it "login successfull and response created" do
        expect(response.status).to eq(201)
      end

      it "should response token" do
        expect(JSON.parse(response.body)["jwt_token"].blank?).to be false
      end
    end

    context "when email and password incorrect" do
      let(:params){{email: "test", password: user.password}}

      it "should return error response code" do
        expect(response.status).to eq(401)
      end

      it "should response error message" do
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email/password combination")
      end
    end

    context "when not include email in body" do
      let(:params){{password: user.password}}

      it "should return error response code" do
        expect(response.status).to eq(422)
      end

      it "should response error message" do
        expect(JSON.parse(response.body)["error"]).to eq("email is missing")
      end
    end

    context "when not include password in body" do
      let(:params){{email: user.email}}

      it "should return error response code" do
        expect(response.status).to eq(422)
      end

      it "should response error message" do
        expect(JSON.parse(response.body)["error"]).to eq("password is missing")
      end
    end

    context "when not include password and email in body" do
      let(:params){{}}

      it "should return error response code" do
        expect(response.status).to eq(422)
      end

      it "should response error message" do
        expect(JSON.parse(response.body)["error"]).to eq("email is missing, password is missing")
      end
    end
  end
end
