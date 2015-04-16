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
    @invitation = Invitation.find_by(token: params[:user][:friend_token])
    if @user.save
      create_relationship unless @invitation.nil?
      flash[:success] = "Your account has been created."
      session[:user_id] = @user.id
      RegisterMailer.welcome_email(@user).deliver
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

  def create_relationship
    leader = User.find(@invitation.user_id)
    Relationship.create(leader: leader, follower: @user)
  end
end
