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
end
