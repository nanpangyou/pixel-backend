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
    # 下面有更好的方法
    # user = User.find_by(email: params[:email])
    # user = User.create email: params[:email] if user.nil?

    # 根据email查找user，如果找不到就创建user
    user = User.find_or_create_by(email: params[:email])
    render status: :ok, json: { token: user.generate_jwt }
  end
end
