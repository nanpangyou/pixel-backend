require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Tags查询" do
  #认证方式 basic => 以 Bearer 开头的 token auth => 变量，存放jwt
  authentication :basic, :auth
  let(:current_user) { User.create email: "1@qq.com" }
  let(:auth) { "Bearer #{current_user.generate_jwt}" }
  get "/api/v1/tags" do
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

    example "获取标签" do
      11.times do |i| Tag.create(name: "tags #{i}", sign: "测试 #{i}", user_id: current_user.id) end
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["records"].size).to eq 10
    end
  end

  post "/api/v1/tags" do
    # 入参描述
    parameter :name, "标签名称", required: false
    parameter :sign, "标签符号", required: false
    # 返参描述
    response_field :id, "id"
    response_field :user_id, "所属用户id"
    response_field :name, "名称"
    response_field :sign, "符号"
    response_field :delete_at, "删除时间"

    # 设置参数
    let(:name) { "x" }
    let(:sign) { "y" }

    example "创建标签" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json["name"]).to eq "x"
      expect(json["sign"]).to eq "y"
    end
  end
end
