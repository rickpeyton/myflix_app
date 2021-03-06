class InvitationsController < ApplicationController
  before_action :require_user, only: [:new]
  def new
    @user_id = current_user.id
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if current_user.id == @invitation.user_id && @invitation.save
      @invitation.generate_token
      InvitationMailer.delay.invitation_email(@invitation)
      flash[:success] = "An invitation has been sent to your friend!"
      redirect_to home_path
    else
      flash[:danger] = "An invitation could not be created."
      render :new
    end
  end

  private

    def invitation_params
      params.require(:invitation).permit(:user_id, :friend_name, :friend_email, :message)
    end
end
