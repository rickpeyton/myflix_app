class RegisterMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @link = "http://rickflix.heroku.com"
    mail(from: "peytorb@gmail.com", to: @user.email, subject: "Welcome to MyFlix! A project by Rick Peyton")
  end

  def forgot_password_email(user)
    @user = user
    @link = "http://rickflix.heroku.com/reset-password/#{@user.token}"
    mail(from: "peytorb@gmail.com", to: @user.email, subject: "MyFlix! Password Reset Instructions")
  end
end
