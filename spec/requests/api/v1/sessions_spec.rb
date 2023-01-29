require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "获取用户会话" do
    it "登录" do
      User.create email: "yigehd@foxmail.com"
      post "/api/v1/session", params: { email: "yigehd@foxmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      expect(response.body).not_to be nil
      json = JSON.parse(response.body)
      p json["token"]
      expect(json["token"]).to be_a(String)
    end
  end
end
