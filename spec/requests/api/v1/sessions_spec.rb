require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "获取用户会话" do
    it "登录(非首次登录)" do
      User.create email: "yigehd@foxmail.com"
      post "/api/v1/session", params: { email: "yigehd@foxmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      expect(response.body).not_to be nil
      json = JSON.parse(response.body)
      expect(json["token"]).to be_a(String)
    end
    it "登录(首次登录)" do
      post "/api/v1/session", params: { email: "555@foxmail.com", code: "123456" }
      expect(response).to have_http_status(200)
      expect(response.body).not_to be nil
      json = JSON.parse(response.body)
      expect(json["token"]).to be_a(String)
    end
  end
end
