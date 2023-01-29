class Api::V1::MesController < ApplicationController
  def show
    userId = request.env["current_user_id"] rescue nil
    # 获取用户
    user = User.find_by(id: userId)
    return render status: 404 if user.nil?
    # 返回用户信息
    render status: :ok, json: { data: user }
  end
end
