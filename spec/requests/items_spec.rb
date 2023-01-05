require 'rails_helper'

RSpec.describe "Items", type: :request do

  describe "创建Items" do
    it 'can create item' do
      3.times { (Item.new amount: 99, note: "测试").save }
      expect { 
        3.times{ (Item.new amount: 99, note: "测试").save } 
      }.to change { Item.count }.by(+3)
    end
  end

  describe "查询Items" do
    it 'can create item' do
      3.times { (Item.new amount: 99, note: "测试").save }
      get '/api/v1/items'
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)['records']
      expect(json.size).to eq(3)
      thirdItem = json[2]
      expect(thirdItem['amount']).to eq(99)
      expect(thirdItem['note']).to eq("测试")
      expect(thirdItem['id']).to be > 0
    end
  end

  describe "创建Items" do
    it 'can create item' do
      expect { 
        3.times{ (Item.new amount: 99, note: "测试").save } 
      }.to change { Item.count }.by(+3)
      item = Item.new amount: 80
      item.save
      expect(Item.count).to eq(4)
      get "/api/v1/items/#{item['id']}"
      expect(response).to have_http_status(200)
      responseJson = JSON.parse(response.body)
      expect(responseJson['id']).to eq(item['id'])
    end
  end
end
