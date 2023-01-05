class ValidationCode < ApplicationRecord
  # 另一种生成code的方式，但是最少要24位，6位做不到，所以注释掉了
  # has_secure_token :code, length: 6
end
