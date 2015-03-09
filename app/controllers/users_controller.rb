class UsersController < ApplicationController
  def new
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Your account has been created."
      redirect_to home_path
    else
      flash[:danger] = "Something went wrong."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
