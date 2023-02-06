class Api::V1::ItemsController < ApplicationController
  include Pagy::Backend

  def create
    return render status: 401, json: { error: "用户未登录" } if request.env["current_user_id"].nil?
    permitted_params = params.permit(:amount, :kind, :note, :happen_at, "tags_id": [])
    permitted_params[:kind] = permitted_params[:kind].to_i
    item = Item.new permitted_params
    item.user_id = request.env["current_user_id"]
    isSave = item.save
    if isSave
      render json: item
    else
      render json: { msg: item.errors }, status: :unprocessable_entity
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

  def summary
    return render status: 401, json: { error: "用户未登录" } if request.env["current_user_id"].nil?
    selectItem = Item
      .where(user_id: request.env["current_user_id"])
      .where(created_at: params[:created_after]..params[:created_before])
      .where(kind: params[:kind])
    hash = Hash.new
    if (params[:group_by] == "tags_id")
      selectItem.each do |item|
        item.tags_id.each do |tag_id|
          key = tag_id
          hash[key] = 0 if hash[key].nil?
          hash[key] += item.amount
        end
      end
    elsif (params[:group_by] == "happen_at")
      selectItem.each do |item|
        # 注意时区的问题
        # key = item.happen_at.strftime("%Y-%m-%d")
        key = item.happen_at.in_time_zone("Beijing").strftime("%F")
        hash[key] = 0 if hash[key].nil?
        hash[key] += item.amount
      end
    end
    groups = hash
      .map { |key, value| { "#{params[:group_by]}": key, amount: value } }
    if (params["#{params[:group_by]}"] == "happen_at")
      groups.sort! { |a, b| a[:happen_at] <=> b[:happen_at] }
    elsif (params["#{params[:group_by]}"] == "tags_id")
      groups.sort! { |a, b| a[:amount] <=> b[:amount] }
    end
    return render json: {
                    groups: groups,
                    total: selectItem.sum(:amount),
                  }
  end
end
