require "rails_helper"
require "active_support/testing/time_helpers"

RSpec.describe "Me", type: :request do
  include ActiveSupport::Testing::TimeHelpers
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

    it "jwt过期测试" do
      travel_to Time.now - 3.hours
      user1 = User.create email: "1@qq.com"
      jwt = user1.generate_jwt

      travel_back
      get "/api/v1/me", headers: { "Authorization" => "Bearer #{jwt}" }
      expect(response).to have_http_status(401)
    end

    it "jwt不过期测试" do
      travel_to Time.now - 1.hours
      user1 = User.create email: "1@qq.com"
      jwt = user1.generate_jwt

      travel_back
      get "/api/v1/me", headers: { "Authorization" => "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
    end
  end
end
