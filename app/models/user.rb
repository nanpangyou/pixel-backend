class User < ApplicationRecord
  # 校验相关字段 presence 表示不能为空
  validates :email, presence: true

  def generate_jwt
    payload = { userId: self.id }
    token = JWT.encode payload, Rails.application.credentials.hmac_secret, "HS256"
  end

  def generate_auth_hearder
    { Authorization: "Bearer #{self.generate_jwt}" }
  end
end
