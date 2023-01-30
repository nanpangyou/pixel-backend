require "rails_helper"
require "rspec_api_documentation/dsl"

resource "items查询" do
  get "/api/v1/items" do
    #认证方式 basic => 以 Bearer 开头的 token auth => 变量，存放jwt
    authentication :basic, :auth
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
    let(:current_user) { User.create email: "1@qq.com" }
    let(:auth) { "Bearer #{current_user.generate_jwt}" }

    example "获取账目" do
      11.times { Item.create(amount: 99, note: "测试", created_at: "2018-10-22", user_id: current_user.id) }
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["records"].size).to eq 10
    end
  end
end
