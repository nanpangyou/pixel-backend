require "rails_helper"
require "rspec_api_documentation/dsl"

resource "登录" do
  post "/api/v1/session" do
    # 入参参数描述
    parameter :email, "邮箱", required: true
    parameter :code, "验证码", required: true
    # 反参参数描述
    response_field :token, "JwtToken"

    let(:email) { "1@foxmail.com" }
    let(:code) { "123456" }

    example "测试发送验证码" do
      do_request
      expect(status).to eq 200
      json = JSON.parse(response_body)
      expect(response_body).to be_a String
    end
  end
end
