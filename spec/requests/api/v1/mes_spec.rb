require "rails_helper"

RSpec.describe "Me", type: :request do
  describe "获取用户信息" do
    it "获取登陆用户信息" do
      user = User.create email: "yigehd@foxmail.com"
      post "/api/v1/session", params: { email: "yigehd@foxmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      expect(response.body).not_to be nil
      json = JSON.parse(response.body)
      token = json["token"]
      expect(json["token"]).to be_a(String)

      get "/api/v1/me", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["data"]).not_to be nil
      expect(json["data"]["id"]).to eq user.id
      expect(json["data"]["email"]).to eq "yigehd@foxmail.com"
    end
  end
end
