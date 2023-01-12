class UserMailer < ApplicationMailer
  def welcome_email(code)
    #     @user = params[:user]
    #     @url = "http://example.com/login"
    @code = code
    mail(to: "yigehd@foxmail.com", subject: "mail subject")
  end
end
