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
    p "132"
  end

  def show
    p 4444444444
  end
end
