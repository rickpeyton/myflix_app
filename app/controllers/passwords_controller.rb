class PasswordsController < ApplicationController
  def new;end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      @user.update_attribute(:token, SecureRandom.urlsafe_base64)
      RegisterMailer.forgot_password_email(@user).deliver
    end
    flash[:success] = "Password reset instructions have been send to the specified email."
    redirect_to root_path
  end
end
