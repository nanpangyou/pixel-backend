class HomeController < ApplicationController
  def index
    render json: { msg: "hello world" }
  end
end
