class UserMailer < ActionMailer::Base
  default from: "tingfchang@gmail.com"

  def delete_user_email(user)
    @user = user
    @url = "http://localhost:3000"
    mail(to: @user.email, subject: "Your user account at Rotten Mangoes was deleted")
  end
end
