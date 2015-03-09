class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "You have logged in."
      session[:user_id] = @user.id
      redirect_to home_path
    else
    end
  end

  def destroy

  end
end
