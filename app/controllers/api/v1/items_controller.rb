class Api::V1::ItemsController < ApplicationController
  def create
    item = Item.new amount: 99, note: "测试"
    isSave = item.save
    if isSave
      render json: item
    else
      render json: item.errors
    end
  end

  def index
    p "12313"
  end

  def show
    itemId = params[:id]
    selectedItem = Item.find_by_id(itemId)
    if selectedItem
      render json: selectedItem
    else
      render json: { msg: "没有此项" }, status: 404
    end
  end
end
