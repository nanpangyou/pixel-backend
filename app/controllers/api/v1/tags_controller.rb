class Api::V1::TagsController < ApplicationController
  include Pagy::Backend

  def index
    return render json: { msg: "请登录" }, status: :authentication if request.env["current_user_id"].nil?
    page = params[:page]
    pageSize = params[:size]
    selectTag = Tag.where(user_id: request.env["current_user_id"]).where(delete_at: nil)
    #       .where(created_at: params[:created_after]..params[:created_before])
    if selectTag
      (@pagy, xx = pagy(selectTag, page: page, items: pageSize))
      render json: { page: @pagy, records: xx }
    else
      render json: { msg: selectTag.errors }, status: 404
    end
  end

  def create
    return render json: { msg: "请登录" }, status: :authentication if request.env["current_user_id"].nil?
    newTag = Tag.new sign: params[:sign], name: params[:name], user_id: request.env["current_user_id"]
    if newTag.save
      return render json: newTag, status: :ok
    else
      return render json: { msg: newTag.errors }, status: :unprocessable_entity
    end
  end

  def update
    return render json: { msg: "请登录" }, status: :authentication if request.env["current_user_id"].nil?
    selectTag = Tag.where(user_id: request.env["current_user_id"]).find_by_id(params[:id])
    if selectTag
      selectTag.update params.permit(:sign, :name)
    else
      return render json: { msg: "没有此项" }, status: 404
    end
    if selectTag.errors.empty?
      return render json: selectTag, status: :ok
    else
      return render json: { msg: selectTag.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { msg: "请登录" }, status: :authentication if request.env["current_user_id"].nil?
    ready_to_delete_tag = Tag.where(user_id: request.env["current_user_id"]).find_by_id(params[:id])
    if ready_to_delete_tag
      # 删除Tag
      ready_to_delete_tag.delete_at = Time.now
    else
      return head :forbidden
    end
    if ready_to_delete_tag.save
      head :ok
    else
      return render json: { msg: ready_to_delete_tag.errors }, status: :unprocessable_entity
    end
  end
end
