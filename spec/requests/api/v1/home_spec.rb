require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["msg"]).to eq("hello world")
    end
  end
end
