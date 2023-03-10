class ValidationCode < ApplicationRecord
  # 另一种生成code的方式，但是最少要24位，6位做不到，所以注释掉了
  # has_secure_token :code, length: 6

  # email参数为必填
  validates :email, presence: true

  before_create :generate_code
  after_create :send_email

  enum kind: { sign_in: 0, reset_password: 1 }

  def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end

  def send_email
    # UserMailer.welcome_email(self.email).deliver
    UserMailer.welcome_email(self.email)
  end
end
