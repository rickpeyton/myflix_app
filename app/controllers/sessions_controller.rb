class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "You have logged in."
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:danger] = "That combination is incorrect."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to root_path
  end
end
