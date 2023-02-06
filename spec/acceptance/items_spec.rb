require "rails_helper"
require "rspec_api_documentation/dsl"

resource "items查询" do
  #认证方式 basic => 以 Bearer 开头的 token auth => 变量，存放jwt
  authentication :basic, :auth
  let(:current_user) { User.create email: "1@qq.com" }
  let(:auth) { "Bearer #{current_user.generate_jwt}" }
  get "/api/v1/items" do
    # 入参描述
    parameter :page, "页码", required: false
    parameter :size, "每页数量", required: false
    parameter :created_after, "创建起始时间", required: false
    parameter :created_before, "创建终止时间", required: false
    # 返参描述
    with_options :scope => :records do
      response_field :id, "id"
      response_field :amount, "金额"
    end
    with_options :scope => :page do
      response_field :page, "页码"
      response_field :items, "每页数量"
      response_field :pages, "总页数"
      response_field :count, "总数量"
    end

    let(:created_after) { "2018-01-02" }
    let(:created_before) { "2019-01-02" }

    example "获取账目" do
      11.times { Item.create!(amount: 99, note: "测试", created_at: "2018-10-22", user_id: current_user.id, happen_at: Time.now) }
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["records"].size).to eq 10
    end
  end

  post "/api/v1/items" do

    # 入参描述
    parameter :amount, "金额", required: true
    parameter :happen_at, "金额产生日期", required: true
    parameter :tags_id, "标签id列表", required: false
    parameter :kind, "类型: 1=> expense, 0=>income", required: false
    # 返参描述
    response_field :id, "id"
    response_field :amount, "金额"
    response_field :happen_at, "金额产生日期"
    response_field :tags_id, "标签id列表"
    response_field :user_id, "用户id"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"

    let(:item1) { Tag.create name: "xx", sign: "yy", user_id: current_user.id }
    let(:item2) { Tag.create name: "xx", sign: "yy", user_id: current_user.id }
    let(:amount) { 90 }
    let(:kind) { 0 }
    let(:happen_at) { "2019-01-02" }
    let(:tags_id) { [item1.id, item2.id] }

    example "创建账目" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["amount"]).to eq 90
      expect(json["happen_at"]).to eq "2019-01-02T00:00:00.000Z"
      expect(json["user_id"]).to eq current_user.id
      expect(json["kind"]).to eq "income"
    end
  end

  get "/api/v1/items/summary" do

    # 入参描述
    parameter :happened_after, "起始日期", required: true
    parameter :happened_before, "终止日期", required: true
    parameter :group_by, "金额产生日期('happen_at','tags_id')", required: true
    parameter :kind, "类型: 1=> expense, 0=>income", required: false
    # 返参描述
    response_field :groups, "分组信息"
    response_field :total, "总数(单位： 分)"

    let(:happened_after) { "2018-01-01" }
    let(:happened_before) { "2020-01-01" }

    example "统计信息（按happen_at分组）" do
      user = current_user
      tag = Tag.create! name: "tag1", sign: "x", user_id: user.id
      Item.create! amount: 100, kind: 1, tags_id: [tag.id], happen_at: "2018-06-18T00:00:00+08:00", user_id: user.id
      Item.create! amount: 200, kind: 1, tags_id: [tag.id], happen_at: "2018-06-18T00:00:00+08:00", user_id: user.id
      Item.create! amount: 100, kind: 1, tags_id: [tag.id], happen_at: "2018-06-20T00:00:00+08:00", user_id: user.id
      Item.create! amount: 200, kind: 1, tags_id: [tag.id], happen_at: "2018-06-20T00:00:00+08:00", user_id: user.id
      Item.create! amount: 100, kind: 1, tags_id: [tag.id], happen_at: "2018-06-19T00:00:00+08:00", user_id: user.id
      Item.create! amount: 200, kind: 1, tags_id: [tag.id], happen_at: "2018-06-19T00:00:00+08:00", user_id: user.id
      do_request group_by: "happen_at"
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["groups"].size).to eq 3
      expect(json["groups"][0]["happen_at"]).to eq "2018-06-18"
      expect(json["groups"][0]["amount"]).to eq 300
      expect(json["groups"][1]["happen_at"]).to eq "2018-06-19"
      expect(json["groups"][1]["amount"]).to eq 300
      expect(json["groups"][2]["happen_at"]).to eq "2018-06-20"
      expect(json["groups"][2]["amount"]).to eq 300
      expect(json["total"]).to eq 900
    end

    example "统计信息（按tag_id分组）" do
      user = current_user
      tag1 = Tag.create! name: "tag1", sign: "x", user_id: user.id
      tag2 = Tag.create! name: "tag2", sign: "x", user_id: user.id
      tag3 = Tag.create! name: "tag3", sign: "x", user_id: user.id
      Item.create! amount: 100, kind: 1, tags_id: [tag1.id, tag2.id], happen_at: "2018-06-18T00:00:00+08:00", user_id: user.id
      Item.create! amount: 200, kind: 1, tags_id: [tag2.id, tag3.id], happen_at: "2018-06-18T00:00:00+08:00", user_id: user.id
      Item.create! amount: 300, kind: 1, tags_id: [tag3.id, tag1.id], happen_at: "2018-06-18T00:00:00+08:00", user_id: user.id
      do_request group_by: "tags_id"
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["groups"].size).to eq 3
      expect(json["groups"][0]["tags_id"]).to eq tag3.id
      expect(json["groups"][0]["amount"]).to eq 500
      expect(json["groups"][1]["tags_id"]).to eq tag1.id
      expect(json["groups"][1]["amount"]).to eq 400
      expect(json["groups"][2]["tags_id"]).to eq tag2.id
      expect(json["groups"][2]["amount"]).to eq 300
      expect(json["total"]).to eq 600
    end
  end
end
