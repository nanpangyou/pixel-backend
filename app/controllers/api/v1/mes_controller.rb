class Api::V1::MesController < ApplicationController
  def show
    # 从请求头中获取token
    token = request.headers["Authorization"].split(" ").last rescue ""
    # 解码token
    decoded_token = JWT.decode token, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" } rescue nil
    # 获取用户id
    return render status: 400 if decoded_token.nil?
    userId = decoded_token[0]["userId"] rescue nil
    # 获取用户
    user = User.find_by(id: userId)
    return render status: 404 if user.nil?
    # 返回用户信息
    render status: :ok, json: { data: user }
  end
end
