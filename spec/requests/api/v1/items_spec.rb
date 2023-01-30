require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "创建Items" do
    it "通过Items类创建item测试" do
      expect {
        3.times { (Item.create amount: 99, note: "测试") }
      }.to change { Item.count }.by(+3)
    end
  end

  describe "创建Items" do
    it "通过post方法创建item测试" do
      user1 = User.create email: "1@qq.com"
      expect {
        post "/api/v1/items", params: { amount: 113 }, headers: user1.generate_auth_hearder
      }.to change { Item.count }.by(+1)
      get "/api/v1/items", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
      expect(json[0]["amount"]).to eq(113)
      expect(json[0]["user_id"]).to eq(user1.id)
    end
  end

  describe "查询Items" do
    it "分页测试(无查询条件,只有页码)" do
      user1 = User.create email: "1@qq.com"
      user2 = User.create email: "1@qq.com"
      12.times { (Item.create amount: 99, note: "测试", user_id: user1.id) }
      11.times { (Item.create amount: 99, note: "测试", user_id: user2.id) }
      get "/api/v1/items?page=1", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(10)
      expect(json.first["user_id"]).to eq(user1.id)
      get "/api/v1/items?page=2", headers: user1.generate_auth_hearder
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(2)
      expect(json.last["user_id"]).to eq(user1.id)
    end
  end

  describe "查询Items" do
    it "分页测试(无查询条件,包含页码和pagesize)" do
      user1 = User.create email: "1@qq.com"
      user2 = User.create email: "2@qq.com"
      11.times { (Item.create amount: 99, note: "测试", user_id: user1.id) }
      11.times { (Item.create amount: 99, note: "测试", user_id: user2.id) }
      get "/api/v1/items?page=1&size=20", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(11)
    end
  end

  describe "查询Items" do
    it "分页测试(包含查询条件)" do
      user1 = User.create email: "1@qq.com"
      user2 = User.create email: "2@qq.com"
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user2.id)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user2.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user2.id)
      get "/api/v1/items?page=1&created_before=2019-01-03&created_after=2019-01-01", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
    end
  end

  describe "查询Items" do
    it "分页测试(包含查询条件,边界条件,部分条件)" do
      user1 = User.create email: "1@qq.com"
      user2 = User.create email: "2@qq.com"
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-01", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user1.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user2.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-01", user_id: user2.id)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user2.id)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user2.id)
      get "/api/v1/items?page=1&created_before=2019-01-03&created_after=2019-01-01", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(2)
      get "/api/v1/items?created_after=2018-07-01", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(3)
    end
  end

  describe "创建Items" do
    it "根据id搜索" do
      user1 = User.create email: "j@qq.com"
      expect {
        3.times { (Item.create amount: 99, note: "测试", user_id: user1.id) }
      }.to change { Item.count }.by(+3)
      item = Item.create amount: 80
      expect(Item.count).to eq(4)
      get "/api/v1/items/#{item["id"]}", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson["id"]).to eq(item["id"])
    end
  end
end
