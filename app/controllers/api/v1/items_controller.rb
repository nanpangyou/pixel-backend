class Api::V1::ItemsController < ApplicationController
  include Pagy::Backend

  def create
    item = Item.new
    isSave = item.save
    if isSave
      render json: item
    else
      render json: item.errors
    end
  end

  def index
    page = params[:page]
    pageSize = params[:size]
    selectItem = Item.where(created_at: params[:created_after]..params[:created_before])
    if (@pagy, xx = pagy(selectItem, page: page, items: pageSize))
      render json: { page: @pagy, records: xx }
    end
  end

  def show
    item_id = params[:id]
    selectedItem = Item.find_by_id(item_id)
    if selectedItem
      render json: selectedItem
    else
      render json: { msg: "没有此项" }, status: 404
    end
  end
end
