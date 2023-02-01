require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Tags查询" do
  get "/api/v1/tags" do
    #认证方式 basic => 以 Bearer 开头的 token auth => 变量，存放jwt
    authentication :basic, :auth
    # 入参描述
    parameter :page, "页码", required: false
    parameter :size, "每页数量", required: false
    # 返参描述
    with_options :scope => :records do
      response_field :id, "id"
      response_field :user_id, "所属用户id"
      response_field :name, "名称"
      response_field :sign, "符号"
      response_field :delete_at, "删除时间"
    end
    with_options :scope => :page do
      response_field :page, "页码"
      response_field :items, "每页数量"
      response_field :pages, "总页数"
      response_field :count, "总数量"
    end

    let(:current_user) { User.create email: "1@qq.com" }
    let(:auth) { "Bearer #{current_user.generate_jwt}" }

    example "获取账目" do
      11.times do |i| Tag.create(name: "tags #{i}", sign: "测试 #{i}", user_id: current_user.id) end
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["records"].size).to eq 10
    end
  end
end
