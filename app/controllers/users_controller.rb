class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    redirect_to home_path if logged_in?
    if Invitation.find_by(token: params[:token])
      @token = params[:token]
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(
      params[:stripeToken], params[:user][:friend_token]
    )
    if result.successful?
      flash[:success] = "Your account has been created."
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:danger] = result.error_message
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end


end
