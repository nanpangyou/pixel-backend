require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "创建Items" do
    it "通过Items类创建item测试" do
      expect {
        3.times { (Item.create! amount: 99, happen_at: Time.now, note: "测试", happen_at: Time.now) }
      }.to change { Item.count }.by(+3)
    end
  end

  describe "创建Items" do
    it "未登录创建items" do
      post "/api/v1/items", params: { amount: 113 }
      expect(response).to have_http_status(401)
    end

    it "通过post方法创建item测试(参数不全)" do
      user1 = User.create email: "1@qq.com"
      post "/api/v1/items", params: { amount: 113 }, headers: user1.generate_auth_hearder
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["msg"]["happen_at"]).to eq ["can't be blank"]
      post "/api/v1/items", params: { happen_at: Time.now }, headers: user1.generate_auth_hearder
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["msg"]["amount"]).to eq ["can't be blank"]
    end

    xit "通过post方法创建item测试(非法kind)" do
      user1 = User.create email: "1@qq.com"
      post "/api/v1/items", params: { amount: 113, happen_at: "2019-01-02", kind: 4 }, headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["kind"]).to eq "expense"
    end

    it "通过post方法创建item测试(kind=0)" do
      user1 = User.create email: "1@qq.com"
      post "/api/v1/items", params: { amount: 113, happen_at: "2019-01-02", kind: 0 }, headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["kind"]).to eq "income"
    end

    it "通过post方法创建item测试,校验tags_id" do
      user1 = User.create email: "1@qq.com"
      new_tag = Tag.create name: "xx", sign: "yy", user_id: user1.id
      another_new_tag = Tag.create name: "x2", sign: "y2", user_id: user1.id
      post "/api/v1/items", params: { amount: 113, happen_at: Time.now, tags_id: [1, 2] }, headers: user1.generate_auth_hearder
      expect(response).to have_http_status(422)
    end

    it "通过post方法创建item测试" do
      user1 = User.create email: "1@qq.com"
      new_tag = Tag.create name: "xx", sign: "yy", user_id: user1.id
      another_new_tag = Tag.create name: "x2", sign: "y2", user_id: user1.id
      expect {
        post "/api/v1/items", params: { amount: 113, happen_at: Time.now, tags_id: [new_tag.id, another_new_tag.id] }, headers: user1.generate_auth_hearder
      }.to change { Item.count }.by(+1)
      get "/api/v1/items", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["records"]
      expect(json.size).to eq(1)
      expect(json[0]["amount"]).to eq(113)
      expect(json[0]["user_id"]).to eq(user1.id)
      expect(json[0]["tags_id"]).to eq([new_tag.id, another_new_tag.id])
    end
  end

  describe "查询Items" do
    it "分页测试(无查询条件,只有页码)" do
      user1 = User.create email: "1@qq.com"
      user2 = User.create email: "1@qq.com"
      12.times { (Item.create amount: 99, note: "测试", happen_at: Time.now, user_id: user1.id) }
      11.times { (Item.create amount: 99, note: "测试", happen_at: Time.now, user_id: user2.id) }
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
      11.times { (Item.create amount: 99, note: "测试", user_id: user1.id, happen_at: Time.now) }
      11.times { (Item.create amount: 99, note: "测试", user_id: user2.id, happen_at: Time.now) }
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
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user2.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user2.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user2.id, happen_at: Time.now)
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
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-01", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user1.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-02", user_id: user2.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-01", user_id: user2.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2018-01-02", user_id: user2.id, happen_at: Time.now)
      Item.create(amount: 99, note: "测试", created_at: "2019-01-05", user_id: user2.id, happen_at: Time.now)
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
        3.times { (Item.create amount: 99, note: "测试", user_id: user1.id, happen_at: Time.now) }
      }.to change { Item.count }.by(+3)
      item = Item.create amount: 80, happen_at: Time.now
      expect(Item.count).to eq(4)
      get "/api/v1/items/#{item["id"]}", headers: user1.generate_auth_hearder
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson["id"]).to eq(item["id"])
    end
  end

  describe "查询汇总" do
    it "根据时间排序" do
      user1 = User.create email: "x@qq.com"
      Item.create(amount: 100, note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 200, note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 300, note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 0)
      Item.create(amount: 100, note: "测试", happen_at: "2019-06-17T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 200, note: "测试", happen_at: "2019-06-17T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 300, note: "测试", happen_at: "2019-06-17T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 100, note: "测试", happen_at: "2019-06-18T00:00:00+08:00", user_id: user1.id, kind: 0)
      Item.create(amount: 200, note: "测试", happen_at: "2019-06-18T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 300, note: "测试", happen_at: "2019-06-18T00:00:00+08:00", user_id: user1.id, kind: 1)

      get "/api/v1/items/summary",
          params: {
            start_date: "2019-01-16", end_date: "2019-12-18", group_by: "happen_at", kind: 1,
          }, headers: user1.generate_auth_hearder

      # 返参格式
      # { groups: [{ happen_at: "xxx", amount: 11 }, { happen_at: "yy", amount: 22 }], total: 33 }
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson["groups"][0]["happen_at"]).to eq("2019-06-16")
      expect(responseJson["groups"][0]["amount"]).to eq(300)
      expect(responseJson["groups"][1]["happen_at"]).to eq("2019-06-17")
      expect(responseJson["groups"][1]["amount"]).to eq(600)
      expect(responseJson["groups"][2]["happen_at"]).to eq("2019-06-18")
      expect(responseJson["groups"][2]["amount"]).to eq(500)
      expect(responseJson["total"]).to eq(1400)
    end

    it "根据tag_id分类" do
      user1 = User.create email: "x@qq.com"
      tag1 = Tag.create(name: "tag1", sign: "x", user_id: user1.id)
      tag2 = Tag.create(name: "tag2", sign: "x", user_id: user1.id)
      tag3 = Tag.create(name: "tag3", sign: "x", user_id: user1.id)
      Item.create(amount: 100, tags_id: [tag1.id, tag2.id], note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 200, tags_id: [tag2.id, tag3.id], note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 1)
      Item.create(amount: 300, tags_id: [tag1.id, tag3.id], note: "测试", happen_at: "2019-06-16T00:00:00+08:00", user_id: user1.id, kind: 0)
      Item.create(amount: 100, tags_id: [tag3.id], note: "测试", happen_at: "2019-06-17T00:00:00+08:00", user_id: user1.id, kind: 1)

      get "/api/v1/items/summary",
          params: {
            start_date: "2019-01-16", end_date: "2019-12-18", group_by: "tags_id", kind: 1,
          }, headers: user1.generate_auth_hearder

      # 返参格式
      # { groups: [{ tag_id: "xxx", amount: 11 }, { tag_id: "yy", amount: 22 }], total: 33 }
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson["groups"][0]["tags_id"]).to eq(tag1.id)
      expect(responseJson["groups"][0]["amount"]).to eq(100)
      expect(responseJson["groups"][1]["tags_id"]).to eq(tag2.id)
      expect(responseJson["groups"][1]["amount"]).to eq(300)
      expect(responseJson["groups"][2]["tags_id"]).to eq(tag3.id)
      expect(responseJson["groups"][2]["amount"]).to eq(300)
      expect(responseJson["total"]).to eq(400)
    end
  end
end
