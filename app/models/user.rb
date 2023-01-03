class User < ApplicationRecord
  # 校验相关字段 presence 表示不能为空
  validates :email, presence: true
end
