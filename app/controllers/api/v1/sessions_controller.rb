require "jwt"

class Api::V1::SessionsController < ApplicationController
  def create
    # 如果是测试环境，验证码为123456
    if Rails.env.test?
      return render status: 401 if params[:code] != "123456"
    else
      can_sign_in = ValidationCode.exists?(email: params[:email], code: params[:code], used_at: nil)
      return render status: 401, json: { error: "验证码错误" } unless can_sign_in
    end
    user = User.find_by(email: params[:email])
    return render status: 404, json: { error: "用户不存在" } if user.nil?
    payload = { userId: user.id }
    token = JWT.encode payload, Rails.application.credentials.hmac_secret, "HS256"
    render status: :ok, json: { token: token }
  end
end
