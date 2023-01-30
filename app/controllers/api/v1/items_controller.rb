class Api::V1::ItemsController < ApplicationController
  include Pagy::Backend

  def create
    return render status: 401, json: { error: "用户未登录" } if request.env["current_user_id"].nil?
    item = Item.new amount: params[:amount], note: params[:note], user_id: request.env["current_user_id"]
    isSave = item.save
    if isSave
      render json: item
    else
      render json: item.errors
    end
  end

  def index
    return render status: 401, json: { error: "用户未登录" } if request.env["current_user_id"].nil?
    page = params[:page]
    pageSize = params[:size]
    selectItem = Item.where(user_id: request.env["current_user_id"])
      .where(created_at: params[:created_after]..params[:created_before])
    if (@pagy, xx = pagy(selectItem, page: page, items: pageSize))
      render json: { page: @pagy, records: xx }
    end
  end

  def show
    return render status: 401, json: { error: "用户未登录" } if request.env["current_user_id"].nil?
    item_id = params[:id]
    selectedItem = Item.find_by_id(item_id)
    if selectedItem
      render json: selectedItem
    else
      render json: { msg: "没有此项" }, status: 404
    end
  end
end
