require "rails_helper"

RSpec.describe "Api::V1::Tags", type: :request do
  describe "获取标签" do
    it "未登录获取标签" do
      get "/api/v1/tags"
      expect(response).to have_http_status(401)
    end

    it "登录获取标签(分页)" do
      user = User.create email: "1@qq.com"
      another_user = User.create email: "2@qq.com"
      11.times do |i| Tag.create name: "tag#{i}", sign: "xxx", user_id: user.id end
      11.times do |i| Tag.create name: "tag#{i}", sign: "xxx", user_id: another_user.id end
      get "/api/v1/tags", headers: user.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(10)
      expect(json[0]["name"]).to eq("tag0")
      expect(json[0]["user_id"]).to eq(user.id)
      get "/api/v1/tags", params: { page: 2 }, headers: user.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
      expect(json[0]["name"]).to eq("tag10")
      expect(json[0]["user_id"]).to eq(user.id)
      get "/api/v1/tags", params: { page: 3 }, headers: user.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(0)
    end
  end
end
