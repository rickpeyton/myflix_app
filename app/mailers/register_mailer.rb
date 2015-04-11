class RegisterMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    @link = "http://rickflix.heroku.com"
    mail(from: "peytorb@gmail.com", to: @user.email, subject: "Welcome to MyFlix! A project by Rick Peyton")
  end
end
