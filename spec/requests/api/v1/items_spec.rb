require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "创建Items" do
    it "创建item测试" do
      3.times { (Item.create amount: 99, note: "测试") }
      expect {
        3.times { (Item.create amount: 99, note: "测试") }
      }.to change { Item.count }.by(+3)
    end
  end

  describe "查询Items" do
    it "分页测试(无查询条件,只有页码)" do
      11.times { (Item.create amount: 99, note: "测试") }
      get "/api/v1/items?page=1"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(10)
      get "/api/v1/items?page=2"
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
    end
  end

  describe "查询Items" do
    it "分页测试(无查询条件,包含页码和pagesize)" do
      11.times { (Item.create amount: 99, note: "测试") }
      get "/api/v1/items?page=1&size=20"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(11)
    end
  end

  describe "查询Items" do
    it "分页测试(包含查询条件)" do
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02")
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02")
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05")
      get "/api/v1/items?page=1&created_before=2019-01-03&created_after=2019-01-01"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
    end
  end

  describe "查询Items" do
    it "分页测试(包含查询条件,边界条件,部分条件)" do
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02")
      Item.create(amount: 99, note: "测试", created_at: "2019-01-01")
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02")
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05")
      get "/api/v1/items?page=1&created_before=2019-01-03&created_after=2019-01-01"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(2)
      get "/api/v1/items?created_after=2018-07-01"
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(3)
    end
  end

  describe "创建Items" do
    it "根据id搜索" do
      expect {
        3.times { (Item.create amount: 99, note: "测试") }
      }.to change { Item.count }.by(+3)
      item = Item.create amount: 80
      expect(Item.count).to eq(4)
      get "/api/v1/items/#{item["id"]}"
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson["id"]).to eq(item["id"])
    end
  end
end
