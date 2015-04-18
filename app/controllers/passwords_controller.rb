class PasswordsController < ApplicationController
  before_action :token_check, only: [:show, :update]

  def show
  end

  def new;end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      @user.generate_token
      RegisterMailer.forgot_password_email(@user).deliver
    end
    flash[:success] = "Password reset instructions have been send to the specified email."
    redirect_to root_path
  end

  def update
    @user = User.find_by(token: params[:id])
    if @user.update(password: params[:password], token: nil)
      flash[:success] = "Your password has been updated. Please sign in."
      redirect_to sign_in_path
    else
      flash[:danger] = "#{@user.errors.full_messages.first}"
      render :show
    end
  end

  private

  def token_check
    redirect_to invalid_token_path unless User.find_by(token: params[:id]).present?
  end
end
