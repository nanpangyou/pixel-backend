require "rails_helper"

RSpec.describe User, type: :model do
  it "有 email" do
    user = User.new name: "Lewis", email: "yi@163.com"
    expect(user.email).to eq "yi@163.com"
  end
end
