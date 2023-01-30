class UsersController < ApplicationController
  def show
    user = User.find_by_id params["id"]
    if user
      render json: user
    else
      # head 404
      render json: { error: "User not found" }, status: 404
    end
  end

  def create
    user = User.new name: "Lewis", email: "yi@163.com"
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end
end
