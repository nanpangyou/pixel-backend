class UserMailer < ApplicationMailer
  def welcome_email(email)
    #     @user = params[:user]
    #     @url = "http://example.com/login"
    code = ValidationCode.find_by_email(email).code
    @code = code
    mail(to: email, subject: "Pixel验证码")
  end
end
