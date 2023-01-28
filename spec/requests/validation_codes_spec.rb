require "rails_helper"

RSpec.describe "ValidationCodes", type: :request do
  describe "验证码测试" do
    it "可以生成验证码" do
      post "/api/v1/validation_codes", params: { email: "yigehd@foxmail.com" }
      expect(response).to have_http_status(200)
      post "/api/v1/validation_codes", params: { email: "yigehd@foxmail.com" }
      expect(response).to have_http_status(429)
    end
  end
end
