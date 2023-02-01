class Api::V1::TagsController < ApplicationController
  include Pagy::Backend

  def index
    return render json: { msg: "请登录" }, status: :authentication if request.env["current_user_id"].nil?
    page = params[:page]
    pageSize = params[:size]
    selectTag = Tag.where(user_id: request.env["current_user_id"])
    #       .where(created_at: params[:created_after]..params[:created_before])
    if selectTag
      (@pagy, xx = pagy(selectTag, page: page, items: pageSize))
      render json: { page: @pagy, records: xx }
    else
      render json: { msg: selectTag.errors }, status: 404
    end
  end
end
