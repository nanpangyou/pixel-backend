require "rails_helper"
require "rspec_api_documentation/dsl"

resource "验证码" do
  post "/api/v1/validation_codes" do
    # This is manual way to describe complex parameters
    #     parameter :email, type: :string
    #     let(:email) { "1@foxmail.com" }

    # This is automatic way
    # It's possible because we extract parameters definitions from the values
    parameter :email, with_example: true
    let(:email) { "1@foxmail.com" }

    example "测试发送验证码" do
      do_request
      expect(response_body) == " "
      expect(status).to eq 200
    end
  end
end
